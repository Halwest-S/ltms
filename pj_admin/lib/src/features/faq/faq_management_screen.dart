import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/api_provider.dart';
import '../../core/response_parsing.dart';
import '../../core/theme.dart';
import 'faq_editor_dialog.dart';

final adminFaqsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final response = await ref.read(apiClientProvider).getAdminFaqs();
  return extractMapList(response.data);
});

class FaqManagementScreen extends ConsumerWidget {
  const FaqManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final tt = Theme.of(context).textTheme;
    final isCompact = MediaQuery.sizeOf(context).width < 960;
    final faqsAsync = ref.watch(adminFaqsProvider);

    Future<void> openEditor([Map<String, dynamic>? faq]) async {
      final result = await FaqEditorDialog.show(context, faq: faq);
      if (result == true) {
        ref.invalidate(adminFaqsProvider);
      }
    }

    Future<void> deleteFaq(Map<String, dynamic> faq) async {
      await _deleteFaq(context, ref, faq);
    }

    return AdminShell(
      activeRoute: '/faq',
      title: l10n.faqManagement,
      actions: [
        IconButton(
          onPressed: () => ref.refresh(adminFaqsProvider),
          tooltip: l10n.refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      floatingActionButton: isCompact
          ? FloatingActionButton(
              onPressed: openEditor,
              child: const Icon(Icons.add_rounded),
            )
          : FloatingActionButton.extended(
              onPressed: openEditor,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addFaq),
            ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) ...[
              Text(l10n.faqManagement, style: tt.headlineLarge),
              const SizedBox(height: 4),
              Text(
                _screenText(
                  context,
                  ku: 'پرسیارە دووبارەکان زیاد بکە، دەستکاری بکە، یان بسڕەوە.',
                  en: 'Add, edit, or remove the FAQs published in the system.',
                ),
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 20),
            ] else ...[
              Text(l10n.faqManagement, style: tt.headlineSmall),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: faqsAsync.when(
                data: (faqs) {
                  if (faqs.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.faqCrudPlaceholder,
                        style: tt.titleMedium?.copyWith(color: AppTheme.muted),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: faqs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final faq = faqs[index];
                      final question = l10n.localeName == 'ku'
                          ? (faq['question_ku'] ?? faq['question_en'] ?? '')
                          : (faq['question_en'] ?? '');
                      final answer = l10n.localeName == 'ku'
                          ? (faq['answer_ku'] ?? faq['answer_en'] ?? '')
                          : (faq['answer_en'] ?? '');

                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: isCompact
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _FaqHeader(
                                    question: question,
                                    sortOrder: faq['sort_order'],
                                  ),
                                  const SizedBox(height: 12),
                                  _FaqBody(answer: answer, faq: faq),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      TextButton.icon(
                                        onPressed: () => openEditor(faq),
                                        icon: const Icon(
                                          Icons.edit_rounded,
                                          size: 18,
                                        ),
                                        label: Text(l10n.edit),
                                      ),
                                      TextButton.icon(
                                        onPressed: () => deleteFaq(faq),
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 18,
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppTheme.rose,
                                        ),
                                        label: Text(l10n.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: _FaqHeader(
                                          question: question,
                                          sortOrder: faq['sort_order'],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      OutlinedButton.icon(
                                        onPressed: () => openEditor(faq),
                                        icon: const Icon(
                                          Icons.edit_rounded,
                                          size: 18,
                                        ),
                                        label: Text(l10n.edit),
                                      ),
                                      const SizedBox(width: 8),
                                      OutlinedButton.icon(
                                        onPressed: () => deleteFaq(faq),
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 18,
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppTheme.rose,
                                        ),
                                        label: Text(l10n.delete),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _FaqBody(answer: answer, faq: faq),
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

  String _screenText(
    BuildContext context, {
    required String ku,
    required String en,
  }) {
    return L10n.of(context)!.localeName == 'ku' ? ku : en;
  }

  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final errors = map['errors'];
        if (errors is Map) {
          for (final value in errors.values) {
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
            if (value != null) {
              return value.toString();
            }
          }
        }
        final message = map['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
      }
      if (error.message != null && error.message!.trim().isNotEmpty) {
        return error.message!;
      }
    }
    return error.toString();
  }

  int? _parseId(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  Future<bool> _confirmDelete(BuildContext context, String title) async {
    final l10n = L10n.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.confirmAction),
        content: Text(
          _screenText(
            context,
            ku: 'دڵنیایت دەتەوێت "$title" بسڕیتەوە؟',
            en: 'Are you sure you want to delete "$title"?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.rose),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    return result == true;
  }

  Future<void> _deleteFaq(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> faq,
  ) async {
    final l10n = L10n.of(context)!;
    final faqId = _parseId(faq['id']);
    if (faqId == null) return;

    final title = l10n.localeName == 'ku'
        ? (faq['question_ku'] ?? faq['question_en'] ?? '')
        : (faq['question_en'] ?? '');

    final confirmed = await _confirmDelete(context, '$title');
    if (!confirmed || !context.mounted) return;

    try {
      await ref.read(apiClientProvider).deleteAdminFaq(faqId);
      ref.invalidate(adminFaqsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _screenText(context, ku: 'پرسیارەکە سڕایەوە', en: 'FAQ deleted'),
            ),
          ),
        );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: ${_extractErrorMessage(error)}'),
          ),
        );
    }
  }
}

class _FaqHeader extends StatelessWidget {
  const _FaqHeader({required this.question, required this.sortOrder});

  final String question;
  final dynamic sortOrder;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTheme.roseLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.quiz_rounded, color: AppTheme.rose),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.ink,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.blueLight,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '#${sortOrder ?? 0}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D4ED8),
            ),
          ),
        ),
      ],
    );
  }
}

class _FaqBody extends StatelessWidget {
  const _FaqBody({required this.answer, required this.faq});

  final String answer;
  final Map<String, dynamic> faq;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          answer,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.ink,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'EN: ${faq['question_en'] ?? ''}\nKU: ${faq['question_ku'] ?? ''}',
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.muted,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
