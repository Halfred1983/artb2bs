
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
  final String? id;
  final String? url;
  final List<String>? tags;
  final String? name;
  final String? year;
  final String? price;
  final String? height;
  final String? width;

  Artwork([
    this.id,
    this.url,
    this.tags,
    this.name,
    this.year,
    this.price,
    this.height,
    this.width,
  ]);

  factory Artwork.fromJson(Map<String, dynamic?> json)
  => _$ArtworkFromJson(json);

  Map<String, dynamic> toJson() => _$ArtworkToJson(this);

}

