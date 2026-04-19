import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/theme.dart';
import 'auth_provider.dart';

class StaffLoginScreen extends ConsumerStatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  ConsumerState<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends ConsumerState<StaffLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 900;

          if (isCompact) {
            return Column(
              children: [
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: _brandingPanel(context, tt, true),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: _formPanel(context, tt, true),
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
                      padding: const EdgeInsets.all(32),
                      child: _formPanel(context, tt, false),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _brandingPanel(BuildContext context, TextTheme tt, bool isCompact) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.ink, Color(0xFF1E2038)],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 32,
        vertical: isCompact ? 24 : 32,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('\u{1F4CB}', style: TextStyle(fontSize: isCompact ? 44 : 52)),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: (isCompact ? tt.headlineMedium : tt.displayLarge)
                    ?.copyWith(color: Colors.white),
                children: [
                  TextSpan(text: '${L10n.of(context)!.appTitle} '),
                  TextSpan(
                    text: L10n.of(context)!.staff,
                    style: const TextStyle(color: Color(0xFFA5B4FC)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              L10n.of(context)!.logisticsPortal,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isCompact ? 13 : 14,
                color: Colors.white.withAlpha(100),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formPanel(BuildContext context, TextTheme tt, bool isCompact) {
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
          const SizedBox(height: 4),
          Text(
            L10n.of(context)!.signInToStaffPortal,
            style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
          ),
          SizedBox(height: isCompact ? 24 : 32),
          Text(L10n.of(context)!.email.toUpperCase(), style: tt.labelLarge),
          const SizedBox(height: 5),
          TextFormField(
            controller: _emailCtrl,
            decoration: InputDecoration(hintText: L10n.of(context)!.staffHint),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return L10n.of(context)!.enterEmail;
              }
              final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$');
              if (!emailRegex.hasMatch(val)) {
                return L10n.of(context)!.enterValidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          Text(L10n.of(context)!.password.toUpperCase(), style: tt.labelLarge),
          const SizedBox(height: 5),
          TextFormField(
            controller: _passCtrl,
            obscureText: true,
            decoration: const InputDecoration(hintText: '••••••••'),
            validator: (val) => (val == null || val.isEmpty)
                ? L10n.of(context)!.enterPassword
                : null,
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _loading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.indigo,
              minimumSize: const Size(double.infinity, 52),
            ),
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(L10n.of(context)!.signIn),
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
          .login(_emailCtrl.text, _passCtrl.text);
      if (!mounted) return;
      context.go('/');
    } on DioException catch (e) {
      if (!mounted) return;
      final l10n = L10n.of(context)!;
      String msg = l10n.loginFailed;
      if (e.response?.statusCode == 403) {
        msg = e.response?.data['message'] ?? l10n.accountDisabled;
      } else if (e.response?.statusCode == 401 ||
          e.response?.statusCode == 422) {
        msg = e.response?.data['message'] ?? l10n.incorrectCredentials;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      final l10n = L10n.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.loginFailed}: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
