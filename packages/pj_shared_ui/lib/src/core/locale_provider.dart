import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
});

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;
  static const _langKey = 'selected_language';
  static const _supportedLanguages = <String>{'en', 'ku'};

  LocaleNotifier(this._prefs) : super(_loadInitialLocale(_prefs));

  static Locale _loadInitialLocale(SharedPreferences prefs) {
    final stored = prefs.getString(_langKey);
    if (stored != null && stored.isNotEmpty) {
      final normalized = stored.toLowerCase().split(RegExp(r'[-_]')).first;
      if (_supportedLanguages.contains(normalized)) {
        return Locale(normalized);
      }
    }
    return const Locale('ku'); // default to Kurdish
  }

  void setLocale(Locale locale) {
    final normalized = locale.languageCode
        .toLowerCase()
        .split(RegExp(r'[-_]'))
        .first;
    final nextCode = _supportedLanguages.contains(normalized)
        ? normalized
        : 'en';
    _prefs.setString(_langKey, nextCode);
    state = Locale(nextCode);
  }

  void toggle() {
    if (state.languageCode == 'en') {
      setLocale(const Locale('ku'));
    } else {
      setLocale(const Locale('en'));
    }
  }
}
