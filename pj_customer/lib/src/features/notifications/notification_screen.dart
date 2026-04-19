import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_domain/pj_domain.dart' as domain;
import '../../core/api_provider.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';

final notificationsProvider = FutureProvider<List<domain.Notification>>((ref) async {
  final response = await ref.read(apiClientProvider).getNotifications();
  final List data = response.data is List
      ? response.data
      : (response.data['data'] ?? []);
  return data.map((json) => domain.Notification.fromJson(json)).toList();
});

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final notifAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(L10n.of(context)!.notifications, style: tt.displaySmall),
                        const SizedBox(height: 2),
                        Text(L10n.of(context)!.updatesFromShipments, style: tt.bodySmall),
                      ],
                    ),
                  ),
                  notifAsync.when(
                    data: (list) {
                      final unread = list.where((n) => !n.isRead).length;
                      if (unread == 0) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.teal,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '$unread نوێ',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── List ──
            Expanded(
              child: notifAsync.when(
                data: (list) {
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔔',
                              style: TextStyle(fontSize: 44)),
                          const SizedBox(height: 10),
                          Text(L10n.of(context)!.noNotificationsYet,
                              style: tt.titleMedium),
                          const SizedBox(height: 4),
                          Text(L10n.of(context)!.allCaughtUp,
                              style: tt.bodySmall),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.refresh(notificationsProvider.future),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: list.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final n = list[i];
                        return _NotificationCard(
                          notification: n,
                          onTap: () {
                            if (!n.isRead) {
                              ref
                                  .read(apiClientProvider)
                                  .markNotificationAsRead(n.id);
                              ref.invalidate(notificationsProvider);
                            }
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('⚠️',
                          style: TextStyle(fontSize: 36)),
                      const SizedBox(height: 8),
                      Text(L10n.of(context)!.failedToLoad, style: tt.titleMedium),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () =>
                            ref.refresh(notificationsProvider.future),
                        child: Text(L10n.of(context)!.retry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Notification Card ────────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final domain.Notification notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = notification;
    final tt = Theme.of(context).textTheme;

    final (Color accent, Color bgColor, String emoji) = switch (n.type) {
      domain.NotificationType.statusUpdate =>
        (AppTheme.teal, AppTheme.tealLight, '🚛'),
      domain.NotificationType.reportUpdate =>
        (AppTheme.red, AppTheme.redLight, '⚠️'),
      domain.NotificationType.assignment =>
        (AppTheme.blue, AppTheme.blueLight, '📋'),
    };

    final hasImage = n.imageUrl != null && n.imageUrl!.isNotEmpty;
    final hasLocation = n.location != null && n.location!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: n.isRead ? 0.6 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: n.isRead ? AppTheme.border : accent.withAlpha(80),
              width: n.isRead ? 1.0 : 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──
              if (hasImage)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(17)),
                  child: Image.network(
                    resolveApiUrl(n.imageUrl!),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 180,
                        color: AppTheme.surface,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            color: AppTheme.teal,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, _, _) => Container(
                      height: 180,
                      color: AppTheme.surface,
                      child: Center(
                        child: Builder(
                          builder: (ctx) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🖼️',
                                  style: TextStyle(fontSize: 32)),
                              const SizedBox(height: 6),
                              Text(L10n.of(ctx)?.imageUnavailable ?? 'وێنە بەردەست نییە',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.muted)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // ── Body ──
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type badge + unread dot
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(emoji,
                                style: const TextStyle(fontSize: 17)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _typeLabel(context, n.type),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.ink),
                          ),
                        ),
                        if (!n.isRead)
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Message
                    Text(
                      L10n.of(context)!.localeName == 'ku'
                          ? n.messageKu
                          : n.messageEn,
                      style: tt.bodyMedium?.copyWith(height: 1.45),
                    ),

                    // ── Location ──
                    if (hasLocation) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.tealLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppTheme.teal.withAlpha(60)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                size: 15, color: AppTheme.teal),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                n.location!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.teal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ── Read status ──
                    if (n.isRead) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline_rounded,
                              size: 13,
                              color: AppTheme.muted.withAlpha(150)),
                          const SizedBox(width: 4),
                          Text(L10n.of(context)!.readLabel,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.muted.withAlpha(150))),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(BuildContext context, domain.NotificationType type) {
    final l10n = L10n.of(context);
    return switch (type) {
      domain.NotificationType.statusUpdate => l10n?.shipmentUpdate ?? 'نوێکردنەوەی بار',
      domain.NotificationType.reportUpdate => l10n?.reportUpdate ?? 'نوێکردنەوەی ڕاپۆرت',
      domain.NotificationType.assignment => l10n?.newAssignment ?? 'ئەرکی نوێ',
    };
  }
}
