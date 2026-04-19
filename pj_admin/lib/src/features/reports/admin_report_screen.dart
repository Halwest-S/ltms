import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/api_provider.dart';
import '../../core/theme.dart';

final adminReportsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final response = await ref.read(apiClientProvider).getReports();
  return List<Map<String, dynamic>>.from(
    response.data['data'] ?? response.data,
  );
});

class AdminReportScreen extends ConsumerWidget {
  const AdminReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final l10n = L10n.of(context)!;
    final reportsAsync = ref.watch(adminReportsProvider);
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    return AdminShell(
      activeRoute: '/reports',
      title: l10n.reportOverview,
      actions: [
        IconButton(
          onPressed: () => ref.refresh(adminReportsProvider),
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
              Text(l10n.reportOverview, style: tt.headlineLarge),
              const SizedBox(height: 4),
              Text(
                'All customer reports submitted from the shipment flow.',
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 20),
            ] else ...[
              Text(l10n.reportOverview, style: tt.headlineSmall),
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
                          const Text('📊', style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 8),
                          Text(l10n.noReports, style: tt.titleMedium),
                          const SizedBox(height: 6),
                          Text(
                            'No customer reports have been submitted yet.',
                            style: tt.bodySmall?.copyWith(
                              color: AppTheme.muted,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
                        padding: const EdgeInsets.all(18),
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
                            const SizedBox(height: 10),
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
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.tealLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${l10n.staffResponse}: ${r['staff_response']}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF065F46),
                                    height: 1.5,
                                  ),
                                ),
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
