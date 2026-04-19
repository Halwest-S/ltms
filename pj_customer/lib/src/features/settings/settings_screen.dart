import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final tt = Theme.of(context).textTheme;
    final l10n = L10n.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.account)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
              child: Row(children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppTheme.teal, Color(0xFF059669)]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(child: Text((user?.name ?? 'U')[0].toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white))),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user?.name ?? l10n.customer, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.ink)),
                  Text(user?.email ?? '', style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                ])),
                Text('✏️', style: TextStyle(fontSize: 18, color: AppTheme.muted)),
              ]),
            ),
            const SizedBox(height: 16),

            // Preferences
            Text(l10n.preferences, style: tt.labelLarge?.copyWith(color: AppTheme.ink, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
              child: Column(children: [
                _toggleRow(l10n.pushNotifications, l10n.receiveAlerts, true),
                Divider(color: AppTheme.border, height: 1),
                _LangToggleRow(),
              ]),
            ),
            const SizedBox(height: 16),

            // Support
            Text(l10n.support, style: tt.labelLarge?.copyWith(color: AppTheme.ink, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
              child: Column(children: [
                _linkRow('❓', l10n.helpFaqLink, () => context.push('/faq')),
                Divider(color: AppTheme.border, height: 1, indent: 16),
                _linkRow('📞', l10n.contactSupport, () {}),
              ]),
            ),
            const SizedBox(height: 16),

            // Logout
            OutlinedButton(
              onPressed: () { ref.read(authProvider.notifier).logout(); context.go('/login'); },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.red,
                side: const BorderSide(color: Color(0xFFFCA5A5)),
                backgroundColor: AppTheme.redLight,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(l10n.signOut),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleRow(String title, String sub, bool on) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.ink)),
          Text(sub, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
        ])),
        Container(
          width: 44, height: 26,
          decoration: BoxDecoration(color: on ? AppTheme.teal : AppTheme.border, borderRadius: BorderRadius.circular(13)),
          child: AnimatedAlign(alignment: on ? Alignment.centerRight : Alignment.centerLeft, duration: const Duration(milliseconds: 200), child: Container(
            width: 20, height: 20, margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 4)]),
          )),
        ),
      ]),
    );
  }

  Widget _linkRow(String emoji, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.ink))),
          Text('›', style: TextStyle(color: AppTheme.muted, fontSize: 20)),
        ]),
      ),
    );
  }
}

// ── Language toggle row (Consumer) ────────────────────────────────────────────

class _LangToggleRow extends ConsumerWidget {
  const _LangToggleRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10n = L10n.of(context)!;
    final isEn = locale.languageCode == 'en';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(children: [
        Text(l10n.language, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.ink)),
        const Spacer(),
        GestureDetector(
          onTap: () => ref.read(localeProvider.notifier).toggle(),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.border, width: 1.5)),
            child: Row(children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                decoration: BoxDecoration(
                  color: isEn ? AppTheme.ink : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(l10n.english, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isEn ? Colors.white : AppTheme.muted)),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                decoration: BoxDecoration(
                  color: !isEn ? AppTheme.teal : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(l10n.kurdish, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: !isEn ? Colors.white : AppTheme.muted)),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
