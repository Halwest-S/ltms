import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/api_provider.dart';
import '../../core/layout_preferences.dart';
import '../../core/theme.dart';
import '../shell/staff_shell.dart';

final reportsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await ref.read(apiClientProvider).getReports();
  return List<Map<String, dynamic>>.from(
    response.data['data'] ?? response.data,
  );
});

class ReportManagementScreen extends ConsumerWidget {
  const ReportManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final l10n = L10n.of(context)!;
    final reportsAsync = ref.watch(reportsProvider);
    final isCompact = useCompactStaffLayout(context, ref);

    return StaffShell(
      activeRoute: '/reports',
      title: l10n.reports,
      actions: [
        IconButton(
          onPressed: () => ref.refresh(reportsProvider),
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
              Text(l10n.reportQueue, style: tt.headlineLarge),
              const SizedBox(height: 4),
              Text(
                l10n.reportQueueSubtitle,
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 20),
            ] else ...[
              Text(l10n.reportQueue, style: tt.headlineSmall),
              const SizedBox(height: 4),
              Text(
                l10n.reportQueueSubtitle,
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: reportsAsync.when(
                data: (reports) {
                  if (reports.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '\u{1F4CA}',
                            style: TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 8),
                          Text(l10n.noReports, style: tt.titleMedium),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: reports.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final r = reports[i];
                      final isOpen = r['status'] == 'open';
                      return Container(
                        padding: EdgeInsets.all(isCompact ? 16 : 20),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isOpen
                                        ? AppTheme.amberLight
                                        : AppTheme.tealLight,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isOpen
                                              ? AppTheme.amber
                                              : AppTheme.teal,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        isOpen
                                            ? l10n.open.toUpperCase()
                                            : l10n.resolved.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isOpen
                                              ? const Color(0xFF92400E)
                                              : const Color(0xFF065F46),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${l10n.reportLabel} #${r['id']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: AppTheme.ink,
                                  ),
                                ),
                                Text(
                                  '${l10n.shipmentLabel}: #${(r['shipment_id'] as String).substring(0, 8)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.muted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${l10n.customerLabel}:',
                              style: tt.labelLarge,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                r['customer_comment'] ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.ink,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            if (!isOpen && r['staff_response'] != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                l10n.staffResponseLabel,
                                style: tt.labelLarge,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.tealLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  r['staff_response'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.ink,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                            if (isOpen) ...[
                              const SizedBox(height: 14),
                              if (isCompact)
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await ref
                                            .read(apiClientProvider)
                                            .respondToReport(
                                              r['id'],
                                              'Resolved by staff',
                                              'resolved',
                                            );
                                        ref.invalidate(reportsProvider);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.teal,
                                      ),
                                      child: Text(l10n.resolveBtn),
                                    ),
                                    const SizedBox(height: 8),
                                    OutlinedButton(
                                      onPressed: () async {
                                        await ref
                                            .read(apiClientProvider)
                                            .respondToReport(
                                              r['id'],
                                              'Rejected by staff',
                                              'rejected',
                                            );
                                        ref.invalidate(reportsProvider);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppTheme.red,
                                        side: const BorderSide(
                                          color: AppTheme.red,
                                        ),
                                      ),
                                      child: Text(l10n.rejectBtn),
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await ref
                                              .read(apiClientProvider)
                                              .respondToReport(
                                                r['id'],
                                                'Resolved by staff',
                                                'resolved',
                                              );
                                          ref.invalidate(reportsProvider);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.teal,
                                        ),
                                        child: Text(l10n.resolveBtn),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          await ref
                                              .read(apiClientProvider)
                                              .respondToReport(
                                                r['id'],
                                                'Rejected by staff',
                                                'rejected',
                                              );
                                          ref.invalidate(reportsProvider);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppTheme.red,
                                          side: const BorderSide(
                                            color: AppTheme.red,
                                          ),
                                        ),
                                        child: Text(l10n.rejectBtn),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('${l10n.error}: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
