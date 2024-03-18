
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../database.dart';

part 'business_hours.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class BusinessHours {

  String? from;
  String? to;


  BusinessHours(this.from, this.to);

  factory BusinessHours.fromJson(Map<String, dynamic> json)
  => _$BusinessHoursFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessHoursToJson(this);

}

