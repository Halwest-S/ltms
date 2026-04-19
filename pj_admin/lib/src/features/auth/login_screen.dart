import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';

import '../../core/theme.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keyCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _keyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final locale = ref.watch(localeProvider);
    final isKurdish = locale.languageCode == 'ku';

    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 980;

              if (isCompact) {
                return Column(
                  children: [
                    SizedBox(
                      height: 320,
                      width: double.infinity,
                      child: _brandingPanel(context, tt, true),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 440),
                            child: _formPanel(context, tt, true, isKurdish),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 5, child: _brandingPanel(context, tt, false)),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 380),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          child: _formPanel(context, tt, false, isKurdish),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 24,
            right: 24,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => ref.read(localeProvider.notifier).toggle(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(240),
                    border: Border.all(color: AppTheme.rose.withAlpha(80)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.language_rounded,
                        size: 18,
                        color: AppTheme.rose,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isKurdish ? 'EN' : 'KU',
                        style: tt.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandingPanel(BuildContext context, TextTheme tt, bool isCompact) {
    final isKurdish = ref.watch(localeProvider).languageCode == 'ku';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.ink, Color(0xFF1E2038)],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: isCompact ? 240 : 380,
              height: isCompact ? 240 : 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.rose.withAlpha(45),
                    AppTheme.rose.withAlpha(12),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isCompact ? 20 : 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: isCompact ? 78 : 90,
                    height: isCompact ? 78 : 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.rose, Color(0xFFFB7185)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.rose.withAlpha(80),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: (isCompact ? tt.headlineMedium : tt.displayLarge)
                          ?.copyWith(color: Colors.white, height: 1.15),
                      children: [
                        TextSpan(text: '${L10n.of(context)!.appTitle} '),
                        TextSpan(
                          text: L10n.of(context)!.adminRole,
                          style: const TextStyle(color: Color(0xFFFDA4AF)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isKurdish
                        ? 'داشبۆردی ئەدمینی گەورە'
                        : 'Super Admin Dashboard',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withAlpha(100),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        [
                          (
                            Icons.inventory_2_outlined,
                            L10n.of(context)!.shipmentMonitor,
                          ),
                          (
                            Icons.people_alt_outlined,
                            L10n.of(context)!.userManagement,
                          ),
                          (
                            Icons.bar_chart_rounded,
                            L10n.of(context)!.reportsLabel,
                          ),
                        ].map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(10),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.white.withAlpha(18),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  item.$1,
                                  size: 16,
                                  color: Colors.white.withAlpha(180),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.$2,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withAlpha(160),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formPanel(
    BuildContext context,
    TextTheme tt,
    bool isCompact,
    bool isKurdish,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            L10n.of(context)!.welcomeBack,
            style: isCompact ? tt.headlineMedium : tt.displayMedium,
          ),
          const SizedBox(height: 6),
          Text(
            L10n.of(context)!.signInToManage,
            style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
          ),
          SizedBox(height: isCompact ? 24 : 36),
          Text(L10n.of(context)!.email, style: tt.labelLarge),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailCtrl,
            decoration: InputDecoration(
              hintText: L10n.of(context)!.emailPlaceholder,
              prefixIcon: const Icon(
                Icons.email_outlined,
                size: 18,
                color: AppTheme.muted,
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return L10n.of(context)!.required;
              }
              if (!val.contains('@')) {
                return L10n.of(context)!.invalidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text(L10n.of(context)!.password, style: tt.labelLarge),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordCtrl,
            obscureText: true,
            decoration: InputDecoration(
              hintText: L10n.of(context)!.passwordPlaceholder,
              prefixIcon: const Icon(
                Icons.lock_outline,
                size: 18,
                color: AppTheme.muted,
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return L10n.of(context)!.required;
              }
              if (val.length < 6) {
                return L10n.of(context)!.passwordTooShort;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text(isKurdish ? 'کلیلی ئەدمین' : 'Admin Key', style: tt.labelLarge),
          const SizedBox(height: 6),
          TextFormField(
            controller: _keyCtrl,
            decoration: InputDecoration(
              hintText: isKurdish
                  ? 'کلیلەکەت لێرە بنووسە'
                  : 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
              prefixIcon: const Icon(
                Icons.key_rounded,
                size: 18,
                color: AppTheme.muted,
              ),
            ),
            validator: (val) {
              if (val == null || val.length != 36) {
                return isKurdish
                    ? 'کلیلەکە دەبێت تەواو ٣٦ پیت بێت'
                    : 'Key must be exactly 36 characters';
              }
              if (!RegExp(
                r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
              ).hasMatch(val)) {
                return isKurdish
                    ? 'فۆرماتی UUID هەڵەیە'
                    : 'Invalid UUID format';
              }
              return null;
            },
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: _loading ? null : _handleLogin,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.rose,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.rose.withAlpha(70),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Center(
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        L10n.of(context)!.signIn,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .login(_emailCtrl.text, _passwordCtrl.text, _keyCtrl.text);
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${L10n.of(context)!.error}: $e'),
            backgroundColor: AppTheme.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
