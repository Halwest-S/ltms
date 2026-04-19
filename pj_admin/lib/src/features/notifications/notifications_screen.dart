import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/theme.dart';

class AdminNotificationsScreen extends ConsumerWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final l10n = L10n.of(context)!;
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    final notifications = [
      {
        'id': 1,
        'type': 'status_update',
        'title': 'دوخی بار نوێکرایەوە',
        'message': 'باری #abc123 گەیەندرا',
        'time': l10n.minutesAgo(2),
        'read': false,
      },
      {
        'id': 2,
        'type': 'report',
        'title': 'ڕاپۆرتێکی نوێ نێردرا',
        'message': 'کڕیار کێشەیەکی بۆ باری #def456 ڕاپۆرت کردووە',
        'time': l10n.hoursAgo(1),
        'read': false,
      },
      {
        'id': 3,
        'type': 'assignment',
        'title': 'بارێکی نوێ ئێسپێردرا',
        'message': 'باری #ghi789 بۆ شۆفێر John ئێسپێردرا',
        'time': l10n.hoursAgo(3),
        'read': true,
      },
      {
        'id': 4,
        'type': 'status_update',
        'title': 'بار لە ڕێگایە',
        'message': 'باری #jkl012 ئێستا لە ڕێگایە',
        'time': l10n.yesterday,
        'read': true,
      },
      {
        'id': 5,
        'type': 'report',
        'title': 'ڕاپۆرت چارەسەرکرا',
        'message': 'ڕاپۆرتی باری #mno345 چارەسەرکرا',
        'time': l10n.yesterday,
        'read': true,
      },
    ];

    return AdminShell(
      activeRoute: '/notifications',
      title: l10n.notifications,
      actions: [
        IconButton(
          onPressed: () {},
          tooltip: l10n.markAllRead,
          icon: const Icon(Icons.done_all),
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(l10n.notifications, style: tt.headlineLarge),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.done_all, size: 18),
                    label: Text(l10n.markAllRead),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ] else
              Text(l10n.notifications, style: tt.headlineSmall),
            Text(
              'هەموو ئاگادارکردنەوەکانی سیستەم ببینە',
              style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  final isRead = notif['read'] as bool;
                  return _notificationTile(
                    icon: _getIconForType(notif['type'] as String),
                    title: notif['title'] as String,
                    message: notif['message'] as String,
                    time: notif['time'] as String,
                    isRead: isRead,
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _getIconForType(String type) {
    switch (type) {
      case 'status_update':
        return Icons.local_shipping;
      case 'report':
        return Icons.report_problem;
      case 'assignment':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  Widget _notificationTile({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isRead ? null : AppTheme.roseLight.withAlpha(50),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isRead ? AppTheme.border : AppTheme.rose,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isRead ? AppTheme.muted : Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 11, color: AppTheme.muted),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.rose,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
