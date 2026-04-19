import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_provider.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';

class ReportSubmissionScreen extends ConsumerStatefulWidget {
  final String shipmentId;
  const ReportSubmissionScreen({super.key, required this.shipmentId});

  @override
  ConsumerState<ReportSubmissionScreen> createState() => _ReportSubmissionScreenState();
}

class _ReportSubmissionScreenState extends ConsumerState<ReportSubmissionScreen> {
  final _commentCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: Text(L10n.of(context)!.reportAnIssue)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // Shipment info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(color: AppTheme.redLight, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFFCA5A5))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(L10n.of(context)!.shipmentLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.red, letterSpacing: 0.6)),
              const SizedBox(height: 2),
              Text('#${widget.shipmentId.substring(0, 8)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.ink)),
            ]),
          ),
          const SizedBox(height: 14),

          Text(L10n.of(context)!.teamWillReview,
            style: tt.bodyMedium?.copyWith(color: AppTheme.muted, height: 1.5)),
          const SizedBox(height: 16),

          Text(L10n.of(context)!.describeProblem, style: tt.labelLarge),
          const SizedBox(height: 5),
          TextField(
            controller: _commentCtrl,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: L10n.of(context)!.problemHint,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.red, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
            child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
              : Text(L10n.of(context)!.submitReport),
          ),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () => context.pop(), child: Text(L10n.of(context)!.cancel)),
        ]),
      ),
    );
  }

  Future<void> _submit() async {
    if (_commentCtrl.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(apiClientProvider).createReport(widget.shipmentId, _commentCtrl.text);
      if (mounted) { context.pop(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.of(context)!.reportSubmitted))); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${L10n.of(context)!.error}: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
