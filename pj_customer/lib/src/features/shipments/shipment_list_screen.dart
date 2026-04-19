import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/theme.dart';
import 'shipment_provider.dart';
import 'widgets/filter_chip.dart';
import 'widgets/new_shipment_button.dart';
import 'widgets/shipment_card.dart';

class ShipmentListScreen extends ConsumerStatefulWidget {
  const ShipmentListScreen({super.key});

  @override
  ConsumerState<ShipmentListScreen> createState() => _ShipmentListScreenState();
}

class _ShipmentListScreenState extends ConsumerState<ShipmentListScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerOpacity;
  late final Animation<Offset> _filterSlide;
  late final Animation<double> _filterOpacity;

  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.00, 0.55, curve: Curves.easeOutCubic),
          ),
        );
    _headerOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.00, 0.45, curve: Curves.easeOut),
      ),
    );

    _filterSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.20, 0.70, curve: Curves.easeOutCubic),
          ),
        );
    _filterOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.20, 0.60, curve: Curves.easeOut),
      ),
    );

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final shipmentsAsync = ref.watch(customerShipmentsProvider);
    final selectedFilter = ref.watch(shipmentStatusFilterProvider);
    final l10n = L10n.of(context)!;
    final filters = <({ShipmentStatus? value, String label})>[
      (value: null, label: l10n.all),
      (value: ShipmentStatus.pending, label: l10n.pending),
      (value: ShipmentStatus.inTransit, label: l10n.inTransit),
      (value: ShipmentStatus.delivered, label: l10n.delivered),
      (value: ShipmentStatus.reported, label: l10n.reported),
    ];
    final activeFilterLabel = filters
        .firstWhere((filter) => filter.value == selectedFilter)
        .label;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            AnimatedBuilder(
              animation: _entranceCtrl,
              builder: (_, child) => SlideTransition(
                position: _headerSlide,
                child: FadeTransition(opacity: _headerOpacity, child: child),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.myShipments, style: tt.displaySmall),
                          const SizedBox(height: 2),
                          shipmentsAsync.when(
                            data: (list) => Text(
                              list.length == 1
                                  ? l10n.shipmentCount(list.length)
                                  : l10n.shipmentsCount(list.length),
                              style: tt.bodySmall,
                            ),
                            loading: () =>
                                Text(l10n.loading, style: tt.bodySmall),
                            error: (error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    NewShipmentButton(
                      onTap: () => context.push('/create-shipment'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Search Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (val) =>
                      ref.read(shipmentSearchProvider.notifier).state = val,
                  decoration: InputDecoration(
                    hintText: l10n.searchPlaceholder,
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.muted,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: AppTheme.muted,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Filter Chips ──
            AnimatedBuilder(
              animation: _entranceCtrl,
              builder: (_, child) => SlideTransition(
                position: _filterSlide,
                child: FadeTransition(opacity: _filterOpacity, child: child),
              ),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: filters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final filter = filters[i];
                    return ShipmentFilterChip(
                      label: filter.label,
                      isActive: selectedFilter == filter.value,
                      onTap: () =>
                          ref
                                  .read(shipmentStatusFilterProvider.notifier)
                                  .state =
                              filter.value,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Shipment List ──
            Expanded(
              child: shipmentsAsync.when(
                data: (shipments) {
                  if (shipments.isEmpty) {
                    return _NoResultsView(
                      filterLabel: activeFilterLabel,
                      isAllFilter: selectedFilter == null,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.refresh(customerShipmentsProvider.future),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                      itemCount: shipments.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, i) => _StaggeredItem(
                        index: i,
                        child: ShipmentCard(
                          shipment: shipments[i],
                          onTap: () =>
                              context.push('/shipments/${shipments[i].id}'),
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => _ErrorView(
                  onRetry: () => ref.refresh(customerShipmentsProvider.future),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResultsView extends ConsumerWidget {
  final String filterLabel;
  final bool isAllFilter;

  const _NoResultsView({required this.filterLabel, required this.isAllFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('\u{1F4E6}', style: TextStyle(fontSize: 44)),
          const SizedBox(height: 12),
          Text(
            isAllFilter
                ? l10n.noShipmentsYet
                : '${l10n.noShipmentsFilter}: $filterLabel',
            style: tt.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            isAllFilter ? l10n.createFirstShipment : l10n.tryDifferentFilter,
            style: tt.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 10),
          Text(
            l10n.failedToLoadShipments,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}

class _StaggeredItem extends StatefulWidget {
  final int index;
  final Widget child;
  const _StaggeredItem({required this.index, required this.child});

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SlideTransition(
    position: _slide,
    child: FadeTransition(opacity: _opacity, child: widget.child),
  );
}
