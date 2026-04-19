import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_api_client/pj_api_client.dart';
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

final customerShipmentsProvider = FutureProvider<List<Shipment>>((ref) async {
  final client = ref.watch(apiClientProvider);
  final status = ref.watch(shipmentStatusFilterProvider);
  final search = ref.watch(shipmentSearchProvider);

  final response = await client.getShipments(
    status: shipmentStatusQueryValue(status),
    search: search.isEmpty ? null : search,
  );

  final List data = response.data['data'];
  return data.map((json) => Shipment.fromJson(json)).toList();
});

class ShipmentNotifier extends StateNotifier<AsyncValue<void>> {
  final ApiClient _client;

  ShipmentNotifier(this._client) : super(const AsyncData(null));

  Future<void> createShipment({
    required String origin,
    required String destination,
    double? weight,
    String? size,
    required int categoryId,
    required int vehicleTypeId,
  }) async {
    state = const AsyncLoading();
    try {
      await _client.createShipment({
        'origin': origin,
        'destination': destination,
        'category_id': categoryId,
        'vehicle_type_id': vehicleTypeId,
        ...?(weight == null ? null : {'weight_kg': weight}),
        ...?(size == null ? null : {'size': size}),
      });
      state = const AsyncData(null);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}

final shipmentNotifierProvider =
    StateNotifierProvider<ShipmentNotifier, AsyncValue<void>>((ref) {
      return ShipmentNotifier(ref.watch(apiClientProvider));
    });
