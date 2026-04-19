import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/api_provider.dart';

class CategoryEditorDialog extends ConsumerStatefulWidget {
  const CategoryEditorDialog({super.key, this.category});

  final Map<String, dynamic>? category;

  static Future<bool?> show(
    BuildContext context, {
    Map<String, dynamic>? category,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => CategoryEditorDialog(category: category),
    );
  }

  @override
  ConsumerState<CategoryEditorDialog> createState() =>
      _CategoryEditorDialogState();
}

class _CategoryEditorDialogState extends ConsumerState<CategoryEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameEnCtrl = TextEditingController();
  final _nameKuCtrl = TextEditingController();
  final _surchargeCtrl = TextEditingController();

  bool _isSaving = false;

  bool get _isEditing => widget.category != null;

  int? get _categoryId {
    final value = widget.category?['id'];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    if (category != null) {
      _nameEnCtrl.text = '${category['name_en'] ?? ''}';
      _nameKuCtrl.text = '${category['name_ku'] ?? ''}';
      _surchargeCtrl.text = _formatNumber(category['surcharge']);
    }
  }

  @override
  void dispose() {
    _nameEnCtrl.dispose();
    _nameKuCtrl.dispose();
    _surchargeCtrl.dispose();
    super.dispose();
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '';
    final asNumber = value is num
        ? value.toDouble()
        : double.tryParse(value.toString());
    if (asNumber == null) return '$value';
    final asText = asNumber.toString();
    return asText.endsWith('.0')
        ? asText.substring(0, asText.length - 2)
        : asText;
  }

  double? _parseDecimal(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  String _screenText({
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = L10n.of(context)!;
    final surcharge = _parseDecimal(_surchargeCtrl.text);
    final categoryId = _categoryId;
    if (surcharge == null) return;
    if (_isEditing && categoryId == null) return;

    setState(() => _isSaving = true);

    try {
      final payload = {
        'name_en': _nameEnCtrl.text.trim(),
        'name_ku': _nameKuCtrl.text.trim(),
        'surcharge': surcharge,
      };

      if (_isEditing) {
        await ref.read(apiClientProvider).updateAdminCategory(
              categoryId!,
              payload,
            );
      } else {
        await ref.read(apiClientProvider).createAdminCategory(payload);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.success}: ${_isEditing ? l10n.editCategory : l10n.addCategory}',
            ),
          ),
        );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${_extractErrorMessage(error)}')),
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
      title: Text(_isEditing ? l10n.editCategory : l10n.addCategory),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameEnCtrl,
                  decoration: InputDecoration(
                    labelText: '${l10n.english} (${l10n.nameLabel})',
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? l10n.required : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameKuCtrl,
                  decoration: InputDecoration(
                    labelText: '${l10n.kurdish} (${l10n.nameLabel})',
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? l10n.required : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _surchargeCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    labelText: l10n.surcharge,
                    suffixText: 'USD',
                  ),
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) return l10n.required;
                    if (_parseDecimal(trimmed) == null) {
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
