import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_domain/pj_domain.dart';
import '../../core/api_provider.dart';
import '../../core/theme.dart';
import 'shipment_provider.dart';
import 'package:pj_l10n/pj_l10n.dart';

class ShipmentDetailScreen extends ConsumerWidget {
  final String shipmentId;
  const ShipmentDetailScreen({super.key, required this.shipmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('${L10n.of(context)!.shipments} #${shipmentId.substring(0, 8)}'),
      ),
      body: FutureBuilder(
        future: ref.read(apiClientProvider).getShipmentDetail(shipmentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('${L10n.of(context)!.error}: ${snapshot.error}'));
          final s = Shipment.fromJson(snapshot.data?.data);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Route Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(L10n.of(context)!.route, style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                    Text('${s.origin}\n\u{2192} ${s.destination}', style: Theme.of(context).textTheme.displaySmall), // Arrow →
                    const SizedBox(height: 6),
                    Text(
                      '${s.weightKg != null ? L10n.of(context)!.kgUnit(s.weightKg!.toStringAsFixed(0)) : s.size ?? ''} · ${L10n.of(context)!.estimatedDelivery}: ${s.estimatedDeliveryDays} ${L10n.of(context)!.days}',
                      style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                    ),
                  ]),
                ),
                const SizedBox(height: 12),

                // Timeline
                Text(L10n.of(context)!.liveTracking, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.ink, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                _buildTimeline(context, s.status),
                const SizedBox(height: 12),

                // Price Breakdown
                if (s.priceBreakdown case final pb?) ...[
                  Text(L10n.of(context)!.priceBreakdownTitle, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.ink, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
                    child: Column(children: [
                      _priceRow(L10n.of(context)!.baseWeightSurcharge, '\$${pb['base_price'] ?? '0'}'),
                      _priceRow(L10n.of(context)!.vehicleMultiplier, 'x${s.priceBreakdown!['vehicle_multiplier'] ?? '1'}'),
                      Divider(color: AppTheme.border),
                      _priceRow(L10n.of(context)!.totalPaid, '\$${s.totalPrice.toStringAsFixed(2)}', isTotal: true),
                    ]),
                  ),
                ],
                const SizedBox(height: 20),

                // Actions
                Row(children: [
                  if (s.status == ShipmentStatus.delivered) Expanded(flex: 3, child: SizedBox(height: 52, child: ElevatedButton(
                    onPressed: () => _confirmDelivery(context, ref),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.teal),
                    child: Text('\u{2713} ${L10n.of(context)!.markDelivered}'), // Check ✓
                  ))),
                  if (s.status == ShipmentStatus.delivered) const SizedBox(width: 8),
                  if (s.status != ShipmentStatus.reported) Expanded(flex: 2, child: SizedBox(height: 52, child: OutlinedButton(
                    onPressed: () => context.push('/shipments/${s.id}/report'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppTheme.red, side: const BorderSide(color: AppTheme.red), backgroundColor: AppTheme.redLight),
                    child: Text(L10n.of(context)!.reportIssue),
                  ))),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, ShipmentStatus current) {
    final steps = [
      (L10n.of(context)!.orderPlaced, Icons.check_circle_rounded, ShipmentStatus.pending),
      (L10n.of(context)!.inTransit, Icons.local_shipping_rounded, ShipmentStatus.inTransit),
      (L10n.of(context)!.delivered, Icons.inventory_2_rounded, ShipmentStatus.delivered),
    ];
    final currentIdx = [ShipmentStatus.pending, ShipmentStatus.inTransit, ShipmentStatus.delivered].indexOf(current).clamp(0, 2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
      child: Column(children: List.generate(steps.length, (i) {
        final isDone = i < currentIdx;
        final isActive = i == currentIdx;
        final isLast = i == steps.length - 1;
        final color = isDone ? AppTheme.teal : isActive ? AppTheme.blue : AppTheme.border;

        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(children: [
            Container(
              width: 12, height: 12,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: Border.all(color: isActive ? const Color(0xFFBFDBFE) : Colors.transparent, width: isActive ? 3 : 0)),
            ),
            if (!isLast) Container(width: 2, height: 40, color: isDone ? AppTheme.teal : AppTheme.border),
          ]),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(steps[i].$1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isActive ? AppTheme.blue : isDone ? AppTheme.ink : AppTheme.muted)),
            if (isActive) Text(L10n.of(context)!.nowLabel, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
          ]),
        ]);
      })),
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(color: isTotal ? AppTheme.ink : AppTheme.muted, fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500, fontSize: 13)),
      Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: isTotal ? AppTheme.teal : AppTheme.ink, fontSize: isTotal ? 16 : 13)),
    ]),
  );

  void _confirmDelivery(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(L10n.of(context)!.confirmDelivery),
      content: Text(L10n.of(context)!.deliveredSuccessfully),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(L10n.of(context)!.cancel)),
        ElevatedButton(
          onPressed: () async {
            await ref.read(apiClientProvider).updateShipmentStatus(shipmentId, 'delivered');
            if (ctx.mounted) Navigator.pop(ctx);
            ref.invalidate(customerShipmentsProvider);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.teal),
          child: Text(L10n.of(context)!.confirm),
        ),
      ],
    ));
  }
}
