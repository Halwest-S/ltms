import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/theme.dart';

class ShipmentDetailScreen extends ConsumerWidget {
  final String shipmentId;

  const ShipmentDetailScreen({super.key, required this.shipmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final tt = Theme.of(context).textTheme;
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    return AdminShell(
      activeRoute: '/',
      title: l10n.shipmentDetails,
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.shipmentDetails,
                    style: isCompact ? tt.headlineSmall : tt.headlineLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.amberLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  l10n.pendingCount,
                                  style: const TextStyle(
                                    color: AppTheme.amber,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '#${shipmentId.substring(0, 8)}',
                                style: const TextStyle(
                                  color: AppTheme.muted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (isCompact)
                            Column(
                              children: [
                                _infoColumn(l10n.origin, 'بەغدا، عێراق'),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Icon(
                                    Icons.arrow_downward_rounded,
                                    color: AppTheme.muted,
                                  ),
                                ),
                                _infoColumn(l10n.destination, 'هەولێر، عێراق'),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: _infoColumn(
                                    l10n.origin,
                                    'بەغدا، عێراق',
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: AppTheme.muted,
                                  ),
                                ),
                                Expanded(
                                  child: _infoColumn(
                                    l10n.destination,
                                    'هەولێر، عێراق',
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isCompact)
                      Column(
                        children: [
                          _detailCard(
                            title: l10n.shipmentDetails,
                            child: Column(
                              children: [
                                _detailRow(l10n.weight, l10n.kgUnit('25')),
                                _detailRow(l10n.category, 'بەڵگەنامەکان'),
                                _detailRow(l10n.vehicleType, 'ڤان'),
                                _detailRow(
                                  l10n.estimatedDelivery,
                                  '3 ${l10n.days}',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _detailCard(
                            title: l10n.customer,
                            child: Column(
                              children: [
                                _detailRow(l10n.nameLabel, 'Ahmed Ali'),
                                _detailRow(l10n.email, 'ahmed@example.com'),
                                _detailRow('مۆبایل', '+964 750 123 4567'),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _detailCard(
                              title: l10n.shipmentDetails,
                              child: Column(
                                children: [
                                  _detailRow(l10n.weight, l10n.kgUnit('25')),
                                  _detailRow(l10n.category, 'بەڵگەنامەکان'),
                                  _detailRow(l10n.vehicleType, 'ڤان'),
                                  _detailRow(
                                    l10n.estimatedDelivery,
                                    '3 ${l10n.days}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _detailCard(
                              title: l10n.customer,
                              child: Column(
                                children: [
                                  _detailRow(l10n.nameLabel, 'Ahmed Ali'),
                                  _detailRow(l10n.email, 'ahmed@example.com'),
                                  _detailRow('مۆبایل', '+964 750 123 4567'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    _detailCard(
                      title: l10n.priceBreakdown,
                      child: Column(
                        children: [
                          _detailRow(l10n.basePrice, '\$10.00'),
                          _detailRow('نرخی کێش (25kg × \$0.50)', '\$12.50'),
                          _detailRow('زیادەی پۆل', '\$5.00'),
                          _detailRow('زێدەکەری ئامێر (1.2x)', '+\$3.30'),
                          const Divider(height: 24),
                          _detailRow(l10n.total, '\$30.80', isBold: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isCompact)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.local_shipping),
                            label: Text(l10n.assignDriver),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.rose,
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                            label: Text(l10n.edit),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.local_shipping),
                            label: Text(l10n.assignDriver),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.rose,
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                            label: Text(l10n.edit),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppTheme.muted, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppTheme.muted)),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
