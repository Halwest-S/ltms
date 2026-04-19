import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/api_provider.dart';

class FaqEditorDialog extends ConsumerStatefulWidget {
  const FaqEditorDialog({super.key, this.faq});

  final Map<String, dynamic>? faq;

  static Future<bool?> show(BuildContext context, {Map<String, dynamic>? faq}) {
    return showDialog<bool>(
      context: context,
      builder: (_) => FaqEditorDialog(faq: faq),
    );
  }

  @override
  ConsumerState<FaqEditorDialog> createState() => _FaqEditorDialogState();
}

class _FaqEditorDialogState extends ConsumerState<FaqEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _questionEnCtrl = TextEditingController();
  final _questionKuCtrl = TextEditingController();
  final _answerEnCtrl = TextEditingController();
  final _answerKuCtrl = TextEditingController();
  final _sortOrderCtrl = TextEditingController();

  bool _isSaving = false;

  bool get _isEditing => widget.faq != null;

  int? get _faqId {
    final value = widget.faq?['id'];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  @override
  void initState() {
    super.initState();
    final faq = widget.faq;
    if (faq != null) {
      _questionEnCtrl.text = '${faq['question_en'] ?? ''}';
      _questionKuCtrl.text = '${faq['question_ku'] ?? ''}';
      _answerEnCtrl.text = '${faq['answer_en'] ?? ''}';
      _answerKuCtrl.text = '${faq['answer_ku'] ?? ''}';
      final sortOrder = faq['sort_order'];
      if (sortOrder != null) {
        _sortOrderCtrl.text = '$sortOrder';
      }
    }
  }

  @override
  void dispose() {
    _questionEnCtrl.dispose();
    _questionKuCtrl.dispose();
    _answerEnCtrl.dispose();
    _answerKuCtrl.dispose();
    _sortOrderCtrl.dispose();
    super.dispose();
  }

  int? _parseInt(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    return int.tryParse(normalized);
  }

  String _screenText({required String ku, required String en}) {
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = L10n.of(context)!;
    final faqId = _faqId;
    final sortOrder = _parseInt(_sortOrderCtrl.text);
    if (_isEditing && faqId == null) return;

    setState(() => _isSaving = true);

    try {
      final payload = <String, dynamic>{
        'question_en': _questionEnCtrl.text.trim(),
        'question_ku': _questionKuCtrl.text.trim(),
        'answer_en': _answerEnCtrl.text.trim(),
        'answer_ku': _answerKuCtrl.text.trim(),
      };
      if (sortOrder != null) {
        payload['sort_order'] = sortOrder;
      }

      if (_isEditing) {
        await ref.read(apiClientProvider).updateAdminFaq(faqId!, payload);
      } else {
        await ref.read(apiClientProvider).createAdminFaq(payload);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.success}: ${_isEditing ? l10n.editFaq : l10n.addFaq}',
            ),
          ),
        );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: ${_extractErrorMessage(error)}'),
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

    return AlertDialog(
      title: Text(_isEditing ? l10n.editFaq : l10n.addFaq),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _questionEnCtrl,
                  decoration: InputDecoration(
                    labelText: '${l10n.english} (${l10n.question})',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.required
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _questionKuCtrl,
                  decoration: InputDecoration(
                    labelText: '${l10n.kurdish} (${l10n.question})',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.required
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _answerEnCtrl,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: '${l10n.english} (${l10n.answer})',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.required
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _answerKuCtrl,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: '${l10n.kurdish} (${l10n.answer})',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.required
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _sortOrderCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    labelText: l10n.sortOrder,
                    helperText: _screenText(
                      ku: 'بەتاڵی بهێڵە بۆ ئەوەی خۆکارانە دوا ڕیزبەندی بدرێت',
                      en: 'Leave blank to place it after the current FAQs',
                    ),
                  ),
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) return null;
                    if (_parseInt(trimmed) == null) {
                      return _screenText(
                        ku: 'تکایە ژمارەیەکی دروست بنووسە',
                        en: 'Please enter a valid number',
                      );
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEditing ? l10n.update : l10n.create),
        ),
      ],
    );
  }
}
