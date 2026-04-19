import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

enum NotificationType {
  @JsonValue('status_update')
  statusUpdate,
  @JsonValue('report_update')
  reportUpdate,
  assignment,
}

@freezed
class Notification with _$Notification {
  const factory Notification({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'message_en') required String messageEn,
    @JsonKey(name: 'message_ku') required String messageKu,
    required NotificationType type,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? location,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
}
