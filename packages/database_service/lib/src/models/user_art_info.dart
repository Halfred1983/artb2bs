
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_art_info.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class UserArtInfo {

  String? capacity;
  String? spaces;
  List<String>? vibes;

  UserArtInfo({
    this.capacity,
    this.spaces,
    this.vibes,
  });


  factory UserArtInfo.fromJson(Map<String, dynamic> json)
  => _$UserArtInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserArtInfoToJson(this);

}

