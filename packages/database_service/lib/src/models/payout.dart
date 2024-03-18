
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../database.dart';

part 'payout.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Payout {

  @JsonKey(
      defaultValue: PayoutStatus.unknown,
      unknownEnumValue: PayoutStatus.unknown
  )
  PayoutStatus? payoutStatus;
  @TimestampConverter()
  DateTime? timestamp;
  String? userId;
  int? amount;
  String? currencyCode; //to be added when locale
  String? paypalAccount;


  Payout(this.payoutStatus, this.timestamp, this.userId, this.amount,
      this.currencyCode, this.paypalAccount);

  factory Payout.fromJson(Map<String, dynamic> json)
  => _$PayoutFromJson(json);

  Map<String, dynamic> toJson() => _$PayoutToJson(this);

}


enum PayoutStatus {
  @JsonValue(0)
  success,
  @JsonValue(1)
  failed,
  @JsonValue(2)
  unknown,
}

