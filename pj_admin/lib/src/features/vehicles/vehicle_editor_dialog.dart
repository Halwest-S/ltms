import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/api_provider.dart';

class VehicleEditorDialog extends ConsumerStatefulWidget {
  const VehicleEditorDialog({super.key, this.vehicle});

  final Map<String, dynamic>? vehicle;

  static Future<bool?> show(
    BuildContext context, {
    Map<String, dynamic>? vehicle,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => VehicleEditorDialog(vehicle: vehicle),
    );
  }

  @override
  ConsumerState<VehicleEditorDialog> createState() => _VehicleEditorDialogState();
}

class _VehicleEditorDialogState extends ConsumerState<VehicleEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameEnCtrl = TextEditingController();
  final _nameKuCtrl = TextEditingController();
  final _multiplierCtrl = TextEditingController();
  final _deliveryDaysCtrl = TextEditingController();

  bool _isSaving = false;

  bool get _isEditing => widget.vehicle != null;

  int? get _vehicleId {
    final value = widget.vehicle?['id'];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  @override
  void initState() {
    super.initState();
    final vehicle = widget.vehicle;
    if (vehicle != null) {
      _nameEnCtrl.text = '${vehicle['name_en'] ?? ''}';
      _nameKuCtrl.text = '${vehicle['name_ku'] ?? ''}';
      _multiplierCtrl.text = _formatNumber(vehicle['multiplier']);
      _deliveryDaysCtrl.text = '${vehicle['delivery_days_offset'] ?? ''}';
    }
  }

  @override
  void dispose() {
    _nameEnCtrl.dispose();
    _nameKuCtrl.dispose();
    _multiplierCtrl.dispose();
    _deliveryDaysCtrl.dispose();
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

  int? _parseInt(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    return int.tryParse(normalized);
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
    final multiplier = _parseDecimal(_multiplierCtrl.text);
    final deliveryDaysOffset = _parseInt(_deliveryDaysCtrl.text);
    final vehicleId = _vehicleId;
    if (multiplier == null || deliveryDaysOffset == null) return;
    if (_isEditing && vehicleId == null) return;

    setState(() => _isSaving = true);

    try {
      final payload = {
        'name_en': _nameEnCtrl.text.trim(),
        'name_ku': _nameKuCtrl.text.trim(),
        'multiplier': multiplier,
        'delivery_days_offset': deliveryDaysOffset,
      };

      if (_isEditing) {
        await ref.read(apiClientProvider).updateAdminVehicle(vehicleId!, payload);
      } else {
        await ref.read(apiClientProvider).createAdminVehicle(payload);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.success}: ${_isEditing ? l10n.editVehicle : l10n.addVehicle}',
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
      title: Text(_isEditing ? l10n.editVehicle : l10n.addVehicle),
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
                  controller: _multiplierCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(labelText: l10n.multiplier),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _deliveryDaysCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[-0-9]')),
                  ],
                  decoration: InputDecoration(
                    labelText: l10n.deliveryDaysOffset,
                    suffixText: l10n.days,
                  ),
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) return l10n.required;
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
