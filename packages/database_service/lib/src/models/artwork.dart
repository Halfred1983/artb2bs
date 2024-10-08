
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
  String? url;
  List<String>? tags;
  String? name;
  String? year;
  String? price;
  String? currencyCode;
  String? height;
  String? width;
  String? technique;
  String? type;

  Artwork({
    this.url,
    this.tags,
    this.name,
    this.year,
    this.price,
    this.currencyCode,
    this.height,
    this.width,
    this.technique,
    this.type,
  });

  factory Artwork.empty() => Artwork(
      url: "",
      tags: List.empty(growable: true),
      name: "",
      year: "",
      price: "",
      height: "",
      width: "",
      technique: ""
  );


  factory Artwork.fromJson(Map<String, dynamic?> json)
  => _$ArtworkFromJson(json);

  Map<String, dynamic> toJson() => _$ArtworkToJson(this);

}

