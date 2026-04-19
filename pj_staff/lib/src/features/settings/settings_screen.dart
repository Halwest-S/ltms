import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';

import '../../core/layout_preferences.dart';
import '../../core/theme.dart';
import '../auth/auth_provider.dart';
import '../shell/staff_shell.dart';

class StaffSettingsScreen extends ConsumerWidget {
  const StaffSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final user = ref.watch(authProvider);
    final l10n = L10n.of(context)!;
    final isCompact = useCompactStaffLayout(context, ref);
    final forceCompact = ref.watch(staffCompactViewProvider);

    return StaffShell(
      activeRoute: '/settings',
      title: l10n.settings,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) ...[
              Text(l10n.settings, style: tt.headlineLarge),
              const SizedBox(height: 4),
              Text(
                l10n.manageAccount,
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 28),
            ] else ...[
              Text(l10n.settings, style: tt.headlineSmall),
              const SizedBox(height: 4),
              Text(
                l10n.manageAccount,
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 20),
            ],
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.ink, Color(0xFF1E2038)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: isCompact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildAvatar(user?.name),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildUserInfo(
                                user?.name ?? l10n.staff,
                                user?.email ?? '',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildRoleChip(l10n.staff),
                      ],
                    )
                  : Row(
                      children: [
                        _buildAvatar(user?.name),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildUserInfo(
                            user?.name ?? l10n.staff,
                            user?.email ?? '',
                          ),
                        ),
                        _buildRoleChip(l10n.staff),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            if (isCompact)
              Column(
                children: [
                  _buildLeftColumn(context, ref, user?.name),
                  const SizedBox(height: 16),
                  _buildRightColumn(context, ref, forceCompact),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildLeftColumn(context, ref, user?.name)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRightColumn(context, ref, forceCompact),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? name) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.indigo, Color(0xFF818CF8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          (name ?? 'S')[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(String name, String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          email,
          style: TextStyle(fontSize: 13, color: Colors.white.withAlpha(150)),
        ),
      ],
    );
  }

  Widget _buildRoleChip(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.indigo.withAlpha(50),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppTheme.indigo.withAlpha(80)),
      ),
      child: Text(
        role,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFFA5B4FC),
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context, WidgetRef ref, String? name) {
    final l10n = L10n.of(context)!;
    return Column(
      children: [
        _Section(
          title: l10n.accountSection,
          children: [
            _SettingsTile(
              emoji: '\u{270F}\u{FE0F}',
              label: l10n.editProfile,
              subtitle: l10n.editProfileSubtitle,
              onTap: () => _showEditProfile(context, name),
            ),
            _SettingsTile(
              emoji: '\u{1F512}',
              label: l10n.changePassword,
              subtitle: l10n.updatePasswordSubtitle,
              onTap: () => _showChangePassword(context),
            ),
            _SettingsTile(
              emoji: '\u{1F310}',
              label: l10n.language,
              subtitle: '${l10n.english} / ${l10n.kurdish}',
              trailing: Consumer(
                builder: (context, ref, _) {
                  final locale = ref.watch(localeProvider);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.indigoLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      locale.languageCode.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.indigo,
                      ),
                    ),
                  );
                },
              ),
              onTap: () => ref.read(localeProvider.notifier).toggle(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _Section(
          title: l10n.notificationsSection,
          children: [
            _SettingsTile(
              emoji: '\u{1F514}',
              label: l10n.pushNotifications,
              subtitle: l10n.pushNotificationsSubtitle,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightColumn(
    BuildContext context,
    WidgetRef ref,
    bool forceCompact,
  ) {
    final l10n = L10n.of(context)!;
    return Column(
      children: [
        _Section(
          title: l10n.appearanceSection,
          children: [
            _SettingsTile(
              emoji: '\u{1F4CA}',
              label: l10n.compactView,
              subtitle: l10n.compactViewSubtitle,
              trailing: Switch(
                value: forceCompact,
                onChanged: (value) => ref
                    .read(staffCompactViewProvider.notifier)
                    .setEnabled(value),
                activeThumbColor: AppTheme.indigo,
              ),
              onTap: () =>
                  ref.read(staffCompactViewProvider.notifier).toggle(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _Section(
          title: l10n.supportSection,
          children: [
            _SettingsTile(
              emoji: '\u{1F4AC}',
              label: l10n.help,
              subtitle: l10n.findAnswers,
              onTap: () => _showHelp(context),
            ),
            _SettingsTile(
              emoji: '\u{2B50}',
              label: l10n.signOut,
              subtitle: l10n.help,
              onTap: () {},
            ),
            _SettingsTile(
              emoji: '\u{2139}\u{FE0F}',
              label: l10n.aboutLtms,
              subtitle: l10n.versionLabel,
              trailing: const Text(
                'Version',
                style: TextStyle(fontSize: 12, color: AppTheme.muted),
              ),
              onTap: () => _showAbout(context),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.red.withAlpha(60)),
          ),
          child: ListTile(
            onTap: () => _confirmLogout(context, ref),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.redLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(
                  Icons.logout_rounded,
                  size: 18,
                  color: AppTheme.red,
                ),
              ),
            ),
            title: Text(
              l10n.signOut,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.red,
              ),
            ),
            subtitle: Text(
              l10n.signOutSubtitle,
              style: const TextStyle(fontSize: 12, color: AppTheme.muted),
            ),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppTheme.red,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
          ),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          L10n.of(context)!.signOut,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(L10n.of(context)!.signOutConfirmStaff),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              L10n.of(context)!.cancel,
              style: const TextStyle(color: AppTheme.muted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            child: Text(
              L10n.of(context)!.signOut,
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

  void _showEditProfile(BuildContext context, String? name) {
    final ctrl = TextEditingController(text: name ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          L10n.of(context)!.editProfile,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.of(context)!.nameLabel,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: ctrl,
              decoration: InputDecoration(
                hintText: L10n.of(context)!.fullNameHint,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              L10n.of(context)!.cancel,
              style: const TextStyle(color: AppTheme.muted),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.indigo,
              minimumSize: const Size(0, 36),
            ),
            child: Text(L10n.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          L10n.of(context)!.changePassword,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PassField(
              label: L10n.of(context)!.currentPasswordLabel,
              hint: L10n.of(context)!.passwordPlaceholder,
            ),
            const SizedBox(height: 12),
            _PassField(
              label: L10n.of(context)!.newPasswordLabel,
              hint: L10n.of(context)!.minPasswordHint,
            ),
            const SizedBox(height: 12),
            _PassField(
              label: L10n.of(context)!.confirmNewPasswordLabel,
              hint: L10n.of(context)!.passwordPlaceholder,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              L10n.of(context)!.cancel,
              style: const TextStyle(color: AppTheme.muted),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.indigo,
              minimumSize: const Size(0, 36),
            ),
            child: Text(L10n.of(context)!.updateBtn),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          L10n.of(context)!.help,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpRow(
              emoji: '\u{1F4E7}',
              label: L10n.of(context)!.email,
              value: 'support@ltms.app',
            ),
            const SizedBox(height: 10),
            _HelpRow(
              emoji: '\u{1F4DE}',
              label: L10n.of(context)!.help,
              value: '+964 750 000 0000',
            ),
            const SizedBox(height: 10),
            _HelpRow(
              emoji: '\u{1F4AC}',
              label: L10n.of(context)!.help,
              value: L10n.of(context)!.supportHours,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.indigo),
            ),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('\u{1F4CB}', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              L10n.of(context)!.aboutLtms,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpRow(
              emoji: '\u{1F680}',
              label: L10n.of(context)!.buildLabel,
              value: '1.0.0',
            ),
            const SizedBox(height: 8),
            _HelpRow(
              emoji: '\u{1F4C5}',
              label: L10n.of(context)!.buildLabel,
              value: '2026.03',
            ),
            const SizedBox(height: 8),
            _HelpRow(
              emoji: '\u{1F30D}',
              label: L10n.of(context)!.productLabel,
              value: L10n.of(context)!.logisticsSystemName,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.indigo),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppTheme.muted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children: List.generate(children.length, (i) {
              return Column(
                children: [
                  children[i],
                  if (i < children.length - 1)
                    const Divider(height: 1, indent: 54),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.emoji,
    required this.label,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTheme.indigoLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 17))),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.ink,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppTheme.muted),
      ),
      trailing:
          trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppTheme.muted,
          ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}

class _PassField extends StatelessWidget {
  final String label;
  final String hint;

  const _PassField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppTheme.muted,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          obscureText: true,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _HelpRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _HelpRow({
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.muted,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
