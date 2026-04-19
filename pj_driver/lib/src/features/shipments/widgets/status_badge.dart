import 'package:flutter/material.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../../core/theme.dart';

class ShipmentStatusBadge extends StatelessWidget {
  const ShipmentStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  final ShipmentStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, dot, label, icon) = _details(context);

    if (compact) {
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
              decoration: BoxDecoration(shape: BoxShape.circle, color: dot),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: fg.withAlpha(60)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: fg),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10n.of(context)!.shipmentStatus,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: fg,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  (Color, Color, Color, String, IconData) _details(BuildContext context) {
    final l10n = L10n.of(context)!;
    return switch (status) {
      ShipmentStatus.inTransit => (
          AppTheme.blueLight,
          const Color(0xFF1D4ED8),
          AppTheme.blue,
          l10n.inTransit,
          Icons.local_shipping_rounded,
        ),
      ShipmentStatus.pending => (
          AppTheme.amberLight,
          const Color(0xFF92400E),
          AppTheme.amber,
          l10n.pending,
          Icons.schedule_rounded,
        ),
      ShipmentStatus.delivered => (
          AppTheme.tealLight,
          const Color(0xFF065F46),
          AppTheme.teal,
          l10n.delivered,
          Icons.check_circle_rounded,
        ),
      ShipmentStatus.reported => (
          AppTheme.redLight,
          const Color(0xFF991B1B),
          AppTheme.red,
          l10n.reported,
          Icons.report_problem_rounded,
        ),
    };
  }
}
