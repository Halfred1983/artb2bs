
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../database.dart';
import 'business_hours.dart';

part 'business_day.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class BusinessDay {

  @JsonKey(
      defaultValue: DayOfWeek.monday,
      unknownEnumValue: DayOfWeek.monday
  )
  DayOfWeek? dayOfWeek;
  List<BusinessHours> hourInterval;
  bool? open;


  BusinessDay(this.dayOfWeek, this.hourInterval, this.open);

  factory BusinessDay.fromJson(Map<String, dynamic> json)
  => _$BusinessDayFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessDayToJson(this);

}


enum DayOfWeek {
  @JsonValue(0)
  monday,
  @JsonValue(1)
  tuesday,
  @JsonValue(2)
  wednesday,
  @JsonValue(3)
  thursday,
  @JsonValue(4)
  friday,
  @JsonValue(5)
  saturday,
  @JsonValue(6)
  sunday,
}

