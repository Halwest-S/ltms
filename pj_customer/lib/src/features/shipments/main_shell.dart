import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_domain/pj_domain.dart' as domain;
import 'package:pj_l10n/pj_l10n.dart';
import '../../core/theme.dart';
import '../../core/notification_polling_provider.dart';
import '../home/home_screen.dart';
import '../notifications/notification_screen.dart';
import '../notifications/in_app_notification_banner.dart';
import '../settings/settings_screen.dart';
import 'shipment_list_screen.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// ── Shell ─────────────────────────────────────────────────────────────────────

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  OverlayEntry? _bannerEntry;

  @override
  void initState() {
    super.initState();
    // Start polling after the first frame so the widget tree is fully mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationPollingProvider.notifier).start();
    });
  }

  @override
  void dispose() {
    _removeBanner();
    super.dispose();
  }

  // ── Banner helpers ────────────────────────────────────────────────────────

  void _removeBanner() {
    _bannerEntry?.remove();
    _bannerEntry = null;
  }

  void _showBanner(domain.Notification notification) {
    // Remove any existing banner first.
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
          // Navigate to the Notifications tab (index 2).
          ref.read(bottomNavIndexProvider.notifier).state = 2;
          // Refresh the notifications list so the new one is visible.
          ref.invalidate(notificationsProvider);
        },
      ),
    );

    Overlay.of(context).insert(_bannerEntry!);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final idx = ref.watch(bottomNavIndexProvider);

    // Listen for new notifications from the polling service.
    ref.listen(
      notificationPollingProvider.select((s) => s.newNotification),
      (previous, next) {
        if (next != null) {
          _showBanner(next);
        }
      },
    );

    return Scaffold(
      body: IndexedStack(
        index: idx,
        children: const [
          HomeScreen(),
          ShipmentListScreen(),
          NotificationScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _AnimatedBottomNav(
        currentIndex: idx,
        onTap: (i) {
          // If the user taps the Notifications tab manually, dismiss the banner.
          if (i == 2) {
            _removeBanner();
            ref
                .read(notificationPollingProvider.notifier)
                .dismissNotification();
            ref.invalidate(notificationsProvider);
          }
          ref.read(bottomNavIndexProvider.notifier).state = i;
        },
      ),
    );
  }
}

// ── Animated bottom navigation bar ────────────────────────────────────────────

class _AnimatedBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AnimatedBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<_AnimatedBottomNav> createState() => _AnimatedBottomNavState();
}

class _AnimatedBottomNavState extends State<_AnimatedBottomNav>
    with TickerProviderStateMixin {
  List<_NavItem> _buildItems(BuildContext context) {
    final l10n = L10n.of(context)!;
    return [
      _NavItem(emoji: '🏠', label: l10n.home),
      _NavItem(emoji: '📦', label: l10n.orders),
      _NavItem(emoji: '🔔', label: l10n.alerts),
      _NavItem(emoji: '👤', label: l10n.account),
    ];
  }

  late final List<AnimationController> _scaleControllers;
  late final List<Animation<double>> _scaleAnims;

  // Sliding indicator
  late final AnimationController _indicatorCtrl;
  late Animation<double> _indicatorPos;

  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();

    _scaleControllers = List.generate(
      4,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 180),
        reverseDuration: const Duration(milliseconds: 260),
      ),
    );

    _scaleAnims = _scaleControllers
        .map(
          (ctrl) => TweenSequence<double>([
            TweenSequenceItem(
              tween: Tween(begin: 1.0, end: 1.28)
                  .chain(CurveTween(curve: Curves.easeOut)),
              weight: 50,
            ),
            TweenSequenceItem(
              tween: Tween(begin: 1.28, end: 1.0)
                  .chain(CurveTween(curve: Curves.elasticOut)),
              weight: 50,
            ),
          ]).animate(ctrl),
        )
        .toList();

    _indicatorCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _indicatorPos = Tween<double>(
      begin: widget.currentIndex.toDouble(),
      end: widget.currentIndex.toDouble(),
    ).animate(
      CurvedAnimation(parent: _indicatorCtrl, curve: Curves.easeOutCubic),
    );

    // Bounce selected on first build
    _scaleControllers[widget.currentIndex].forward();
  }

  @override
  void didUpdateWidget(_AnimatedBottomNav old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      // Trigger bounce on newly selected tab
      _scaleControllers[widget.currentIndex].forward(from: 0);

      // Slide indicator from previous to current
      _indicatorPos = Tween<double>(
        begin: _previousIndex.toDouble(),
        end: widget.currentIndex.toDouble(),
      ).animate(
        CurvedAnimation(parent: _indicatorCtrl, curve: Curves.easeOutCubic),
      );
      _indicatorCtrl.forward(from: 0);

      _previousIndex = widget.currentIndex;
    }
  }

  @override
  void dispose() {
    for (final c in _scaleControllers) {
      c.dispose();
    }
    _indicatorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems(context);
    final count = items.length;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        border: Border(top: BorderSide(color: AppTheme.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            children: [
              // ── Sliding indicator line ──
              AnimatedBuilder(
                animation: _indicatorCtrl,
                builder: (_, _) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = constraints.maxWidth / count;
                      final indicatorWidth = itemWidth * 0.40;
                      final left = _indicatorPos.value * itemWidth +
                          (itemWidth - indicatorWidth) / 2;
                      return Positioned(
                        top: 0,
                        left: left,
                        child: Container(
                          width: indicatorWidth,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppTheme.teal,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(2),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              // ── Tab items ──
              Row(
                children: List.generate(count, (i) {
                  final isActive = widget.currentIndex == i;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => widget.onTap(i),
                      child: AnimatedBuilder(
                        animation: _scaleAnims[i],
                        builder: (_, child) => Transform.scale(
                          scale: _scaleAnims[i].value,
                          child: child,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 220),
                              style: TextStyle(
                                fontSize: isActive ? 22 : 19,
                              ),
                              child: Text(items[i].emoji),
                            ),
                            const SizedBox(height: 3),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color:
                                    isActive ? AppTheme.teal : AppTheme.muted,
                              ),
                              child: Text(items[i].label),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String emoji;
  final String label;

  const _NavItem({required this.emoji, required this.label});
}
