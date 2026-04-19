import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

enum ReportStatus {
  open,
  resolved,
  rejected,
  @JsonValue('compensation_issued')
  compensationIssued,
}

@freezed
class Report with _$Report {
  const factory Report({
    required int id,
    @JsonKey(name: 'shipment_id') required String shipmentId,
    @JsonKey(name: 'customer_comment') required String customerComment,
    @JsonKey(name: 'staff_response') String? staffResponse,
    @Default(ReportStatus.open) ReportStatus status,
    @JsonKey(name: 'resolved_at') DateTime? resolvedAt,
  }) = _Report;

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}
