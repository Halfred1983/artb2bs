
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:database_service/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refund.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Refund {
  @JsonKey(
      defaultValue: RefundStatus.pending,
      unknownEnumValue: RefundStatus.pending
  )
  RefundStatus? refundStatus;
  String? refundId;
  String? bookingId;
  String? paymentIntentId;
  String? artistId;
  String? hostId;
  @TimestampConverter()
  DateTime? refundTimestamp;

  Refund({
    this.refundStatus,
    this.refundId,
    this.bookingId,
    this.paymentIntentId,
    this.artistId,
    this.hostId,
    this.refundTimestamp
  });


  factory Refund.fromJson(Map<String, dynamic> json)
  => _$RefundFromJson(json);

  Map<String, dynamic> toJson() => _$RefundToJson(this);

}


enum RefundStatus {
  @JsonValue(0)
  pending,
  @JsonValue(1)
  completed,
  @JsonValue(2)
  failed,
}


