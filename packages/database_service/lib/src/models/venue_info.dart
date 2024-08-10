
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'business_day.dart';

part 'venue_info.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class VenueInfo {

  String? aboutYou;
  String? spaces;
  String? audience;
  List<String>? vibes;
  List<BusinessDay>? openingTimes;
  List<String>? typeOfVenue;

  VenueInfo({
    this.aboutYou,
    this.spaces,
    this.audience,
    this.vibes,
    this.openingTimes,
    this.typeOfVenue
  });


  factory VenueInfo.fromJson(Map<String, dynamic> json)
  => _$VenueInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VenueInfoToJson(this);

}

