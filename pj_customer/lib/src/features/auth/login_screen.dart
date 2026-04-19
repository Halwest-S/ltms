import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:dio/dio.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;

  // ── Animation Controllers ─────────────────────────────────────────────────
  late final AnimationController _pulseCtrl;
  late final AnimationController _entranceCtrl;
  late final AnimationController _buttonCtrl;

  // ── Pulse glow ────────────────────────────────────────────────────────────
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  // ── Back button ───────────────────────────────────────────────────────────
  late final Animation<Offset> _backSlide;
  late final Animation<double> _backOpacity;

  // ── Logo ─────────────────────────────────────────────────────────────────
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  // ── Title ─────────────────────────────────────────────────────────────────
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleOpacity;

  // ── Form fields (email=0, password=1, forgot=2) ───────────────────────────
  late final List<Animation<Offset>> _fieldSlides;
  late final List<Animation<double>> _fieldOpacities;

  // ── Sign-in button ─────────────────────────────────────────────────────────
  late final Animation<double> _btnScale;
  late final Animation<double> _btnOpacity;

  // ── Register link ─────────────────────────────────────────────────────────
  late final Animation<double> _linkOpacity;

  @override
  void initState() {
    super.initState();

    // Breathing glow — repeating
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    // Main entrance (1.1 s)
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    // Button press scale feedback
    _buttonCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );

    // ── Pulse ──
    _pulseScale = Tween<double>(
      begin: 0.80,
      end: 1.20,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _pulseOpacity = Tween<double>(
      begin: 0.40,
      end: 0.90,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // ── Back button slides in from left ──
    _backSlide = Tween<Offset>(begin: const Offset(-1.0, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.00, 0.35, curve: Curves.easeOutCubic),
          ),
        );
    _backOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.00, 0.30, curve: Curves.easeOut),
      ),
    );

    // ── Logo ──
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.05, 0.50, curve: Curves.elasticOut),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.05, 0.30, curve: Curves.easeOut),
      ),
    );

    // ── Title ──
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.20, 0.55, curve: Curves.easeOutCubic),
          ),
        );
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.20, 0.50, curve: Curves.easeOut),
      ),
    );

    // ── Form fields — staggered (email, password, forgot) ──
    _fieldSlides = List.generate(3, (i) {
      final start = 0.35 + i * 0.10;
      final end = (start + 0.30).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.55),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });
    _fieldOpacities = List.generate(3, (i) {
      final start = 0.35 + i * 0.10;
      final end = (start + 0.25).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    // ── Button ──
    _btnScale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeInOut));
    _btnOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.65, 0.90, curve: Curves.easeOut),
      ),
    );

    // ── Register link ──
    _linkOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.75, 1.00, curve: Curves.easeOut),
      ),
    );

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    _buttonCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _animated(int fieldIndex, Widget child) {
    return AnimatedBuilder(
      animation: _entranceCtrl,
      builder: (_, _) => SlideTransition(
        position: _fieldSlides[fieldIndex],
        child: FadeTransition(
          opacity: _fieldOpacities[fieldIndex],
          child: child,
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
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
          child: Stack(
            children: [
              // ── Pulsing background glow ──────────────────────────────────
              Positioned(
                top: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _pulseCtrl,
                    builder: (_, _) => Transform.scale(
                      scale: _pulseScale.value,
                      child: Opacity(
                        opacity: _pulseOpacity.value,
                        child: Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.teal.withAlpha(45),
                                AppTheme.teal.withAlpha(12),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Secondary accent glow (bottom-left) ──────────────────────
              Positioned(
                bottom: 60,
                left: -50,
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, _) => Opacity(
                    opacity: (1.0 - (_pulseOpacity.value - 0.4)) * 0.45,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF3B82F6).withAlpha(35),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Scrollable form content ──────────────────────────────────
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // ── Back button ──
                      AnimatedBuilder(
                        animation: _entranceCtrl,
                        builder: (_, child) => SlideTransition(
                          position: _backSlide,
                          child: FadeTransition(
                            opacity: _backOpacity,
                            child: child,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _CircleIconButton(
                            icon: Icons.arrow_back_rounded,
                            onTap: () => context.go('/'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 44),

                      // ── Logo ──
                      AnimatedBuilder(
                        animation: _entranceCtrl,
                        builder: (_, child) => Transform.scale(
                          scale: _logoScale.value.clamp(0.0, 1.0),
                          child: Opacity(
                            opacity: _logoOpacity.value.clamp(0.0, 1.0),
                            child: child,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.teal.withAlpha(80),
                                width: 1.5,
                              ),
                              gradient: RadialGradient(
                                colors: [
                                  AppTheme.teal.withAlpha(50),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '\u{1F30D}',
                                style: TextStyle(fontSize: 36),
                              ), // Earth 🌍
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Title ──
                      AnimatedBuilder(
                        animation: _entranceCtrl,
                        builder: (_, child) => SlideTransition(
                          position: _titleSlide,
                          child: FadeTransition(
                            opacity: _titleOpacity,
                            child: child,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: tt.displayLarge?.copyWith(
                                  color: Colors.white,
                                  height: 1.15,
                                ),
                                children: [
                                  TextSpan(
                                    text: L10n.of(context)!.welcomeBackTitle,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              L10n.of(context)!.signInToManage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withAlpha(110),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // ── Email field ──
                      // ── Email field ──
                      _animated(
                        0,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              L10n.of(context)!.email.toUpperCase(),
                              style: tt.labelLarge?.copyWith(
                                color: Colors.white.withAlpha(140),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _DarkTextField(
                              controller: _emailCtrl,
                              hint: L10n.of(context)!.emailPlaceholder,
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return L10n.of(context)!.enterEmail;
                                }
                                final emailRegex = RegExp(
                                  r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$',
                                );
                                if (!emailRegex.hasMatch(val)) {
                                  return L10n.of(context)!.enterValidEmail;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Password field ──
                      _animated(
                        1,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              L10n.of(context)!.password.toUpperCase(),
                              style: tt.labelLarge?.copyWith(
                                color: Colors.white.withAlpha(140),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _DarkTextField(
                              controller: _passCtrl,
                              hint: '••••••••',
                              icon: Icons.lock_outline_rounded,
                              obscure: _obscure,
                              onToggleObscure: () =>
                                  setState(() => _obscure = !_obscure),
                              validator: (val) => (val == null || val.isEmpty)
                                  ? L10n.of(context)!.enterPassword
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Forgot password ──
                      _animated(
                        2,
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            L10n.of(context)!.forgotPassword,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.teal.withAlpha(220),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // ── Sign In button ──
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _entranceCtrl,
                          _buttonCtrl,
                        ]),
                        builder: (_, child) => FadeTransition(
                          opacity: _btnOpacity,
                          child: Transform.scale(
                            scale: _btnScale.value,
                            child: child,
                          ),
                        ),
                        child: GestureDetector(
                          onTapDown: (_) => _buttonCtrl.forward(),
                          onTapUp: (_) {
                            _buttonCtrl.reverse();
                            if (!_isLoading) _handleLogin();
                          },
                          onTapCancel: () => _buttonCtrl.reverse(),
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: AppTheme.teal,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.teal.withAlpha(70),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
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
                                      L10n.of(context)!.signIn,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Register link ──
                      FadeTransition(
                        opacity: _linkOpacity,
                        child: Center(
                          child: GestureDetector(
                            onTap: () => context.push('/register'),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withAlpha(100),
                                ),
                                children: [
                                  TextSpan(
                                    text: L10n.of(context)!.dontHaveAccount,
                                  ),
                                  TextSpan(
                                    text: L10n.of(context)!.createOne,
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
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .login(_emailCtrl.text.trim(), _passCtrl.text);
    } on DioException catch (e) {
      if (!mounted) return;
      final l10n = L10n.of(context)!;
      var msg = _extractDioMessage(e, l10n.loginFailed);
      if (e.response?.statusCode == 403) {
        msg = _extractDioMessage(e, l10n.accountDisabled);
      } else if (e.response?.statusCode == 401 ||
          e.response?.statusCode == 422) {
        msg = _extractDioMessage(e, l10n.incorrectCredentials);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppTheme.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    } catch (e) {
      if (!mounted) return;
      final l10n = L10n.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.loginFailed}: $e'),
          backgroundColor: AppTheme.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }

    if (!mounted) return;
    context.go('/');
  }
}

// ── Reusable dark-themed text field ──────────────────────────────────────────

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
        hintStyle: TextStyle(color: Colors.white.withAlpha(70)),
        filled: true,
        fillColor: Colors.white.withAlpha(12),
        prefixIcon: Icon(icon, size: 18, color: Colors.white.withAlpha(100)),
        suffixIcon: onToggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: Colors.white.withAlpha(100),
                ),
                onPressed: onToggleObscure,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withAlpha(25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.teal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.red, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFCA5A5)),
      ),
      validator: validator,
    );
  }
}

// ── Small circle icon button ──────────────────────────────────────────────────

class _CircleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withAlpha(30)),
          ),
          child: Icon(widget.icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}
