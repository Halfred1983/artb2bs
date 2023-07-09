
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user_info.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'artwork.g.dart';

/*
	6	Technique 
	7	Frame (?)
	8	Type of hanging (?)

 */

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Artwork {
  final String id;
  final String url;
  final String tag;
  final String name;
  final String year;
  final int price;

  const Artwork({
    required this.id,
    required this.url,
    required this.tag,
    required this.name,
    required this.year,
    required this.price,
  });

  factory Artwork.fromJson(Map<String, dynamic?> json)
  => _$ArtworkFromJson(json);

  Map<String, dynamic> toJson() => _$ArtworkToJson(this);

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
