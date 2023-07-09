
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user_info.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'user.g.dart';


@JsonSerializable(explicitToJson: true)
@CopyWith()
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
  final UserStatus? userStatus;
  final UserInfo? artb2bUserEntityInfo;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
    @JsonKey(
        defaultValue: UserStatus.initialised,
        unknownEnumValue: UserStatus.initialised
    )
    required this.userStatus,
    this.artb2bUserEntityInfo
  });

  factory User.fromJson(Map<String, dynamic?> json)
  => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

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
