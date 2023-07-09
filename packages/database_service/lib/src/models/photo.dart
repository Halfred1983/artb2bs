
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user_info.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'photo.g.dart';


@JsonSerializable(explicitToJson: true)
@CopyWith()
class Photo {
  final String id;
  final String url;
  final String tag;

  const Photo({
    required this.id,
    required this.url,
    required this.tag,
  });

  factory Photo.fromJson(Map<String, dynamic?> json)
  => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);

}


enum UserStatus {
  @JsonValue(0)
  initialised,
  @JsonValue(1)
  personalInfo,
  @JsonValue(2)
  artInfo,
  @JsonValue(3)
  paymentInfo,
}
