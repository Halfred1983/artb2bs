
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../database.dart';

part 'payout.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Payout {

  @JsonKey(
      defaultValue: PayoutStatus.initialised,
      unknownEnumValue: PayoutStatus.initialised
  )
  PayoutStatus? payoutStatus;
  @TimestampConverter()
  DateTime? createdAt;
  String? userId;
  double? sourceAmount;
  double? totalFee;
  double? targetAmount;
  String? targetCurrency; //to be added when locale
  int? transferId;
  String? quoteId;
  String? customerTransactionId;

  Payout(this.payoutStatus, this.createdAt, this.userId, this.sourceAmount,
      this.totalFee, this.targetAmount, this.targetCurrency, this.transferId);

  factory Payout.fromJson(Map<String, dynamic> json)
  => _$PayoutFromJson(json);

  Map<String, dynamic> toJson() => _$PayoutToJson(this);

}


enum PayoutStatus {
  @JsonValue(0)
  initialised,
  @JsonValue(1)
  onProgress,
  @JsonValue(2)
  completed,
  @JsonValue(4)
  failed,
}

