import 'package:freezed_annotation/freezed_annotation.dart';

part 'pricing_config.freezed.dart';
part 'pricing_config.g.dart';

@freezed
class PricingConfig with _$PricingConfig {
  const factory PricingConfig({
    required int id,
    @JsonKey(name: 'base_price') required double basePrice,
    @JsonKey(name: 'weight_rate') required double weightRate,
  }) = _PricingConfig;

  factory PricingConfig.fromJson(Map<String, dynamic> json) => _$PricingConfigFromJson(json);
}
