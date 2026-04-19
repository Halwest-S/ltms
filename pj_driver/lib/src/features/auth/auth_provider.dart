import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_api_client/pj_api_client.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_provider.dart';

class AuthNotifier extends StateNotifier<User?> {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;
  static const _tokenKey = 'driver_auth_token';
  static const _userKey = 'driver_auth_user';

  AuthNotifier(ApiClient apiClient, SharedPreferences prefs)
      : this._(apiClient, prefs, _readStoredSession(prefs));

  AuthNotifier._(
    this._apiClient,
    this._prefs,
    _StoredSession? restoredSession,
  ) : super(restoredSession?.user) {
    if (restoredSession != null) {
      _apiClient.setToken(restoredSession.token);
      return;
    }

    _apiClient.setToken(null);
    _prefs.remove(_tokenKey);
    _prefs.remove(_userKey);
  }

  static _StoredSession? _readStoredSession(SharedPreferences prefs) {
    final token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    if (token == null || userJson == null) {
      return null;
    }

    try {
      final decoded = jsonDecode(userJson);
      if (decoded is Map<String, dynamic>) {
        return _StoredSession(token: token, user: User.fromJson(decoded));
      }
    } catch (_) {}

    return null;
  }

  Future<void> _persistSession(String token, User user) async {
    _apiClient.setToken(token);
    state = user;
    await _prefs.setString(_tokenKey, token);
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> login(String email, String password) async {
    final response = await _apiClient.login(email, password);
    await _persistSession(
      response.data['access_token'],
      User.fromJson(response.data['user']),
    );
  }

  Future<void> logout() async {
    _apiClient.setToken(null);
    state = null;
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userKey);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(
    ref.watch(apiClientProvider),
    ref.watch(sharedPreferencesProvider),
  );
});

class _StoredSession {
  const _StoredSession({required this.token, required this.user});

  final String token;
  final User user;
}
