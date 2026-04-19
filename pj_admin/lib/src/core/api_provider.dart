import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_api_client/pj_api_client.dart';

const String _productionBaseUrl = 'http://localhost:8000';
const String _localWebDebugBaseUrl = 'http://127.0.0.1:8000';

const String _configuredBaseUrl = String.fromEnvironment(
  'BASE_URL',
  defaultValue: '',
);

final String apiBaseUrl = _resolveApiBaseUrl();

String _resolveApiBaseUrl() {
  final host = Uri.base.host.toLowerCase();
  final isLocalWebDebugHost = kDebugMode &&
      kIsWeb &&
      (host == 'localhost' || host == '127.0.0.1');

  if (isLocalWebDebugHost) {
    return _localWebDebugBaseUrl;
  }

  if (_configuredBaseUrl.isNotEmpty) {
    return _configuredBaseUrl;
  }

  return _productionBaseUrl;
}

String resolveApiUrl(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path;
  }

  final normalizedBase = apiBaseUrl.endsWith('/')
      ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
      : apiBaseUrl;
  final normalizedPath = path.startsWith('/') ? path : '/$path';
  return '$normalizedBase$normalizedPath';
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: apiBaseUrl);
});
