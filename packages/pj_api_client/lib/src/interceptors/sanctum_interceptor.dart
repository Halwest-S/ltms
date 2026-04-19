import 'package:dio/dio.dart';

class SanctumInterceptor extends Interceptor {
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle unauthorized (logout, clear token, etc.)
    }
    super.onError(err, handler);
  }
}
