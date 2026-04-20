import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';

import '../../core/api_provider.dart';
import '../../core/theme.dart';
import '../auth/auth_provider.dart';
import '../shell/main_shell.dart';
import '../shipments/assigned_shipments_screen.dart';
import 'shipment_stats_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final user = ref.watch(authProvider);
    final shipmentsAsync = ref.watch(driverShipmentsProvider);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.account, style: textTheme.displaySmall),
              const SizedBox(height: 2),
              Text(l10n.manageAccount, style: textTheme.bodySmall),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.ink, Color(0xFF1E2038)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.orange.withAlpha(40),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.orange, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          (user?.name ?? 'D')[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.orange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? l10n.driver,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            user?.email ?? 'driver@ltms.app',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withAlpha(150),
                            ),
                          ),
                          if (user?.phoneNumber != null &&
                              user!.phoneNumber!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              user.phoneNumber!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withAlpha(150),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        l10n.edit,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              shipmentsAsync.when(
                data: (shipments) => ShipmentStatsWidget(shipments: shipments),
                loading: () => const SizedBox(height: 100),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),
              _menuItem(
                context,
                icon: Icons.history_rounded,
                color: AppTheme.blue,
                title: l10n.myShipments,
                subtitle: l10n.viewHistory,
                onTap: () =>
                    ref.read(driverBottomNavProvider.notifier).state = 1,
              ),
              _menuItem(
                context,
                icon: Icons.security_rounded,
                color: AppTheme.teal,
                title: l10n.security,
                subtitle: l10n.passwordSubtitleUpdate,
                onTap: () => _showUpdatePassword(context),
              ),
              _menuItem(
                context,
                icon: Icons.notifications_active_rounded,
                color: AppTheme.indigo,
                title: l10n.notifications,
                subtitle: l10n.alertsSubtitle,
                onTap: () =>
                    ref.read(driverBottomNavProvider.notifier).state = 2,
              ),
              _menuItem(
                context,
                icon: Icons.language_rounded,
                color: AppTheme.blue,
                title: l10n.language,
                subtitle: l10n.languageSubtitle,
                trailing: Text(
                  l10n.localeName == 'ku' ? 'KU' : 'EN',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.blue,
                  ),
                ),
                onTap: () => _showLanguagePicker(context, ref),
              ),
              _menuItem(
                context,
                icon: Icons.help_outline_rounded,
                color: Colors.blueGrey,
                title: l10n.help,
                subtitle: l10n.faqSubtitle,
                onTap: () {},
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _confirmLogout(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.redLight,
                    foregroundColor: AppTheme.red,
                    elevation: 0,
                    side: const BorderSide(color: Color(0xFFFEE2E2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        l10n.logout,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  l10n.versionInfo,
                  style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              trailing ??
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.muted,
                    size: 20,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.language,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.language_rounded),
              title: Text(
                l10n.english,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing: l10n.localeName == 'en'
                  ? const Icon(Icons.check_circle, color: AppTheme.blue)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                if (sheetContext.mounted) Navigator.pop(sheetContext);
              },
            ),
            ListTile(
              leading: const Icon(Icons.translate_rounded),
              title: Text(
                l10n.kurdish,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing: l10n.localeName == 'ku'
                  ? const Icon(Icons.check_circle, color: AppTheme.blue)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('ku'));
                if (sheetContext.mounted) Navigator.pop(sheetContext);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showUpdatePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _ChangePasswordDialog(),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.signOut,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(l10n.signOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: AppTheme.muted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            child: Text(
              l10n.logout,
              style: const TextStyle(
                color: AppTheme.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordDialog extends ConsumerStatefulWidget {
  const _ChangePasswordDialog();

  @override
  ConsumerState<_ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<_ChangePasswordDialog> {
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = L10n.of(context)!;
    final currentPassword = _currentPasswordCtrl.text;
    final newPassword = _newPasswordCtrl.text;
    final confirmPassword = _confirmPasswordCtrl.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.required),
          backgroundColor: AppTheme.red,
        ),
      );
      return;
    }

    if (newPassword.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.passwordMin8),
          backgroundColor: AppTheme.red,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.passwordMismatch),
          backgroundColor: AppTheme.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(apiClientProvider).changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            newPasswordConfirmation: confirmPassword,
          );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password updated successfully.'),
          backgroundColor: AppTheme.teal,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.error}: $e'),
          backgroundColor: AppTheme.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        l10n.changePassword,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _currentPasswordCtrl,
            obscureText: _obscureCurrent,
            decoration: InputDecoration(
              labelText: l10n.currentPasswordLabel,
              hintText: l10n.passwordPlaceholder,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _obscureCurrent = !_obscureCurrent);
                },
                icon: Icon(
                  _obscureCurrent
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _newPasswordCtrl,
            obscureText: _obscureNew,
            decoration: InputDecoration(
              labelText: l10n.newPasswordLabel,
              hintText: l10n.passwordMinHint,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _obscureNew = !_obscureNew);
                },
                icon: Icon(
                  _obscureNew
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordCtrl,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              labelText: l10n.confirmNewPasswordLabel,
              hintText: l10n.passwordPlaceholder,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                },
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.indigo),
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(l10n.updateBtn),
        ),
      ],
    );
  }
}
