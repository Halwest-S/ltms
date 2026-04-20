import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/api_provider.dart';
import '../../core/theme.dart';
import 'widgets/status_badge.dart';

final historySearchProvider = StateProvider<String>((ref) => '');

final shipmentHistoryProvider = FutureProvider<List<Shipment>>((ref) async {
  final client = ref.watch(apiClientProvider);
  final search = ref.watch(historySearchProvider);
  final response = await client.getShipments(
    status: 'delivered',
    search: search.isEmpty ? null : search,
  );
  final List data = response.data['data'];
  return data.map((json) => Shipment.fromJson(json)).toList();
});

class ShipmentHistoryScreen extends ConsumerStatefulWidget {
  const ShipmentHistoryScreen({super.key});

  @override
  ConsumerState<ShipmentHistoryScreen> createState() =>
      _ShipmentHistoryScreenState();
}

class _ShipmentHistoryScreenState extends ConsumerState<ShipmentHistoryScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final historyAsync = ref.watch(shipmentHistoryProvider);
    final l10n = L10n.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.history, style: textTheme.displaySmall),
                  const SizedBox(height: 2),
                  Text(l10n.allCaughtUp, style: textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                  onChanged: (value) =>
                      ref.read(historySearchProvider.notifier).state = value,
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
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: historyAsync.when(
                data: (shipments) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.teal, Color(0xFF00947A)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${shipments.length} ${l10n.delivered}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            l10n.deliveredSuccessfully,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withAlpha(180),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: historyAsync.when(
                data: (shipments) {
                  if (shipments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 44,
                            color: AppTheme.muted,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.noDeliveriesYet,
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(l10n.history, style: textTheme.bodySmall),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.refresh(shipmentHistoryProvider.future),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: shipments.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final shipment = shipments[index];
                        return GestureDetector(
                          onTap: () =>
                              context.push('/shipments/${shipment.id}'),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.card,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Row(
                              children: [
                                ShipmentStatusBadge(
                                  status: shipment.status,
                                  compact: true,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.routeArrow(
                                          shipment.origin,
                                          shipment.destination,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.ink,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Text(
                                            shipment.weightKg != null
                                                ? l10n.kgUnit(
                                                    shipment.weightKg!
                                                        .toStringAsFixed(1),
                                                  )
                                                : l10n.noData,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.muted,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            width: 4,
                                            height: 4,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppTheme.muted,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${shipment.estimatedDeliveryDays} ${l10n.days}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.muted,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${shipment.totalPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.teal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      size: 18,
                                      color: AppTheme.muted,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 36,
                        color: AppTheme.red,
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.failedToLoad, style: textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('$error', style: textTheme.bodySmall),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () =>
                            ref.refresh(shipmentHistoryProvider.future),
                        child: Text(l10n.retry),
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
