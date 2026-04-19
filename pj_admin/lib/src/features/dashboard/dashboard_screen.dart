import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';
import 'package:uuid/uuid.dart';

import '../../core/admin_shell.dart';
import '../../core/theme.dart';
import '../auth/auth_provider.dart';
import 'shipment_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _hasShownKeyChangeDialog = false;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final l10n = L10n.of(context)!;
    final user = ref.watch(authProvider);
    final locale = ref.watch(localeProvider);
    final lastKeyChange = ref.watch(lastKeyChangeProvider);
    final shipmentsAsync = ref.watch(shipmentListProvider);
    final selectedFilter = ref.watch(shipmentStatusFilterProvider);
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    final filters = <({ShipmentStatus? value, String label})>[
      (value: null, label: l10n.all),
      (value: ShipmentStatus.pending, label: l10n.pending),
      (value: ShipmentStatus.inTransit, label: l10n.inTransit),
      (value: ShipmentStatus.delivered, label: l10n.delivered),
      (value: ShipmentStatus.reported, label: l10n.reported),
    ];

    if (user != null &&
        DateTime.now().difference(lastKeyChange) > const Duration(days: 90) &&
        !_hasShownKeyChangeDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.changeAdminKey),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.keyExpiredMessage),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    const uuid = Uuid();
                    final newKey = uuid.v4();
                    await ref
                        .read(lastKeyChangeProvider.notifier)
                        .markChangedNow();
                    // ignore: avoid_print
                    print('New key saved: $newKey');
                    if (!context.mounted) return;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(l10n.generateNewKey),
                ),
              ],
            ),
          ),
        ).then((_) {
          if (mounted) {
            setState(() => _hasShownKeyChangeDialog = true);
          }
        });
      });
    }

    return AdminShell(
      activeRoute: '/',
      title: l10n.overview,
      actions: [
        IconButton(
          onPressed: () => ref.read(localeProvider.notifier).toggle(),
          tooltip: locale.languageCode == 'ku' ? l10n.english : l10n.kurdish,
          icon: const Icon(Icons.language_rounded),
        ),
        IconButton(
          onPressed: () => ref.refresh(shipmentListProvider),
          tooltip: l10n.refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.overview, style: tt.headlineLarge),
                        const SizedBox(height: 2),
                        Text(
                          l10n.systemOverview,
                          style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => ref.read(localeProvider.notifier).toggle(),
                    icon: const Text(
                      '\u{1F310}',
                      style: TextStyle(fontSize: 16),
                    ),
                    label: Text(
                      locale.languageCode == 'ku' ? l10n.english : l10n.kurdish,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => ref.refresh(shipmentListProvider),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(l10n.refresh),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.rose,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
            ] else ...[
              Text(l10n.overview, style: tt.headlineSmall),
              const SizedBox(height: 4),
              Text(
                l10n.systemOverview,
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 16),
            ],
            shipmentsAsync.when(
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
                final reported = shipments
                    .where((s) => s.status == ShipmentStatus.reported)
                    .length;

                final stats = [
                  (
                    emoji: '\u{1F4E6}',
                    value: shipments.length,
                    label: l10n.total,
                    bg: AppTheme.roseLight,
                  ),
                  (
                    emoji: '\u{231B}',
                    value: pending,
                    label: l10n.pendingCount,
                    bg: AppTheme.amberLight,
                  ),
                  (
                    emoji: '\u{1F69B}',
                    value: transit,
                    label: l10n.transit,
                    bg: AppTheme.blueLight,
                  ),
                  (
                    emoji: '\u{2705}',
                    value: delivered,
                    label: l10n.deliveredCount,
                    bg: AppTheme.tealLight,
                  ),
                  (
                    emoji: '\u{26A0}',
                    value: reported,
                    label: l10n.reportedCount,
                    bg: AppTheme.redLight,
                  ),
                ];

                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (isCompact) {
                      final itemWidth = constraints.maxWidth > 520
                          ? (constraints.maxWidth - 12) / 2
                          : constraints.maxWidth;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          for (final stat in stats)
                            SizedBox(
                              width: itemWidth,
                              child: _StatCard(
                                emoji: stat.emoji,
                                value: stat.value,
                                label: stat.label,
                                bg: stat.bg,
                              ),
                            ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        for (var i = 0; i < stats.length; i++) ...[
                          Expanded(
                            child: _StatCard(
                              emoji: stats[i].emoji,
                              value: stats[i].value,
                              label: stats[i].label,
                              bg: stats[i].bg,
                            ),
                          ),
                          if (i < stats.length - 1) const SizedBox(width: 12),
                        ],
                      ],
                    );
                  },
                );
              },
              loading: () => const SizedBox(height: 88),
              error: (_, _) => const SizedBox(height: 88),
            ),
            const SizedBox(height: 22),
            // ── Filters & Search ──
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final filter = filters[i];
                        return ShipmentFilterChip(
                          label: filter.label,
                          isActive: selectedFilter == filter.value,
                          activeColor: AppTheme.rose,
                          onTap: () =>
                              ref
                                  .read(shipmentStatusFilterProvider.notifier)
                                  .state = filter
                                  .value,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 280,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (val) =>
                        ref.read(shipmentSearchProvider.notifier).state = val,
                    decoration: InputDecoration(
                      hintText: l10n.searchPlaceholder,
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.muted,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: AppTheme.muted,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 9),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(6),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: shipmentsAsync.when(
                  data: (shipments) => ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final tableWidth = constraints.maxWidth < 760
                            ? 760.0
                            : constraints.maxWidth;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: tableWidth,
                            child: DataTable2(
                              columnSpacing: 12,
                              horizontalMargin: 20,
                              minWidth: 600,
                              headingRowHeight: 48,
                              headingTextStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.muted,
                                letterSpacing: 0.5,
                              ),
                              dataTextStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppTheme.ink,
                              ),
                              columns: [
                                DataColumn2(
                                  label: Text(l10n.id),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(label: Text(l10n.route)),
                                DataColumn2(
                                  label: Text(l10n.weightLabel),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(
                                  label: Text(l10n.priceLabel),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(
                                  label: Text(l10n.statusLabel),
                                  size: ColumnSize.S,
                                ),
                              ],
                              rows: shipments.map((s) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        '#${s.id.substring(0, 8)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        '${s.origin} \u{2192} ${s.destination}',
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        s.weightKg != null
                                            ? l10n.kgUnit(
                                                s.weightKg!.toStringAsFixed(0),
                                              )
                                            : '-',
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        '\$${s.totalPrice.toStringAsFixed(2)}',
                                      ),
                                    ),
                                    DataCell(
                                      StatusBadge(
                                        status: s.status,
                                        label: switch (s.status) {
                                          ShipmentStatus.pending =>
                                            l10n.pending,
                                          ShipmentStatus.inTransit =>
                                            l10n.inTransit,
                                          ShipmentStatus.delivered =>
                                            l10n.delivered,
                                          ShipmentStatus.reported =>
                                            l10n.reported,
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('${l10n.error}: $e')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final int value;
  final String label;
  final Color bg;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border.withAlpha(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.ink,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
