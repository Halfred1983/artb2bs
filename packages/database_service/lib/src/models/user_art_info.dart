
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'business_day.dart';

part 'user_art_info.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class UserArtInfo {

  String? aboutYou;
  String? spaces;
  String? audience;
  List<String>? vibes;
  List<BusinessDay>? openingTimes;
  List<String>? typeOfVenue;

  UserArtInfo({
    this.aboutYou,
    this.spaces,
    this.audience,
    this.vibes,
    this.openingTimes,
    this.typeOfVenue
  });


  factory UserArtInfo.fromJson(Map<String, dynamic> json)
  => _$UserArtInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserArtInfoToJson(this);

}

