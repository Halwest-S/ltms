import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

final staffCompactViewProvider =
    StateNotifierProvider<StaffCompactViewNotifier, bool>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return StaffCompactViewNotifier(prefs);
    });

class StaffCompactViewNotifier extends StateNotifier<bool> {
  StaffCompactViewNotifier(this._prefs)
    : super(_prefs.getBool(_compactViewKey) ?? false);

  static const _compactViewKey = 'staff_force_compact_view';

  final SharedPreferences _prefs;

  void setEnabled(bool value) {
    if (state == value) {
      return;
    }

    _prefs.setBool(_compactViewKey, value);
    state = value;
  }

  void toggle() => setEnabled(!state);
}

bool useCompactStaffLayout(BuildContext context, WidgetRef ref) {
  final forceCompact = ref.watch(staffCompactViewProvider);
  final viewportCompact = MediaQuery.sizeOf(context).width < 960;
  return viewportCompact || forceCompact;
}
