import 'package:dio/dio.dart';
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

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  String _shortId(dynamic value) {
    final text = (value ?? '').toString();
    return text.length <= 8 ? text : text.substring(0, 8);
  }

  String _statusLabel(L10n l10n, String status) => switch (status) {
    'open' => l10n.open,
    'resolved' => l10n.resolved,
    'rejected' => l10n.rejectBtn,
    'compensation_issued' => 'Compensation issued',
    _ => status,
  };

  Color _statusColor(String status) => switch (status) {
    'open' => AppTheme.amber,
    'rejected' => AppTheme.red,
    _ => AppTheme.teal,
  };

  Color _statusBackground(String status) => switch (status) {
    'open' => AppTheme.amberLight,
    'rejected' => AppTheme.redLight,
    _ => AppTheme.tealLight,
  };

  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final message = map['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }

        final errors = map['errors'];
        if (errors is Map) {
          for (final value in errors.values) {
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
          }
        }
      }

      if (error.message != null && error.message!.trim().isNotEmpty) {
        return error.message!;
      }
    }

    return error.toString();
  }

  Future<void> _respondToReport(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> report,
  ) async {
    final l10n = L10n.of(context)!;
    final reportId = _parseInt(report['id']);
    if (reportId == null) return;

    final response = await showDialog<_ReportResponse>(
      context: context,
      builder: (_) => _ReportResponseDialog(report: report),
    );

    if (response == null) return;

    try {
      await ref
          .read(apiClientProvider)
          .respondToReport(reportId, response.comment, response.status);
      ref.invalidate(adminReportsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Report response saved.')));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.error}: ${_extractErrorMessage(error)}'),
        ),
      );
    }
  }

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
                'Review customer reports and write a resolution comment.',
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
                          const Icon(
                            Icons.assessment_outlined,
                            size: 42,
                            color: AppTheme.muted,
                          ),
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
                      final status = (r['status'] ?? 'open').toString();
                      final statusColor = _statusColor(status);
                      final staffResponse = (r['staff_response'] ?? '')
                          .toString()
                          .trim();

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
                                    color: _statusBackground(status),
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
                                          color: statusColor,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        _statusLabel(
                                          l10n,
                                          status,
                                        ).toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: statusColor,
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
                                  '${l10n.shipmentLabel}: #${_shortId(r['shipment_id'])}',
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
                                (r['customer_comment'] ?? '').toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.ink,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            if (staffResponse.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.tealLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${l10n.staffResponse}: $staffResponse',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF065F46),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _respondToReport(context, ref, r),
                                icon: const Icon(Icons.rate_review_outlined),
                                label: Text(
                                  status == 'open'
                                      ? 'Write resolution'
                                      : 'Update response',
                                ),
                              ),
                            ),
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

class _ReportResponseDialog extends StatefulWidget {
  const _ReportResponseDialog({required this.report});

  final Map<String, dynamic> report;

  @override
  State<_ReportResponseDialog> createState() => _ReportResponseDialogState();
}

class _ReportResponseDialogState extends State<_ReportResponseDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _commentCtrl;
  late String _status;

  @override
  void initState() {
    super.initState();
    _commentCtrl = TextEditingController(
      text: (widget.report['staff_response'] ?? '').toString(),
    );

    final existingStatus = (widget.report['status'] ?? '').toString();
    _status = switch (existingStatus) {
      'rejected' => 'rejected',
      'compensation_issued' => 'compensation_issued',
      _ => 'resolved',
    };
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

    return AlertDialog(
      title: const Text('Resolve report'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: InputDecoration(labelText: l10n.reportStatus),
              items: [
                DropdownMenuItem(value: 'resolved', child: Text(l10n.resolved)),
                DropdownMenuItem(
                  value: 'rejected',
                  child: Text(l10n.rejectBtn),
                ),
                const DropdownMenuItem(
                  value: 'compensation_issued',
                  child: Text('Compensation issued'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _status = value);
                }
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _commentCtrl,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Resolution comment',
                hintText:
                    'Write what was checked and how the problem was solved.',
              ),
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return l10n.required;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(
              _ReportResponse(
                status: _status,
                comment: _commentCtrl.text.trim(),
              ),
            );
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

class _ReportResponse {
  const _ReportResponse({required this.status, required this.comment});

  final String status;
  final String comment;
}
