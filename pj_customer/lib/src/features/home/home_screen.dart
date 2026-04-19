import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';
import 'package:pj_l10n/pj_l10n.dart';
import '../../core/theme.dart';
import '../shipments/shipment_provider.dart';
import '../auth/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  // â”€â”€ Entrance controller â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final AnimationController _entranceCtrl;

  // â”€â”€ Bell shake controller â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final AnimationController _bellCtrl;
  late final Animation<double> _bellShake;

  // â”€â”€ Stats card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final Animation<Offset> _statsSlide;
  late final Animation<double> _statsOpacity;

  // â”€â”€ New shipment button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final Animation<double> _btnScale;
  late final Animation<double> _btnOpacity;
  late final AnimationController _btnPressCtrl;

  // â”€â”€ Section title â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final Animation<Offset> _sectionSlide;
  late final Animation<double> _sectionOpacity;

  // â”€â”€ Greeting â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final Animation<Offset> _greetSlide;
  late final Animation<double> _greetOpacity;

  // â”€â”€ FAQ card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final Animation<double> _faqOpacity;
  late final Animation<Offset> _faqSlide;

  @override
  void initState() {
    super.initState();

    // â”€â”€ Entrance (1.3 s covers all staggered elements) â”€â”€
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    // â”€â”€ Bell shake (repeating with gap) â”€â”€
    _bellCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bellShake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.12, end: 0.12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.12, end: -0.10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.10, end: 0.08), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.08, end: -0.05), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _bellCtrl, curve: Curves.easeInOut));

    // â”€â”€ Button press feedback â”€â”€
    _btnPressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      reverseDuration: const Duration(milliseconds: 200),
    );

    // â”€â”€ Greeting slides from left â”€â”€
    _greetSlide = Tween<Offset>(
      begin: const Offset(-0.4, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.00, 0.38, curve: Curves.easeOutCubic),
    ));
    _greetOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.00, 0.32, curve: Curves.easeOut),
      ),
    );

    // â”€â”€ Stats card slides up â”€â”€
    _statsSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.15, 0.52, curve: Curves.easeOutCubic),
    ));
    _statsOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.15, 0.46, curve: Curves.easeOut),
      ),
    );

    // â”€â”€ New shipment button â”€â”€
    _btnScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.30, 0.60, curve: Curves.easeOutBack),
      ),
    );
    _btnOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.30, 0.56, curve: Curves.easeOut),
      ),
    );

    // â”€â”€ Section title â”€â”€
    _sectionSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.42, 0.68, curve: Curves.easeOutCubic),
    ));
    _sectionOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.42, 0.64, curve: Curves.easeOut),
      ),
    );

    // â”€â”€ FAQ card â”€â”€
    _faqSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.72, 1.00, curve: Curves.easeOutCubic),
    ));
    _faqOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.72, 0.96, curve: Curves.easeOut),
      ),
    );

    _entranceCtrl.forward().then((_) {
      // Shake bell once after entrance
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _bellCtrl.forward(from: 0);
      });
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _bellCtrl.dispose();
    _btnPressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final shipmentsAsync = ref.watch(customerShipmentsProvider);
    final user = ref.watch(authProvider);

    final l10n = L10n.of(context)!;
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? l10n.goodMorning : hour < 17 ? l10n.goodAfternoon : l10n.goodEvening;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // â”€â”€ Top Bar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              AnimatedBuilder(
                animation: _entranceCtrl,
                builder: (_, child) => SlideTransition(
                  position: _greetSlide,
                  child: FadeTransition(opacity: _greetOpacity, child: child),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(greeting, style: tt.bodySmall),
                        Text(user?.name ?? l10n.customer, style: tt.displaySmall),
                      ],
                    ),
                    // â”€â”€ Language toggle + bell â”€â”€
                    Row(
                      children: [
                        Consumer(
                          builder: (context, ref, _) {
                            final locale = ref.watch(localeProvider);
                            return TextButton(
                              onPressed: () => ref.read(localeProvider.notifier).toggle(),
                              style: TextButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
                              child: Text(
                                locale.languageCode == 'en' ? '\u{1F310} کوردی' : '\u{1F310} ئینگلیزی',
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        // â”€â”€ Animated bell â”€â”€
                        GestureDetector(
                          onTap: () {
                            _bellCtrl.forward(from: 0);
                            context.push('/notifications');
                          },
                          child: AnimatedBuilder(
                            animation: _bellCtrl,
                            builder: (_, child) => Transform.rotate(
                              angle: _bellShake.value,
                              child: child,
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AppTheme.card,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.border),
                                  ),
                                  child: const Center(
                                    child: Text('\u{1F514}', // Bell 🔔
                                        style: TextStyle(fontSize: 17)),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Container(
                                    width: 9,
                                    height: 9,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.red,
                                      border: Border.all(
                                          color: AppTheme.card, width: 1.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // â”€â”€ Stats Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              AnimatedBuilder(
                animation: _entranceCtrl,
                builder: (_, child) => SlideTransition(
                  position: _statsSlide,
                  child:
                      FadeTransition(opacity: _statsOpacity, child: child),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.ink, Color(0xFF1E2038)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: shipmentsAsync.when(
                    data: (shipments) {
                      final inTransit = shipments
                          .where((s) => s.status.name == 'inTransit')
                          .length;
                      final pending = shipments
                          .where((s) => s.status.name == 'pending')
                          .length;
                      final delivered = shipments
                          .where((s) => s.status.name == 'delivered')
                          .length;
                      return Row(
                        children: [
                          _AnimatedStat(
                              value: shipments.length, label: l10n.total),
                          const SizedBox(width: 10),
                          _AnimatedStat(
                              value: inTransit, label: l10n.inTransitCount),
                          const SizedBox(width: 10),
                          _AnimatedStat(value: pending, label: l10n.pendingCount),
                          const SizedBox(width: 10),
                          _AnimatedStat(
                              value: delivered, label: l10n.deliveredCount),
                        ],
                      );
                    },
                    loading: () => const SizedBox(
                      height: 52,
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      ),
                    ),
                    error: (_, _) => Row(
                      children: [
                        _AnimatedStat(value: 0, label: l10n.total, dash: true),
                        const SizedBox(width: 10),
                        _AnimatedStat(
                            value: 0, label: l10n.inTransitCount, dash: true),
                        const SizedBox(width: 10),
                        _AnimatedStat(value: 0, label: l10n.pendingCount, dash: true),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // â”€â”€ New Shipment Button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              AnimatedBuilder(
                animation:
                    Listenable.merge([_entranceCtrl, _btnPressCtrl]),
                builder: (_, child) {
                  final pressScale = Tween<double>(begin: 1.0, end: 0.96)
                      .animate(CurvedAnimation(
                          parent: _btnPressCtrl,
                          curve: Curves.easeInOut))
                      .value;
                  return Transform.scale(
                    scale: _btnScale.value * pressScale,
                    child: FadeTransition(
                        opacity: _btnOpacity, child: child),
                  );
                },
                child: GestureDetector(
                  onTapDown: (_) => _btnPressCtrl.forward(),
                  onTapUp: (_) {
                    _btnPressCtrl.reverse();
                    context.push('/create-shipment');
                  },
                  onTapCancel: () => _btnPressCtrl.reverse(),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.teal,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.teal.withAlpha(80),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                        child: Text(
                          l10n.newShipmentBtn,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // â”€â”€ Recent Shipments heading â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              AnimatedBuilder(
                animation: _entranceCtrl,
                builder: (_, child) => SlideTransition(
                  position: _sectionSlide,
                  child: FadeTransition(
                      opacity: _sectionOpacity, child: child),
                ),
                child: Text(
                  l10n.recentShipments,
                  style: tt.labelLarge?.copyWith(
                      color: AppTheme.ink, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 8),

              // â”€â”€ Shipment Cards â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              shipmentsAsync.when(
                data: (shipments) {
                  if (shipments.isEmpty) {
                    return _StaggerItem(
                      index: 0,
                      parent: _entranceCtrl,
                      startInterval: 0.55,
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('\u{1F4E6}', // Package 📦
                                style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 8),
                            Text(l10n.noShipmentsYet,
                                style: tt.titleMedium),
                            Text(l10n.createFirstShipment,
                                style: tt.bodySmall),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: shipments
                        .take(3)
                        .toList()
                        .asMap()
                        .entries
                        .map((e) {
                      final i = e.key;
                      final s = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _StaggerItem(
                          index: i,
                          parent: _entranceCtrl,
                          startInterval: 0.52 + i * 0.10,
                          child: _ShipmentCard(
                            origin: s.origin,
                            destination: s.destination,
                            id: s.id,
                            weightOrSize: s.weightKg != null
                                ? L10n.of(context)!.kgUnit(
                                    s.weightKg!.toStringAsFixed(0),
                                  )
                                : s.size ?? '',
                            price: s.totalPrice,
                            status: s.status.name,
                            onTap: () =>
                                context.push('/shipments/${s.id}'),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Text('${L10n.of(context)!.error}: $e'),
              ),
              const SizedBox(height: 8),

              // â”€â”€ FAQ Link â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              AnimatedBuilder(
                animation: _entranceCtrl,
                builder: (_, child) => SlideTransition(
                  position: _faqSlide,
                  child: FadeTransition(opacity: _faqOpacity, child: child),
                ),
                child: _TappableCard(
                  onTap: () => context.push('/faq'),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppTheme.tealLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child:
                              Text('\u{2753}', style: TextStyle(fontSize: 18)), // Question ❓
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.helpAndFaq,
                                style: Theme.of(context).textTheme.titleMedium),
                            Text(
                              l10n.findAnswers,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text('\u{203A}', // Arrow ›
                          style: TextStyle(
                              color: AppTheme.muted, fontSize: 22)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€ Animated stat widget with count-up â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _AnimatedStat extends StatefulWidget {
  final int value;
  final String label;
  final bool dash;

  const _AnimatedStat({
    required this.value,
    required this.label,
    this.dash = false,
  });

  @override
  State<_AnimatedStat> createState() => _AnimatedStatState();
}

class _AnimatedStatState extends State<_AnimatedStat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<int> _count;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _count = IntTween(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, _) => Text(
                widget.dash ? 'â€”' : '${_count.value}',
                style: const TextStyle(
                  fontFamily: 'InstrumentSerif',
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF6EE7B7),
                ),
              ),
            ),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withAlpha(128),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€ Stagger item helper â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _StaggerItem extends StatelessWidget {
  final int index;
  final AnimationController parent;
  final double startInterval;
  final Widget child;

  const _StaggerItem({
    required this.index,
    required this.parent,
    required this.startInterval,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final end = (startInterval + 0.30).clamp(0.0, 1.0);
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.55),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(startInterval, end, curve: Curves.easeOutCubic),
      ),
    );
    final opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(
            startInterval, (startInterval + 0.22).clamp(0.0, 1.0),
            curve: Curves.easeOut),
      ),
    );
    return AnimatedBuilder(
      animation: parent,
      builder: (_, _) => SlideTransition(
        position: slide,
        child: FadeTransition(opacity: opacity, child: child),
      ),
    );
  }
}

// â”€â”€ Tappable card with press scale feedback â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _TappableCard extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _TappableCard({required this.onTap, required this.child});

  @override
  State<_TappableCard> createState() => _TappableCardState();
}

class _TappableCardState extends State<_TappableCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// â”€â”€ Shipment Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ShipmentCard extends StatefulWidget {
  final String origin, destination, id, status, weightOrSize;
  final double price;
  final VoidCallback onTap;

  const _ShipmentCard({
    required this.origin,
    required this.destination,
    required this.id,
    required this.weightOrSize,
    required this.price,
    required this.status,
    required this.onTap,
  });

  @override
  State<_ShipmentCard> createState() => _ShipmentCardState();
}

class _ShipmentCardState extends State<_ShipmentCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.origin} \u{2192} ${widget.destination}', // Arrow →
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  _StatusBadge(status: widget.status),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '#${widget.id.substring(0, 8)} Â· ${widget.weightOrSize}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '\$${widget.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'InstrumentSerif',
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: AppTheme.ink,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€ Status Badge â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, Color dot) = switch (status.toLowerCase()) {
      'intransit' || 'in_transit' => (
          AppTheme.blueLight,
          const Color(0xFF1D4ED8),
          AppTheme.blue
        ),
      'pending' => (
          AppTheme.amberLight,
          const Color(0xFF92400E),
          AppTheme.amber
        ),
      'delivered' => (
          AppTheme.tealLight,
          const Color(0xFF065F46),
          AppTheme.teal
        ),
      'reported' => (
          AppTheme.redLight,
          const Color(0xFF991B1B),
          AppTheme.red
        ),
      _ => (AppTheme.amberLight, const Color(0xFF92400E), AppTheme.amber),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: dot),
          ),
          const SizedBox(width: 5),
          Text(
            switch (status.toLowerCase()) {
              'intransit' || 'in_transit' => L10n.of(context)!.inTransit,
              'pending' => L10n.of(context)!.pending,
              'delivered' => L10n.of(context)!.delivered,
              'reported' => L10n.of(context)!.reported,
              _ => status.toUpperCase(),
            },
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, color: fg),
          ),
        ],
      ),
    );
  }
}
