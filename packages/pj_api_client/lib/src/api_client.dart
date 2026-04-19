import 'package:dio/dio.dart';

import 'interceptors/sanctum_interceptor.dart';

class ApiClient {
  late final Dio _dio;
  final SanctumInterceptor _interceptor = SanctumInterceptor();

  ApiClient({required String baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: const {'Accept': 'application/json'},
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(_interceptor);
    _dio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );
  }

  void setToken(String? token) => _interceptor.setToken(token);

  // Auth
  Future<Response> login(
    String email,
    String password, {
    String? adminKey,
    String? deviceToken,
  }) {
    return _dio.post(
      '/api/v1/auth/login',
      data: {
        'email': email,
        'password': password,
        'admin_key': adminKey,
        'device_token': deviceToken,
      },
    );
  }

  Future<Response> register(
    String name,
    String email,
    String phoneNumber,
    String password,
    String confirmation,
    String role,
  ) {
    return _dio.post(
      '/api/v1/auth/register',
      data: {
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'password_confirmation': confirmation,
        'role': role,
      },
    );
  }

  Future<Response> logout() => _dio.post('/api/v1/auth/logout');
  Future<Response> me() => _dio.get('/api/v1/auth/me');
  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) {
    return _dio.patch(
      '/api/v1/auth/password',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      },
    );
  }

  // Shipments
  Future<Response> getShipments({
    String? status,
    String? search,
    int page = 1,
  }) {
    return _dio.get(
      '/api/v1/shipments',
      queryParameters: {'status': status, 'search': search, 'page': page},
    );
  }

  Future<Response> createShipment(Map<String, dynamic> data) =>
      _dio.post('/api/v1/shipments', data: data);
  Future<Response> getShipmentDetail(String id) =>
      _dio.get('/api/v1/shipments/$id');
  Future<Response> updateShipmentStatus(String id, String status) =>
      _dio.patch('/api/v1/shipments/$id/status', data: {'status': status});
  Future<Response> assignDriver(String id, int driverId) =>
      _dio.patch('/api/v1/shipments/$id/assign', data: {'driver_id': driverId});
  Future<Response> calculatePricing({
    double? weight,
    String? size,
    required int categoryId,
    required int vehicleTypeId,
  }) {
    return _dio.get(
      '/api/v1/pricing/calculate',
      queryParameters: {
        'weight_kg': weight,
        'size': size,
        'category_id': categoryId,
        'vehicle_type_id': vehicleTypeId,
      },
    );
  }

  // Reports
  Future<Response> createReport(String shipmentId, String comment) {
    return _dio.post(
      '/api/v1/reports',
      data: {'shipment_id': shipmentId, 'customer_comment': comment},
    );
  }

  Future<Response> getReports() => _dio.get('/api/v1/reports');

  Future<Response> respondToReport(
    int reportId,
    String response,
    String status,
  ) {
    return _dio.put(
      '/api/v1/reports/$reportId',
      data: {'staff_response': response, 'status': status},
    );
  }

  // Notifications
  Future<Response> getNotifications() => _dio.get('/api/v1/notifications');
  Future<Response> markNotificationAsRead(int id) =>
      _dio.patch('/api/v1/notifications/$id/read');
  Future<Response> markAllNotificationsAsRead() =>
      _dio.patch('/api/v1/notifications/read-all');

  // Staff Notifications
  Future<Response> sendNotification({
    required int userId,
    required String messageEn,
    required String messageku,
    String? location,
    List<int>? imageBytes,
    String? imageFilename,
    String? shipmentId,
  }) async {
    final formData = FormData.fromMap({
      'user_id': userId,
      'message_en': messageEn,
      'message_ku': messageku,
      'location': location,
      'shipment_id': shipmentId,
      if (imageBytes != null && imageFilename != null)
        'image': MultipartFile.fromBytes(imageBytes, filename: imageFilename),
    });
    return _dio.post('/api/v1/staff/notifications/send', data: formData);
  }

  Future<Response> getCustomers() => _dio.get('/api/v1/staff/customers');
  Future<Response> getDrivers() => _dio.get('/api/v1/staff/drivers');
  Future<Response> getSentNotifications() =>
      _dio.get('/api/v1/staff/notifications/sent');

  // Admin
  Future<Response> createUserByAdmin(Map<String, dynamic> data) =>
      _dio.post('/api/v1/admin/users', data: data);
  Future<Response> getAdminUsers() => _dio.get('/api/v1/admin/users');
  Future<Response> toggleUserStatus(int userId) =>
      _dio.patch('/api/v1/admin/users/$userId/toggle');
  Future<Response> getAdminCategories() => _dio.get('/api/v1/admin/categories');
  Future<Response> createAdminCategory(Map<String, dynamic> data) =>
      _dio.post('/api/v1/admin/categories', data: data);
  Future<Response> updateAdminCategory(
    int categoryId,
    Map<String, dynamic> data,
  ) => _dio.patch('/api/v1/admin/categories/$categoryId', data: data);
  Future<Response> deleteAdminCategory(int categoryId) =>
      _dio.delete('/api/v1/admin/categories/$categoryId');
  Future<Response> getAdminVehicles() => _dio.get('/api/v1/admin/vehicles');
  Future<Response> createAdminVehicle(Map<String, dynamic> data) =>
      _dio.post('/api/v1/admin/vehicles', data: data);
  Future<Response> updateAdminVehicle(
    int vehicleTypeId,
    Map<String, dynamic> data,
  ) => _dio.patch('/api/v1/admin/vehicles/$vehicleTypeId', data: data);
  Future<Response> deleteAdminVehicle(int vehicleTypeId) =>
      _dio.delete('/api/v1/admin/vehicles/$vehicleTypeId');
  Future<Response> getAdminPricing() => _dio.get('/api/v1/admin/pricing');
  Future<Response> updateAdminPricing(Map<String, dynamic> data) =>
      _dio.patch('/api/v1/admin/pricing', data: data);
  Future<Response> getAdminFaqs() => _dio.get('/api/v1/admin/faq');
  Future<Response> createAdminFaq(Map<String, dynamic> data) =>
      _dio.post('/api/v1/admin/faq', data: data);
  Future<Response> updateAdminFaq(int faqId, Map<String, dynamic> data) =>
      _dio.patch('/api/v1/admin/faq/$faqId', data: data);
  Future<Response> deleteAdminFaq(int faqId) =>
      _dio.delete('/api/v1/admin/faq/$faqId');
}
