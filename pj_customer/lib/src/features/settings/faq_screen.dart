import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_provider.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';

final faqProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await ref.read(apiClientProvider).getAdminFaqs();
  return List<Map<String, dynamic>>.from(response.data);
});

class FaqScreen extends ConsumerWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqsAsync = ref.watch(faqProvider);

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: Text(L10n.of(context)!.helpFaq)),
      body: faqsAsync.when(
        data: (faqs) => ListView(
          padding: const EdgeInsets.all(18),
          children: [
            // Search
            TextField(decoration: InputDecoration(hintText: '\u{1F50D}  ${L10n.of(context)!.searchQuestions}', filled: true, fillColor: AppTheme.card)), // Search 🔍
            const SizedBox(height: 14),

            ...faqs.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(f['question_en'] ?? f['question'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.ink))),
                    Text('\u{203A}', style: TextStyle(color: AppTheme.muted, fontSize: 16)), // Angle ›
                  ]),
                  if (f['answer_en'] != null || f['answer'] != null) ...[
                    const SizedBox(height: 8),
                    Text(f['answer_en'] ?? f['answer'] ?? '', style: const TextStyle(fontSize: 12, color: AppTheme.muted, height: 1.5)),
                  ],
                ]),
              ),
            )),

            // Contact support
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              decoration: BoxDecoration(color: AppTheme.tealLight, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.tealMid)),
              child: Row(children: [
                const Text('\u{1F4AC}', style: TextStyle(fontSize: 24)), // Message 💬
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(L10n.of(context)!.stillNeedHelp, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.ink)),
                  Text(L10n.of(context)!.contactSupportLine, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                ])),
                Text('\u{203A}', style: TextStyle(color: AppTheme.teal, fontSize: 20)), // Angle ›
              ]),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${L10n.of(context)!.error}: $e')),
      ),
    );
  }
}
