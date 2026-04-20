import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';
import 'package:pj_l10n/pj_l10n.dart';
import '../../core/api_provider.dart';
import '../../core/theme.dart';
import '../auth/auth_provider.dart';
import 'widgets/status_badge.dart';

final driverShipmentsProvider = FutureProvider<List<Shipment>>((ref) async {
  final client = ref.watch(apiClientProvider);
  // Drivers only want to see work-in-progress on this screen
  final response = await client.getShipments();
  final List data = response.data['data'];
  return data
      .map((json) => Shipment.fromJson(json))
      .where((s) => s.status != ShipmentStatus.delivered)
      .toList();
});

class AssignedShipmentsScreen extends ConsumerWidget {
  const AssignedShipmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final shipmentsAsync = ref.watch(driverShipmentsProvider);
    final user = ref.watch(authProvider);
    final l10n = L10n.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_greeting(context), style: tt.bodySmall),
                      Text(user?.name ?? l10n.driver, style: tt.displaySmall),
                    ],
                  ),
                  const Spacer(),
                  Consumer(
                    builder: (context, ref, _) {
                      final locale = ref.watch(localeProvider);
                      return TextButton(
                        onPressed: () =>
                            ref.read(localeProvider.notifier).toggle(),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                        ),
                        child: Text(
                          locale.languageCode == 'en'
                              ? '\u{1F310} کوردی'
                              : '\u{1F310} English',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => context.push('/notifications'),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: const Center(
                        child: Text(
                          '\u{1F514}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ), // Bell 🔔
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ── Stats ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.ink, Color(0xFF1E2038)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: shipmentsAsync.when(
                  data: (shipments) {
                    final pending = shipments
                        .where((s) => s.status == ShipmentStatus.pending)
                        .length;
                    final transit = shipments
                        .where((s) => s.status == ShipmentStatus.inTransit)
                        .length;
                    final delivered = shipments
                        .where((s) => s.status == ShipmentStatus.delivered)
                        .length;
                    return Row(
                      children: [
                        _stat('${shipments.length}', l10n.total),
                        const SizedBox(width: 16),
                        _stat('$pending', l10n.pending),
                        const SizedBox(width: 16),
                        _stat('$transit', l10n.inTransit),
                        const SizedBox(width: 16),
                        _stat('$delivered', l10n.delivered),
                      ],
                    );
                  },
                  loading: () => const SizedBox(
                    height: 44,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  error: (_, _) => const SizedBox(height: 44),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Text(
                    l10n.myAssignments,
                    style: tt.labelLarge?.copyWith(
                      color: AppTheme.ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── List ──
            Expanded(
              child: shipmentsAsync.when(
                data: (shipments) {
                  if (shipments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '\u{1F69B}',
                            style: TextStyle(fontSize: 40),
                          ), // Truck 🚚
                          const SizedBox(height: 8),
                          Text(l10n.noAssignments, style: tt.titleMedium),
                          Text(l10n.noDeliveriesYet, style: tt.bodySmall),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.refresh(driverShipmentsProvider.future),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: shipments.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final shipmentItem = shipments[i];
                        return GestureDetector(
                          onTap: () =>
                              context.push('/shipments/${shipmentItem.id}'),
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
                                        l10n.routeArrow(
                                          shipmentItem.origin,
                                          shipmentItem.destination,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.ink,
                                        ),
                                      ),
                                    ),
                                    ShipmentStatusBadge(
                                      status: shipmentItem.status,
                                      compact: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        l10n.kgUnit(
                                          shipmentItem.weightKg
                                                  ?.toStringAsFixed(0) ??
                                              '0',
                                        ),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.muted,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (shipmentItem.status ==
                                        ShipmentStatus.pending)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.orange,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          l10n.acceptBtn,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    else if (shipmentItem.status ==
                                        ShipmentStatus.inTransit)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.teal,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          l10n.deliverBtn,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if ((shipmentItem.customer?.name ?? '')
                                        .isNotEmpty ||
                                    (shipmentItem.customer?.phoneNumber ?? '')
                                        .isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppTheme.border,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.phone_in_talk_rounded,
                                          size: 16,
                                          color: AppTheme.indigo,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _customerContactText(shipmentItem),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.ink,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.red,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text('${l10n.error}: $e', textAlign: TextAlign.center),
                      TextButton(
                        onPressed: () => ref.refresh(driverShipmentsProvider),
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

  String _greeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final l10n = L10n.of(context)!;
    return hour < 12
        ? l10n.goodMorning
        : hour < 17
        ? l10n.goodAfternoon
        : l10n.goodEvening;
  }

  String _customerContactText(Shipment shipment) {
    final pieces = <String>[
      if (shipment.customer?.name != null && shipment.customer!.name.isNotEmpty)
        shipment.customer!.name,
      if (shipment.customer?.phoneNumber != null &&
          shipment.customer!.phoneNumber!.isNotEmpty)
        shipment.customer!.phoneNumber!,
    ];

    return pieces.isEmpty ? 'Customer contact unavailable' : pieces.join(' • ');
  }

  Widget _stat(String num, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              num,
              style: const TextStyle(
                fontFamily: 'InstrumentSerif',
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: Color(0xFFFBBF24),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
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
