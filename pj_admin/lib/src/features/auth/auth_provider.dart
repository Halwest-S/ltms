import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_api_client/pj_api_client.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_provider.dart';

class AuthNotifier extends StateNotifier<User?> {
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

    _clearSession();
  }

  final ApiClient _apiClient;
  final SharedPreferences _prefs;

  static const _tokenKey = 'admin_auth_token';
  static const _userKey = 'admin_auth_user';
  static const _baseUrlKey = 'admin_auth_base_url';

  static _StoredSession? _readStoredSession(SharedPreferences prefs) {
    final token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    final storedBaseUrl = prefs.getString(_baseUrlKey);
    if (token == null || userJson == null) {
      return null;
    }

    if (storedBaseUrl == null || storedBaseUrl != apiBaseUrl) {
      return null;
    }

    try {
      final decoded = jsonDecode(userJson);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final parsedUser = User.fromJson(decoded);
      final user = parsedUser.copyWith(
        isOwner: parsedUser.isOwner || parsedUser.role == UserRole.superAdmin,
      );
      if (user.role != UserRole.superAdmin) {
        return null;
      }

      return _StoredSession(token: token, user: user);
    } catch (_) {
      return null;
    }
  }

  Future<void> _persistSession(String token, User user) async {
    _apiClient.setToken(token);
    state = user;
    await _prefs.setString(_tokenKey, token);
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs.setString(_baseUrlKey, apiBaseUrl);
  }

  void _clearSession() {
    _apiClient.setToken(null);
    state = null;
    _prefs.remove(_tokenKey);
    _prefs.remove(_userKey);
    _prefs.remove(_baseUrlKey);
  }

  Future<void> login(String email, String password, String adminKey) async {
    try {
      if (adminKey.trim().isEmpty) {
        throw Exception('Admin key is required.');
      }

      final response = await _apiClient.login(
        email,
        password,
        adminKey: adminKey.trim(),
      );
      final data = Map<String, dynamic>.from(response.data as Map);
      final token = data['access_token'] as String?;
      final rawUser = data['user'];
      if (token == null || rawUser is! Map) {
        throw Exception('Invalid login response from the server.');
      }

      final user = User.fromJson(Map<String, dynamic>.from(rawUser));
      if (user.role != UserRole.superAdmin) {
        _clearSession();
        throw Exception('Only super admins can sign in to the admin portal.');
      }

      await _persistSession(
        token,
        user.copyWith(
          isOwner: user.isOwner || user.role == UserRole.superAdmin,
        ),
      );
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final message =
          (responseData is Map && responseData['message'] is String)
          ? responseData['message'] as String
          : e.message ?? 'Login failed.';
      throw Exception(message);
    } catch (e) {
      rethrow;
    }
  }

  void logout() {
    _clearSession();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(
    ref.watch(apiClientProvider),
    ref.watch(sharedPreferencesProvider),
  );
});

class LastKeyChangeNotifier extends StateNotifier<DateTime> {
  LastKeyChangeNotifier(this._prefs) : super(_loadInitialValue(_prefs));

  static const _storageKey = 'admin_last_key_change_at';
  final SharedPreferences _prefs;

  static DateTime _loadInitialValue(SharedPreferences prefs) {
    final stored = prefs.getString(_storageKey);
    if (stored == null || stored.isEmpty) {
      return DateTime.now();
    }
    return DateTime.tryParse(stored) ?? DateTime.now();
  }

  Future<void> markChangedNow() async {
    final now = DateTime.now();
    await _prefs.setString(_storageKey, now.toIso8601String());
    state = now;
  }
}

final lastKeyChangeProvider =
    StateNotifierProvider<LastKeyChangeNotifier, DateTime>((ref) {
      return LastKeyChangeNotifier(ref.watch(sharedPreferencesProvider));
    });

class _StoredSession {
  const _StoredSession({required this.token, required this.user});

  final String token;
  final User user;
}
