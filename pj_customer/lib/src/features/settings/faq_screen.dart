import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/api_provider.dart';
import '../../core/theme.dart';

final faqProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await ref.read(apiClientProvider).getFaqs();
  final body = response.data;
  final items = body is Map ? body['data'] : body;

  if (items is! Iterable) {
    throw FormatException(
      'Expected FAQ list but received ${items.runtimeType}',
    );
  }

  return [
    for (final item in items)
      if (item is Map) Map<String, dynamic>.from(item),
  ];
});

class FaqScreen extends ConsumerStatefulWidget {
  const FaqScreen({super.key});

  @override
  ConsumerState<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends ConsumerState<FaqScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final faqsAsync = ref.watch(faqProvider);

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: Text(l10n.helpFaq)),
      body: faqsAsync.when(
        data: (faqs) => _FaqList(
          faqs: faqs,
          searchCtrl: _searchCtrl,
          onSearchChanged: () => setState(() {}),
          onRefresh: () async {
            final _ = await ref.refresh(faqProvider.future);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _FaqError(
          message: '${l10n.error}: $error',
          onRetry: () => ref.invalidate(faqProvider),
        ),
      ),
    );
  }
}

class _FaqList extends StatelessWidget {
  const _FaqList({
    required this.faqs,
    required this.searchCtrl,
    required this.onSearchChanged,
    required this.onRefresh,
  });

  final List<Map<String, dynamic>> faqs;
  final TextEditingController searchCtrl;
  final VoidCallback onSearchChanged;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final query = searchCtrl.text.trim().toLowerCase();
    final filteredFaqs = faqs.where((faq) {
      if (query.isEmpty) return true;
      final question = _localizedValue(faq, 'question', languageCode);
      final answer = _localizedValue(faq, 'answer', languageCode);
      return '$question $answer'.toLowerCase().contains(query);
    }).toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          TextField(
            controller: searchCtrl,
            onChanged: (_) => onSearchChanged(),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: l10n.searchQuestions,
              filled: true,
              fillColor: AppTheme.card,
            ),
          ),
          const SizedBox(height: 14),
          if (filteredFaqs.isEmpty)
            _EmptyFaqCard(message: l10n.noData)
          else
            ...filteredFaqs.map((faq) {
              final question = _localizedValue(faq, 'question', languageCode);
              final answer = _localizedValue(faq, 'answer', languageCode);
              return _FaqTile(question: question, answer: answer);
            }),
          const SizedBox(height: 8),
          const _ContactSupportCard(),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 15),
            childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 14),
            iconColor: AppTheme.teal,
            collapsedIconColor: AppTheme.muted,
            title: Text(
              question,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
              ),
            ),
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  answer,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.muted,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactSupportCard extends StatelessWidget {
  const _ContactSupportCard();

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: AppTheme.tealLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.tealMid),
      ),
      child: Row(
        children: [
          const Icon(Icons.support_agent_rounded, color: AppTheme.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.stillNeedHelp,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.ink,
                  ),
                ),
                Text(
                  l10n.contactSupportLine,
                  style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFaqCard extends StatelessWidget {
  const _EmptyFaqCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppTheme.muted),
      ),
    );
  }
}

class _FaqError extends StatelessWidget {
  const _FaqError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.muted),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}

String _localizedValue(
  Map<String, dynamic> data,
  String field,
  String languageCode,
) {
  final primarySuffix = languageCode == 'ku' ? 'ku' : 'en';
  final fallbackSuffix = primarySuffix == 'ku' ? 'en' : 'ku';

  return _valueOrEmpty(data['${field}_$primarySuffix']) ??
      _valueOrEmpty(data['${field}_$fallbackSuffix']) ??
      _valueOrEmpty(data[field]) ??
      '';
}

String? _valueOrEmpty(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}
