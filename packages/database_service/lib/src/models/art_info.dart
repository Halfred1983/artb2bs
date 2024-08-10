
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'business_day.dart';

part 'art_info.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class ArtInfo {

  String? biography;
  ArtStyle? artStyle;
  String? artistName;

  ArtInfo({
    this.biography,
    this.artStyle,
    this.artistName,
  });


  factory ArtInfo.fromJson(Map<String, dynamic> json)
  => _$ArtInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ArtInfoToJson(this);

}

enum ArtStyle {
  @JsonValue(0)
  realism,
  @JsonValue(1)
  photorealism,
  @JsonValue(2)
  expressionism,
  @JsonValue(3)
  impressionism,
  @JsonValue(4)
  abstract,
  @JsonValue(5)
  surrealism,
  @JsonValue(6)
  popArt,
  @JsonValue(7)
  folkArt,
  @JsonValue(8)
  hyperrealism,
  @JsonValue(9)
  minimalism,
}


