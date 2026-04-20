import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_domain/pj_domain.dart';
import '../../core/api_provider.dart';
import '../../core/theme.dart';
import 'shipment_provider.dart';
import 'package:pj_l10n/pj_l10n.dart';

final customerShipmentDetailProvider = FutureProvider.family<Shipment, String>((
  ref,
  id,
) async {
  final response = await ref.watch(apiClientProvider).getShipmentDetail(id);
  return Shipment.fromJson(response.data);
});

class ShipmentDetailScreen extends ConsumerWidget {
  final String shipmentId;
  const ShipmentDetailScreen({super.key, required this.shipmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shipmentAsync = ref.watch(customerShipmentDetailProvider(shipmentId));

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          '${L10n.of(context)!.shipments} #${shipmentId.substring(0, 8)}',
        ),
      ),
      body: shipmentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${L10n.of(context)!.error}: $error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(customerShipmentDetailProvider(shipmentId)),
                child: Text(L10n.of(context)!.retry),
              ),
            ],
          ),
        ),
        data: (shipment) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(customerShipmentDetailProvider(shipmentId));
            await ref.read(customerShipmentDetailProvider(shipmentId).future);
          },
          child: _ShipmentDetailBody(
            shipment: shipment,
            onConfirmDelivery: () => _confirmDelivery(context, ref),
          ),
        ),
      ),
    );
  }

  void _confirmDelivery(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        var isSubmitting = false;

        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Text(L10n.of(context)!.confirmDelivery),
            content: Text(L10n.of(context)!.confirmDeliveryQuestion),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                child: Text(L10n.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        setDialogState(() => isSubmitting = true);

                        try {
                          await ref
                              .read(apiClientProvider)
                              .updateShipmentStatus(shipmentId, 'delivered');
                          ref.invalidate(
                            customerShipmentDetailProvider(shipmentId),
                          );
                          ref.invalidate(customerShipmentsProvider);

                          if (ctx.mounted) Navigator.pop(ctx);
                        } catch (error) {
                          if (ctx.mounted) {
                            setDialogState(() => isSubmitting = false);
                          }

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${L10n.of(context)!.error}: $error',
                              ),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.teal),
                child: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(L10n.of(context)!.confirm),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShipmentDetailBody extends StatelessWidget {
  const _ShipmentDetailBody({
    required this.shipment,
    required this.onConfirmDelivery,
  });

  final Shipment shipment;
  final VoidCallback onConfirmDelivery;

  @override
  Widget build(BuildContext context) {
    final deliveryConfirmed = shipment.deliveryConfirmedAt != null;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _routeCard(context),
          const SizedBox(height: 12),
          Text(
            L10n.of(context)!.liveTracking,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          _buildTimeline(
            context,
            shipment.status,
            deliveryConfirmed: deliveryConfirmed,
          ),
          const SizedBox(height: 12),
          if (shipment.priceBreakdown case final priceBreakdown?) ...[
            Text(
              L10n.of(context)!.priceBreakdownTitle,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppTheme.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            _priceBreakdownCard(context, priceBreakdown),
          ],
          const SizedBox(height: 20),
          if (deliveryConfirmed)
            _confirmedDeliveryBanner(context)
          else
            _actions(context),
        ],
      ),
    );
  }

  Widget _routeCard(BuildContext context) {
    final weightOrSize = shipment.weightKg != null
        ? L10n.of(context)!.kgUnit(shipment.weightKg!.toStringAsFixed(0))
        : shipment.size ?? '';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _screenText(context, ku: 'بەرهەم', en: 'Product'),
            style: TextStyle(fontSize: 13, color: AppTheme.muted),
          ),
          Text(_productTitle, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          Text(
            L10n.of(context)!.routeArrow(shipment.origin, shipment.destination),
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          if (shipment.productColor != null || shipment.productSize != null)
            Text(
              [
                if (shipment.productColor case final color?)
                  '${_screenText(context, ku: 'ڕەنگ', en: 'Color')}: $color',
                if (shipment.productSize case final size?)
                  '${_screenText(context, ku: 'قەبارە', en: 'Size')}: $size',
              ].join(' - '),
              style: const TextStyle(fontSize: 12, color: AppTheme.muted),
            ),
          if (shipment.productColor != null || shipment.productSize != null)
            const SizedBox(height: 4),
          Text(
            '$weightOrSize - ${L10n.of(context)!.estimatedDelivery}: ${shipment.estimatedDeliveryDays} ${L10n.of(context)!.days}',
            style: const TextStyle(fontSize: 12, color: AppTheme.muted),
          ),
        ],
      ),
    );
  }

  String get _productTitle {
    final title = shipment.productTitle?.trim();
    if (title != null && title.isNotEmpty) {
      return title;
    }

    final platform = shipment.productPlatform?.trim();
    return platform == null || platform.isEmpty
        ? shipment.id.substring(0, 8)
        : platform.toUpperCase();
  }

  String _screenText(
    BuildContext context, {
    required String ku,
    required String en,
  }) {
    return L10n.of(context)!.localeName == 'ku' ? ku : en;
  }

  Widget _buildTimeline(
    BuildContext context,
    ShipmentStatus current, {
    required bool deliveryConfirmed,
  }) {
    final steps = [
      (
        L10n.of(context)!.orderPlaced,
        Icons.check_circle_rounded,
        ShipmentStatus.pending,
      ),
      (
        L10n.of(context)!.inTransit,
        Icons.local_shipping_rounded,
        ShipmentStatus.inTransit,
      ),
      (
        L10n.of(context)!.delivered,
        Icons.inventory_2_rounded,
        ShipmentStatus.delivered,
      ),
    ];
    final currentIdx = [
      ShipmentStatus.pending,
      ShipmentStatus.inTransit,
      ShipmentStatus.delivered,
    ].indexOf(current).clamp(0, 2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: List.generate(steps.length, (i) {
          final isConfirmedDeliveryStep =
              deliveryConfirmed && steps[i].$3 == ShipmentStatus.delivered;
          final isDone = i < currentIdx || isConfirmedDeliveryStep;
          final isActive = i == currentIdx && !isConfirmedDeliveryStep;
          final isLast = i == steps.length - 1;
          final color = isDone
              ? AppTheme.teal
              : isActive
              ? AppTheme.blue
              : AppTheme.border;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFFBFDBFE)
                            : Colors.transparent,
                        width: isActive ? 3 : 0,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: isDone ? AppTheme.teal : AppTheme.border,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    steps[i].$1,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isConfirmedDeliveryStep
                          ? AppTheme.teal
                          : isActive
                          ? AppTheme.blue
                          : isDone
                          ? AppTheme.ink
                          : AppTheme.muted,
                    ),
                  ),
                  if (isConfirmedDeliveryStep)
                    Text(
                      L10n.of(context)!.deliveredSuccessfully,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.teal,
                      ),
                    )
                  else if (isActive)
                    Text(
                      L10n.of(context)!.nowLabel,
                      style: TextStyle(fontSize: 12, color: AppTheme.muted),
                    ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _priceBreakdownCard(
    BuildContext context,
    Map<String, dynamic> priceBreakdown,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          _priceRow(
            L10n.of(context)!.baseWeightSurcharge,
            '\$${priceBreakdown['base_price'] ?? '0'}',
          ),
          _priceRow(
            L10n.of(context)!.vehicleMultiplier,
            'x${priceBreakdown['vehicle_multiplier'] ?? '1'}',
          ),
          Divider(color: AppTheme.border),
          _priceRow(
            L10n.of(context)!.totalPaid,
            '\$${shipment.totalPrice.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppTheme.ink : AppTheme.muted,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: isTotal ? AppTheme.teal : AppTheme.ink,
              fontSize: isTotal ? 16 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      children: [
        if (shipment.status == ShipmentStatus.delivered)
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: onConfirmDelivery,
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.teal),
                child: Text('\u{2713} ${L10n.of(context)!.markDelivered}'),
              ),
            ),
          ),
        if (shipment.status == ShipmentStatus.delivered)
          const SizedBox(width: 8),
        if (shipment.status != ShipmentStatus.reported)
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () =>
                    context.push('/shipments/${shipment.id}/report'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.red,
                  side: const BorderSide(color: AppTheme.red),
                  backgroundColor: AppTheme.redLight,
                ),
                child: Text(L10n.of(context)!.reportIssue),
              ),
            ),
          ),
      ],
    );
  }

  Widget _confirmedDeliveryBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.tealLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.teal.withAlpha(70)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppTheme.teal,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              L10n.of(context)!.deliveredSuccessfully,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF065F46),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
