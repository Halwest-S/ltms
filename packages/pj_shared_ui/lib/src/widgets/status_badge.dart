import 'package:flutter/material.dart';
import 'package:pj_domain/pj_domain.dart';

class StatusBadge extends StatelessWidget {
  final ShipmentStatus status;
  final String label;

  const StatusBadge({super.key, required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final Color color = switch (status) {
      ShipmentStatus.pending => const Color(0xFFF59E0B),
      ShipmentStatus.inTransit => const Color(0xFF3B82F6),
      ShipmentStatus.delivered => const Color(0xFF10B981),
      ShipmentStatus.reported => const Color(0xFFEF4444),
    };

    final IconData icon = switch (status) {
      ShipmentStatus.pending => Icons.hourglass_bottom_rounded,
      ShipmentStatus.inTransit => Icons.local_shipping_rounded,
      ShipmentStatus.delivered => Icons.check_circle_rounded,
      ShipmentStatus.reported => Icons.report_rounded,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}
