
import 'package:database_service/src/models/photo.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'user_address.dart';
part 'user_info.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class UserInfo {

  final UserType? userType;
  final String? name;
  final String? description;
  final UserAddress? address;
  List<Photo>? photos = List.empty(growable: true);

  UserInfo({
    this.description,
    @JsonKey(defaultValue: UserType.unknown,
        unknownEnumValue: UserType.unknown)
    this.userType,
    this.name,
    this.address,
    this.photos,
  });


  factory UserInfo.fromJson(Map<String, dynamic> json)
  => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

}

enum UserType {
  @JsonValue(0)
  artist,
  @JsonValue(1)
  gallery,
  @JsonValue(2)
  unknown,
}

