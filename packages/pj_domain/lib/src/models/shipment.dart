import 'package:freezed_annotation/freezed_annotation.dart';
import 'category.dart';
import 'user.dart';
import 'vehicle_type.dart';

part 'shipment.freezed.dart';
part 'shipment.g.dart';

enum ShipmentStatus {
  pending,
  @JsonValue('in_transit')
  inTransit,
  delivered,
  reported,
}

@freezed
class Shipment with _$Shipment {
  const factory Shipment({
    required String id,
    @JsonKey(name: 'customer_id') required int customerId,
    @JsonKey(name: 'driver_id') int? driverId,
    required String origin,
    required String destination,
    @JsonKey(name: 'transit_countries') List<String>? transitCountries,
    @JsonKey(name: 'weight_kg') double? weightKg,
    @JsonKey(name: 'size') String? size,
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'vehicle_type_id') required int vehicleTypeId,
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'estimated_delivery_days') required int estimatedDeliveryDays,
    @Default(ShipmentStatus.pending) ShipmentStatus status,
    Category? category,
    @JsonKey(name: 'vehicle_type') VehicleType? vehicleType,
    User? customer,
    User? driver,
    @JsonKey(name: 'price_breakdown') Map<String, dynamic>? priceBreakdown,
  }) = _Shipment;

  factory Shipment.fromJson(Map<String, dynamic> json) => _$ShipmentFromJson(json);
}
