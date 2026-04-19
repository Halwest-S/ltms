import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_domain/pj_domain.dart' as domain;
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/notification_polling_provider.dart';
import '../../core/theme.dart';
import '../notifications/in_app_notification_banner.dart';
import '../notifications/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../shipments/assigned_shipments_screen.dart';
import '../shipments/shipment_history_screen.dart';

final driverBottomNavProvider = StateProvider<int>((ref) => 0);

class DriverMainShell extends ConsumerStatefulWidget {
  const DriverMainShell({super.key});

  @override
  ConsumerState<DriverMainShell> createState() => _DriverMainShellState();
}

class _DriverMainShellState extends ConsumerState<DriverMainShell> {
  OverlayEntry? _bannerEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationPollingProvider.notifier).start();
    });
  }

  @override
  void dispose() {
    _removeBanner();
    super.dispose();
  }

  void _removeBanner() {
    _bannerEntry?.remove();
    _bannerEntry = null;
  }

  void _showBanner(domain.Notification notification) {
    _removeBanner();

    _bannerEntry = OverlayEntry(
      builder: (_) => InAppNotificationBanner(
        notification: notification,
        onDismiss: () {
          _removeBanner();
          ref.read(notificationPollingProvider.notifier).dismissNotification();
        },
        onTap: () {
          _removeBanner();
          ref.read(notificationPollingProvider.notifier).dismissNotification();
          ref.read(driverBottomNavProvider.notifier).state = 2;
          ref.invalidate(driverNotificationsProvider);
        },
      ),
    );

    Overlay.of(context).insert(_bannerEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(driverBottomNavProvider);
    final l10n = L10n.of(context)!;

    ref.listen(notificationPollingProvider.select((s) => s.newNotification), (
      previous,
      next,
    ) {
      if (next != null) {
        _showBanner(next);
      }
    });

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          AssignedShipmentsScreen(),
          ShipmentHistoryScreen(),
          DriverNotificationScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.card,
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) {
            if (value == 2) {
              _removeBanner();
              ref
                  .read(notificationPollingProvider.notifier)
                  .dismissNotification();
              ref.invalidate(driverNotificationsProvider);
            }
            ref.read(driverBottomNavProvider.notifier).state = value;
          },
          backgroundColor: AppTheme.card,
          selectedItemColor: AppTheme.orange,
          unselectedItemColor: AppTheme.muted,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_shipping_rounded),
              label: l10n.assigned,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history_rounded),
              label: l10n.history,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications_rounded),
              label: l10n.alerts,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded),
              label: l10n.account,
            ),
          ],
        ),
      ),
    );
  }
}
