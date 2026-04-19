import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:pj_domain/pj_domain.dart';
import '../../core/api_provider.dart';

final shipmentStatusFilterProvider = StateProvider<ShipmentStatus?>(
  (ref) => null,
);
final shipmentSearchProvider = StateProvider<String>((ref) => '');

String? shipmentStatusQueryValue(ShipmentStatus? status) {
  return switch (status) {
    null => null,
    ShipmentStatus.pending => 'pending',
    ShipmentStatus.inTransit => 'in_transit',
    ShipmentStatus.delivered => 'delivered',
    ShipmentStatus.reported => 'reported',
  };
}

final shipmentListProvider = FutureProvider<List<Shipment>>((ref) async {
  final client = ref.watch(apiClientProvider);
  final status = ref.watch(shipmentStatusFilterProvider);
  final search = ref.watch(shipmentSearchProvider);

  try {
    final response = await client.getShipments(
      status: shipmentStatusQueryValue(status),
      search: search.isEmpty ? null : search,
    );
    final List data = response.data['data'];
    return data.map((json) => Shipment.fromJson(json)).toList();
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      throw Exception('مۆڵەت پێنەدراوە. تکایە دووبارە بچۆ ژوورەوە.');
    }
    rethrow;
  }
});
