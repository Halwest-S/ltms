import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_type.freezed.dart';
part 'vehicle_type.g.dart';

@freezed
class VehicleType with _$VehicleType {
  const factory VehicleType({
    required int id,
    @JsonKey(name: 'name_en') required String nameEn,
    @JsonKey(name: 'name_ku') required String nameKu,
    @Default(1.0) double multiplier,
    @JsonKey(name: 'delivery_days_offset') @Default(0) int deliveryDaysOffset,
  }) = _VehicleType;

  factory VehicleType.fromJson(Map<String, dynamic> json) => _$VehicleTypeFromJson(json);
}
