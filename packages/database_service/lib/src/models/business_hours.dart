
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../database.dart';

part 'business_hours.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class BusinessHours {

  @TimeOfDayConverter()
  TimeOfDay? from;

  @TimeOfDayConverter()
  TimeOfDay? to;


  BusinessHours(this.from, this.to);

  factory BusinessHours.fromJson(Map<String, dynamic> json)
  => _$BusinessHoursFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessHoursToJson(this);

}

class TimeOfDayConverter implements JsonConverter<TimeOfDay?, String?> {
  const TimeOfDayConverter();

  @override
  TimeOfDay? fromJson(String? json) {
    if (json == null) return null;
    final parts = json.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  String? toJson(TimeOfDay? object) {
    if (object == null) return null;
    return '${object.hour}:${object.minute}';
  }
}

