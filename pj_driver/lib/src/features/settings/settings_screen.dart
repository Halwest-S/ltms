import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';

class DriverSettingsScreen extends ConsumerWidget {
  const DriverSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.ink,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _settingsTile(
            icon: Icons.person_outline,
            title: 'Account',
            subtitle: 'Update your profile',
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.palette_outlined,
            title: 'Appearance',
            subtitle: 'Dark mode',
            trailing: Switch(value: false, onChanged: (v) {}),
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English / کوردی',
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Push notification settings',
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.security_outlined,
            title: 'Security',
            subtitle: 'Change password',
            onTap: () {},
          ),
          const Divider(height: 32),
          _settingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'FAQs and contact',
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // logout logic
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: AppTheme.orangeLight, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppTheme.orange),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
