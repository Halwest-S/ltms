import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';

import '../../core/admin_shell.dart';
import '../../core/theme.dart';
import '../auth/auth_provider.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final locale = ref.watch(localeProvider);
    final tt = Theme.of(context).textTheme;
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    return AdminShell(
      activeRoute: '/settings',
      title: l10n.settings,
      child: Padding(
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
              const SizedBox(height: 24),
            ] else ...[
              Text(l10n.settings, style: tt.headlineSmall),
              const SizedBox(height: 4),
              Text(
                l10n.manageAccount,
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: ListView(
                children: [
                  _settingsTile(
                    context: context,
                    icon: Icons.person_outline,
                    title: l10n.accountSettings,
                    subtitle: l10n.accountSubtitle,
                    onTap: () {},
                  ),
                  _settingsTile(
                    context: context,
                    icon: Icons.palette_outlined,
                    title: l10n.appearanceSettings,
                    subtitle: l10n.appearanceSubtitle,
                    onTap: () {},
                  ),
                  _settingsTile(
                    context: context,
                    icon: Icons.language,
                    title: l10n.language,
                    subtitle: '${l10n.english} / ${l10n.kurdish}',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.roseLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        locale.languageCode.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.rose,
                        ),
                      ),
                    ),
                    onTap: () => ref.read(localeProvider.notifier).toggle(),
                  ),
                  _settingsTile(
                    context: context,
                    icon: Icons.notifications_outlined,
                    title: l10n.notificationsSettings,
                    subtitle: l10n.notificationsSubtitle,
                    onTap: () {},
                  ),
                  _settingsTile(
                    context: context,
                    icon: Icons.security_outlined,
                    title: l10n.securitySettings,
                    subtitle: l10n.securitySubtitle,
                    onTap: () {},
                  ),
                  const Divider(height: 36),
                  _settingsTile(
                    context: context,
                    icon: Icons.help_outline,
                    title: l10n.helpSupportSettings,
                    subtitle: l10n.helpSupportSubtitle,
                    onTap: () {},
                  ),
                  _settingsTile(
                    context: context,
                    icon: Icons.info_outline,
                    title: l10n.aboutSettings,
                    subtitle: l10n.aboutSubtitle,
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/login');
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(l10n.signOutSettings),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.roseLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.rose),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
