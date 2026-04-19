import 'package:flutter/material.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_l10n/pj_l10n.dart';
import '../../../core/theme.dart';

class ShipmentCard extends StatelessWidget {
  final Shipment shipment;
  final VoidCallback onTap;

  const ShipmentCard({
    super.key,
    required this.shipment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = shipment;
    final l10n = L10n.of(context);

    final (Color statusBg, Color statusFg, Color statusDot, String statusLabel) =
        switch (s.status) {
      ShipmentStatus.pending => (
          AppTheme.amberLight,
          const Color(0xFF92400E),
          AppTheme.amber,
          (l10n?.pending ?? 'Pending').toUpperCase()
        ),
      ShipmentStatus.inTransit => (
          AppTheme.blueLight,
          const Color(0xFF1D4ED8),
          AppTheme.blue,
          (l10n?.inTransit ?? 'In Transit').toUpperCase()
        ),
      ShipmentStatus.delivered => (
          AppTheme.tealLight,
          const Color(0xFF065F46),
          AppTheme.teal,
          (l10n?.delivered ?? 'Delivered').toUpperCase()
        ),
      ShipmentStatus.reported => (
          AppTheme.redLight,
          const Color(0xFF991B1B),
          AppTheme.red,
          (l10n?.reported ?? 'Reported').toUpperCase()
        ),
    };

    final String transportIcon = switch (s.status) {
      ShipmentStatus.pending => '\u{231B}', // Hourglass ⌛
      ShipmentStatus.inTransit => '\u{1F69B}', // Truck 🚚
      ShipmentStatus.delivered => '\u{2705}', // Check ✅
      ShipmentStatus.reported => '\u{26A0}', // Warning ⚠️
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(transportIcon, style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${s.origin} \u{2192} ${s.destination}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '#${s.id.substring(0, 8).toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusDot,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: statusFg,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                _infoChip(
                  context,
                  icon: Icons.scale_outlined,
                  label: s.weightKg != null
                      ? L10n.of(context)!.kgUnit(s.weightKg!.toStringAsFixed(1))
                      : s.size ?? L10n.of(context)!.noData,
                ),
                const SizedBox(width: 10),
                _infoChip(
                  context,
                  icon: Icons.schedule_rounded,
                  label: '${s.estimatedDeliveryDays} ${L10n.of(context)?.days ?? 'days'}',
                ),
                const Spacer(),
                Text(
                  '\$${s.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: 'InstrumentSerif',
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: AppTheme.ink,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(BuildContext context, {required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppTheme.muted),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
