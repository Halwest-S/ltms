import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_domain/pj_domain.dart';
import '../../core/api_provider.dart';
import '../../core/theme.dart';
import 'assigned_shipments_screen.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'widgets/status_badge.dart';

final shipmentDetailProvider = FutureProvider.family<Shipment, String>((ref, id) async {
  final client = ref.watch(apiClientProvider);
  final response = await client.getShipmentDetail(id);
  return Shipment.fromJson(response.data);
});

class ShipmentActionScreen extends ConsumerWidget {
  final String shipmentId;
  const ShipmentActionScreen({super.key, required this.shipmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final shipmentAsync = ref.watch(shipmentDetailProvider(shipmentId));
    final l10n = L10n.of(context)!;

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: Text('#${shipmentId.substring(0, 8)}')),
      body: shipmentAsync.when(
        data: (s) => SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Route Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l10n.route, style: tt.bodySmall),
                Text('${s.origin}\n→ ${s.destination}', style: tt.displaySmall),
                const SizedBox(height: 8),
                _infoRow(
                  l10n.weightLabel,
                  l10n.kgUnit(
                    s.weightKg?.toStringAsFixed(0) ?? '0',
                  ),
                ),
                _infoRow(l10n.days, '${s.estimatedDeliveryDays}'),
                _infoRow(l10n.priceLabel, '\$${s.totalPrice.toStringAsFixed(2)}'),
              ]),
            ),
            if ((s.customer?.name ?? '').isNotEmpty ||
                (s.customer?.phoneNumber ?? '').isNotEmpty ||
                (s.customer?.email ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Customer Contact', style: tt.titleMedium),
                    const SizedBox(height: 10),
                    if ((s.customer?.name ?? '').isNotEmpty)
                      _infoRow('Name', s.customer!.name),
                    if ((s.customer?.phoneNumber ?? '').isNotEmpty)
                      _infoRow('Phone', s.customer!.phoneNumber!),
                    if ((s.customer?.email ?? '').isNotEmpty)
                      _infoRow('Email', s.customer!.email),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),

            // Status Badge (Large)
            ShipmentStatusBadge(status: s.status),
            const SizedBox(height: 24),

            // Action buttons
            if (s.status == ShipmentStatus.pending)
              ElevatedButton(
                onPressed: () => _updateStatus(context, ref, ShipmentStatus.inTransit),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.blue, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                child: Text(l10n.acceptStartTransit),
              ),
            if (s.status == ShipmentStatus.inTransit)
              ElevatedButton(
                onPressed: () => _updateStatus(context, ref, ShipmentStatus.delivered),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.teal, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                child: Text(l10n.markAsDelivered),
              ),
            if (s.status == ShipmentStatus.delivered)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.tealLight, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.teal.withAlpha(60))),
                child: Row(children: [
                  const Text('✅', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Text(l10n.deliveredSuccessfully, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF065F46))),
                ]),
              ),
          ]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppTheme.red, size: 40),
            const SizedBox(height: 12),
            Text('${l10n.error}: $e', textAlign: TextAlign.center),
            TextButton(
              onPressed: () => ref.refresh(shipmentDetailProvider(shipmentId)),
              child: Text(l10n.retry),
            ),
          ],
        )),
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w500, fontSize: 13)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.ink, fontSize: 13)),
    ]),
  );

  Future<void> _updateStatus(BuildContext context, WidgetRef ref, ShipmentStatus newStatus) async {
    try {
      // API expects strings like 'in_transit', 'delivered'
      final statusString = switch (newStatus) {
        ShipmentStatus.inTransit => 'in_transit',
        ShipmentStatus.pending => 'pending',
        ShipmentStatus.delivered => 'delivered',
        ShipmentStatus.reported => 'reported',
      };
      
      await ref.read(apiClientProvider).updateShipmentStatus(shipmentId, statusString);
      
      // Refresh both list and detail
      ref.invalidate(driverShipmentsProvider);
      ref.invalidate(shipmentDetailProvider(shipmentId));
      
      if (context.mounted) {
        final l10n = L10n.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.statusUpdated(statusString))));
        context.go('/');
      }
    } catch (e) {
      if (context.mounted) {
        final l10n = L10n.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.error}: $e')));
      }
    }
  }
}
