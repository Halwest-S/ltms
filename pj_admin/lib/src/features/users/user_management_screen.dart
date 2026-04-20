import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/api_provider.dart';
import '../../core/response_parsing.dart';
import '../../core/theme.dart';
import '../auth/auth_provider.dart';
import 'create_user_dialog.dart';

final usersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final response = await ref.read(apiClientProvider).getAdminUsers();
    return extractMapList(response.data);
  } on DioException catch (e) {
    if (e.response?.statusCode == 403) {
      throw Exception('Only super admins can manage users.');
    }
    rethrow;
  }
});

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final Set<int> _pendingUserIds = <int>{};
  final Map<int, bool> _optimisticActiveStates = <int, bool>{};

  bool _isActiveValue(dynamic value) => value == true || value == 1;

  int? _parseUserId(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  String _roleLabel(L10n l10n, String role) => switch (role) {
    'staff' => l10n.staff.toUpperCase(),
    'driver' => l10n.driver.toUpperCase(),
    'super_admin' => l10n.superAdmin.toUpperCase(),
    'customer' => l10n.customer.toUpperCase(),
    _ => role.toUpperCase(),
  };

  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final message = map['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }

        final errors = map['errors'];
        if (errors is Map) {
          for (final value in errors.values) {
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
          }
        }
      }

      if (error.message != null && error.message!.trim().isNotEmpty) {
        return error.message!;
      }
    }

    return error.toString();
  }

  Future<void> _toggleUserStatus(Map<String, dynamic> user) async {
    final userId = _parseUserId(user['id']);
    if (userId == null || _pendingUserIds.contains(userId)) return;

    final previous =
        _optimisticActiveStates[userId] ?? _isActiveValue(user['is_active']);
    final next = !previous;

    setState(() {
      _pendingUserIds.add(userId);
      _optimisticActiveStates[userId] = next;
    });

    try {
      await ref.read(apiClientProvider).toggleUserStatus(userId);
      final _ = await ref.refresh(usersProvider.future);
      if (!mounted) return;
      setState(() {
        _optimisticActiveStates.remove(userId);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _optimisticActiveStates[userId] = previous;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${L10n.of(context)!.error}: ${_extractErrorMessage(e)}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _pendingUserIds.remove(userId);
        });
      }
    }
  }

  Future<void> _deleteUser(Map<String, dynamic> user) async {
    final userId = _parseUserId(user['id']);
    if (userId == null || _pendingUserIds.contains(userId)) return;

    final name = (user['name'] ?? '').toString();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = L10n.of(context)!;
        return AlertDialog(
          title: Text(l10n.delete),
          content: Text(
            'Delete ${name.isEmpty ? 'this account' : name}? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.red),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() => _pendingUserIds.add(userId));

    try {
      await ref.read(apiClientProvider).deleteAdminUser(userId);
      ref.invalidate(usersProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Account deleted.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${L10n.of(context)!.error}: ${_extractErrorMessage(e)}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _pendingUserIds.remove(userId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final l10n = L10n.of(context)!;
    final usersAsync = ref.watch(usersProvider);
    final currentUser = ref.watch(authProvider);
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    return AdminShell(
      activeRoute: '/users',
      title: l10n.userManagement,
      actions: [
        IconButton(
          onPressed: () => ref.refresh(usersProvider),
          tooltip: l10n.refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await CreateUserDialog.show(context);
          if (result == true) {
            ref.invalidate(usersProvider);
          }
        },
        child: const Icon(Icons.add),
      ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) ...[
              Text(l10n.userManagement, style: tt.headlineLarge),
              const SizedBox(height: 4),
              Text(
                'Manage admins, staff, drivers, and customers',
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 16),
            ] else ...[
              Text(l10n.userManagement, style: tt.headlineSmall),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: usersAsync.when(
                data: (users) => ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final u = users[i];
                    final userId = _parseUserId(u['id']);
                    final active =
                        userId != null &&
                            _optimisticActiveStates.containsKey(userId)
                        ? _optimisticActiveStates[userId]!
                        : _isActiveValue(u['is_active']);
                    final isPending =
                        userId != null && _pendingUserIds.contains(userId);
                    final role = (u['role'] ?? '').toString();
                    final canModifyUser =
                        userId != null &&
                        userId != currentUser?.id &&
                        role != 'super_admin';
                    final roleColor = switch (role) {
                      'super_admin' => AppTheme.rose,
                      'staff' => const Color(0xFF6366F1),
                      'driver' => const Color(0xFFF97316),
                      _ => AppTheme.teal,
                    };
                    final roleBg = switch (role) {
                      'super_admin' => AppTheme.roseLight,
                      'staff' => const Color(0xFFEEF2FF),
                      'driver' => const Color(0xFFFFF7ED),
                      _ => AppTheme.tealLight,
                    };
                    final name = (u['name'] ?? '').toString();
                    final email = (u['email'] ?? '').toString();
                    final phone = (u['phone_number'] ?? '').toString();
                    final avatarText = name.isNotEmpty
                        ? name[0].toUpperCase()
                        : '?';

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: isCompact
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _avatar(roleColor, avatarText),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.ink,
                                            ),
                                          ),
                                          Text(
                                            email,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.muted,
                                            ),
                                          ),
                                          if (phone.isNotEmpty)
                                            Text(
                                              phone,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.muted,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: roleBg,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      child: Text(
                                        _roleLabel(l10n, role),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: roleColor,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: 56,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Switch(
                                            value: active,
                                            onChanged:
                                                isPending || !canModifyUser
                                                ? null
                                                : (_) => _toggleUserStatus(u),
                                            activeThumbColor: Colors.white,
                                            activeTrackColor: AppTheme.teal,
                                            inactiveThumbColor: Colors.white,
                                            inactiveTrackColor: AppTheme.border,
                                          ),
                                          if (isPending)
                                            const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: isPending || !canModifyUser
                                          ? null
                                          : () => _deleteUser(u),
                                      tooltip: l10n.delete,
                                      color: AppTheme.red,
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                _avatar(roleColor, avatarText),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.ink,
                                        ),
                                      ),
                                      Text(
                                        email,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.muted,
                                        ),
                                      ),
                                      if (phone.isNotEmpty)
                                        Text(
                                          phone,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.muted,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: roleBg,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    _roleLabel(l10n, role),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: roleColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 56,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Switch(
                                        value: active,
                                        onChanged: isPending || !canModifyUser
                                            ? null
                                            : (_) => _toggleUserStatus(u),
                                        activeThumbColor: Colors.white,
                                        activeTrackColor: AppTheme.teal,
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor: AppTheme.border,
                                      ),
                                      if (isPending)
                                        const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: isPending || !canModifyUser
                                      ? null
                                      : () => _deleteUser(u),
                                  tooltip: l10n.delete,
                                  color: AppTheme.red,
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('${l10n.error}: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(Color roleColor, String avatarText) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [roleColor, roleColor.withAlpha(180)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          avatarText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
