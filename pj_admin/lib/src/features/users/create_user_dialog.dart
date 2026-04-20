import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:uuid/uuid.dart';

import '../../core/api_provider.dart';
import '../../core/theme.dart';

class CreateUserDialog extends ConsumerStatefulWidget {
  const CreateUserDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const CreateUserDialog(),
    );
  }

  @override
  ConsumerState<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends ConsumerState<CreateUserDialog> {
  static const List<String> _roles = ['staff', 'driver'];

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  String? _selectedRole;
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _generatePassword() {
    const uuid = Uuid();
    _passwordCtrl.text = uuid.v4().substring(0, 12);
    if (mounted) {
      setState(() {});
    }
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

  Future<void> _copyText(String value, String message) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedRole == null) return;

    setState(() => _isLoading = true);

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = L10n.of(context)!;

    try {
      await ref.read(apiClientProvider).createUserByAdmin({
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        if (_phoneCtrl.text.trim().isNotEmpty)
          'phone_number': _phoneCtrl.text.trim(),
        'password': _passwordCtrl.text,
        'role': _selectedRole,
      });

      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.userCreated)));
      navigator.pop(true);
    } catch (error) {
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: ${_extractErrorMessage(error)}'),
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _roleLabel(L10n l10n, String role) => switch (role) {
    'driver' => l10n.driver,
    'staff' => l10n.staff,
    _ => role,
  };

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = L10n.of(context)!;

    return AlertDialog(
      title: Text(l10n.createNewUser),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: l10n.nameLabel),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.required
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: l10n.email),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) return l10n.required;
                  final emailRegex = RegExp(
                    r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$',
                  );
                  if (!emailRegex.hasMatch(trimmed)) return l10n.invalidEmail;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: _screenText(
                    context,
                    ku: 'ژمارەی تەلەفۆن',
                    en: 'Phone Number',
                  ),
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (_selectedRole == 'driver' && trimmed.isEmpty) {
                    return l10n.required;
                  }
                  if (trimmed.isEmpty) return null;

                  final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
                  if (digits.length < 8 || digits.length > 15) {
                    return _screenText(
                      context,
                      ku: 'ژمارەی تەلەفۆن بە دروستی بنووسە',
                      en: 'Enter a valid phone number',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  hintText: l10n.passwordPlaceholder,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return l10n.required;
                  if (value.length < 6) return l10n.passwordTooShort;
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TextButton.icon(
                      onPressed: _generatePassword,
                      icon: const Icon(Icons.auto_fix_high_rounded),
                      label: Text(l10n.generatePassword),
                    ),
                    if (_passwordCtrl.text.isNotEmpty)
                      TextButton.icon(
                        onPressed: () => _copyText(
                          _passwordCtrl.text,
                          _screenText(
                            context,
                            ku: 'وشەی نهێنی کۆپی کرا',
                            en: 'Password copied',
                          ),
                        ),
                        icon: const Icon(Icons.copy_rounded),
                        label: Text(l10n.copyPassword),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                hint: Text(l10n.selectRole),
                items: _roles
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(_roleLabel(l10n, role)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedRole = value),
                validator: (value) => value == null ? l10n.required : null,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  _screenText(
                    context,
                    ku: 'تەنها سوپەر ئەدمین دەتوانێت هەژماری ستاف و شۆفێر دروست بکات.',
                    en: 'Only the super admin can create staff and driver accounts.',
                  ),
                  style: textTheme.bodySmall?.copyWith(color: AppTheme.muted),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.create),
        ),
      ],
    );
  }
}
