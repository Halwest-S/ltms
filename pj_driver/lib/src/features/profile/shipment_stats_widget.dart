import 'package:flutter/material.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/theme.dart';

class ShipmentStatsWidget extends StatelessWidget {
  const ShipmentStatsWidget({super.key, required this.shipments});

  final List<Shipment> shipments;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final pending = shipments
        .where((shipment) => shipment.status == ShipmentStatus.pending)
        .length;
    final inTransit = shipments
        .where((shipment) => shipment.status == ShipmentStatus.inTransit)
        .length;
    final delivered = shipments
        .where((shipment) => shipment.status == ShipmentStatus.delivered)
        .length;

    return Row(
      children: [
        _statItem(l10n.pending, pending.toString(), AppTheme.amber),
        const SizedBox(width: 12),
        _statItem(l10n.inTransit, inTransit.toString(), AppTheme.blue),
        const SizedBox(width: 12),
        _statItem(l10n.delivered, delivered.toString(), AppTheme.teal),
      ],
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
