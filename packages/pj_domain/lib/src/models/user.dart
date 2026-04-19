import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole {
  customer,
  driver,
  staff,
  @JsonValue('super_admin')
  superAdmin,
}

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    required UserRole role,
    @JsonKey(name: 'device_token') String? deviceToken,
    @Default('en') String language,
    @Default('light') String theme,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default(false) bool isOwner,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
