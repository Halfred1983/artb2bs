
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user_info.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'payout_info.g.dart';

/*
	6	Technique 
	7	Frame (?)
	8	Type of hanging (?)

 */

@JsonSerializable(explicitToJson: true)
@CopyWith()
class PayoutInfo {
  String? bankCountry;
  String? bankCountryCode;
  String? currency;
  String? accountHolder;
  // String? routingNumber;
  // String? accountNumber;
  String? iban;
  String? customerId;
  int? bankAccountId;

  PayoutInfo({
    this.bankCountry,
    this.bankCountryCode,
    this.currency,
    this.accountHolder,
    // this.routingNumber,
    this.iban,
    // this.accountNumber,
    this.customerId,
    this.bankAccountId,
  });

  factory PayoutInfo.fromJson(Map<String, dynamic?> json)
  => _$PayoutInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PayoutInfoToJson(this);

}

