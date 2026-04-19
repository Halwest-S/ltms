import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/router.dart';
import 'src/core/theme.dart';

import 'package:pj_shared_ui/pj_shared_ui.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const LTMSStaffApp(),
    ),
  );
}

class LTMSStaffApp extends ConsumerWidget {
  const LTMSStaffApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      key: ValueKey('app_${locale.languageCode}'),
      onGenerateTitle: (context) => L10n.of(context)!.ltmsStaff,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      locale: locale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: [
        L10n.delegate,
        if (locale.languageCode == 'ku') ...[
          KurdishMaterialLocalizations.delegate,
          KurdishCupertinoLocalizations.delegate,
        ],
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
