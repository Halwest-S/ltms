import 'package:freezed_annotation/freezed_annotation.dart';
import 'category.dart';
import 'report.dart';
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
    @JsonKey(name: 'product_platform') String? productPlatform,
    @JsonKey(name: 'product_url') String? productUrl,
    @JsonKey(name: 'product_external_id') String? productExternalId,
    @JsonKey(name: 'product_title') String? productTitle,
    @JsonKey(name: 'product_image_url') String? productImageUrl,
    @JsonKey(name: 'product_price') double? productPrice,
    @JsonKey(name: 'product_color') String? productColor,
    @JsonKey(name: 'product_size') String? productSize,
    @JsonKey(name: 'product_metadata') Map<String, dynamic>? productMetadata,
    @JsonKey(name: 'transit_countries') List<String>? transitCountries,
    @JsonKey(name: 'weight_kg') double? weightKg,
    @JsonKey(name: 'size') String? size,
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'vehicle_type_id') required int vehicleTypeId,
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'estimated_delivery_days')
    required int estimatedDeliveryDays,
    @Default(ShipmentStatus.pending) ShipmentStatus status,
    @JsonKey(name: 'delivery_confirmed_at') DateTime? deliveryConfirmedAt,
    Category? category,
    @JsonKey(name: 'vehicle_type') VehicleType? vehicleType,
    User? customer,
    User? driver,
    Report? report,
    @JsonKey(name: 'price_breakdown') Map<String, dynamic>? priceBreakdown,
  }) = _Shipment;

  factory Shipment.fromJson(Map<String, dynamic> json) =>
      _$ShipmentFromJson(json);
}
