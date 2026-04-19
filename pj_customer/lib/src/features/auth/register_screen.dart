import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/theme.dart';
import 'auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String _extractDioMessage(DioException error, String fallback) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.error is SocketException) {
      return fallback;
    }

    final data = error.response?.data;
    if (data is Map) {
      final errors = data['errors'];
      if (errors is Map) {
        for (final value in errors.values) {
          if (value is List && value.isNotEmpty && value.first is String) {
            return value.first as String;
          }
          if (value is String && value.isNotEmpty) {
            return value;
          }
        }
      }

      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    final message = error.message;
    if (message != null && message.isNotEmpty) {
      return message;
    }

    return fallback;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) {
      return 'Enter phone number';
    }

    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 8 || digits.length > 15) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).register(
            _nameCtrl.text.trim(),
            _emailCtrl.text.trim(),
            _phoneCtrl.text.trim(),
            _passCtrl.text,
            _confirmCtrl.text,
          );
    } on DioException catch (e) {
      if (!mounted) return;
      final msg = _extractDioMessage(e, L10n.of(context)!.registrationFailed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppTheme.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${L10n.of(context)!.registrationFailed}: $e'),
          backgroundColor: AppTheme.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }

    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1B14), Color(0xFF0A1628)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(12),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withAlpha(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 30,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton.icon(
                            onPressed: () => context.go('/login'),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: Text(l10n.backButton),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white.withAlpha(180),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 40),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.createAccount,
                          style: tt.displaySmall?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.createAccountSubtitle,
                          style: tt.bodyMedium?.copyWith(
                            color: Colors.white.withAlpha(150),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _DarkLabel(text: l10n.fullNameLabel, tt: tt),
                        const SizedBox(height: 6),
                        _DarkTextField(
                          controller: _nameCtrl,
                          hint: l10n.yourFullNameHint,
                          icon: Icons.person_outline_rounded,
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? l10n.enterName
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _DarkLabel(text: l10n.emailAddressLabel, tt: tt),
                        const SizedBox(height: 6),
                        _DarkTextField(
                          controller: _emailCtrl,
                          hint: l10n.emailPlaceholder,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return l10n.enterEmail;
                            }
                            final emailRegex = RegExp(
                              r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$',
                            );
                            if (!emailRegex.hasMatch(val.trim())) {
                              return l10n.enterValidEmail;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _DarkLabel(text: 'PHONE NUMBER', tt: tt),
                        const SizedBox(height: 6),
                        _DarkTextField(
                          controller: _phoneCtrl,
                          hint: 'e.g. +9647501234567',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: _validatePhone,
                        ),
                        const SizedBox(height: 16),
                        _DarkLabel(text: l10n.password.toUpperCase(), tt: tt),
                        const SizedBox(height: 6),
                        _DarkTextField(
                          controller: _passCtrl,
                          hint: l10n.passwordMinHint,
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscurePass,
                          onToggleObscure: () {
                            setState(() => _obscurePass = !_obscurePass);
                          },
                          validator: (val) => (val == null || val.length < 8)
                              ? l10n.passwordMin8
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _DarkLabel(text: l10n.confirmPasswordLabel, tt: tt),
                        const SizedBox(height: 6),
                        _DarkTextField(
                          controller: _confirmCtrl,
                          hint: l10n.repeatPasswordHint,
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscureConfirm,
                          onToggleObscure: () {
                            setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            );
                          },
                          validator: (val) => val != _passCtrl.text
                              ? l10n.passwordMismatch
                              : null,
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    l10n.createAccount,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.termsAgree,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withAlpha(90),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: () => context.go('/login'),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withAlpha(130),
                                ),
                                children: [
                                  TextSpan(text: l10n.alreadyMember),
                                  TextSpan(
                                    text: l10n.signIn,
                                    style: const TextStyle(
                                      color: Color(0xFF6EE7B7),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DarkLabel extends StatelessWidget {
  final String text;
  final TextTheme tt;

  const _DarkLabel({required this.text, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: tt.labelLarge?.copyWith(color: Colors.white.withAlpha(150)),
    );
  }
}

class _DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final String? Function(String?)? validator;

  const _DarkTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.onToggleObscure,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withAlpha(80)),
        filled: true,
        fillColor: Colors.white.withAlpha(10),
        prefixIcon: Icon(icon, size: 18, color: Colors.white.withAlpha(120)),
        suffixIcon: onToggleObscure == null
            ? null
            : IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: Colors.white.withAlpha(120),
                ),
              ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withAlpha(18)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppTheme.teal, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppTheme.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppTheme.red, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFCA5A5)),
      ),
      validator: validator,
    );
  }
}
