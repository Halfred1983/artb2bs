
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:database_service/database.dart';
import 'package:database_service/src/models/photo.dart';
import 'package:json_annotation/json_annotation.dart';

import 'artwork.dart';
import 'booking_settings.dart';

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
  final UserInfo? userInfo;
  final UserArtInfo? userArtInfo;
  List<Artwork>? artworks;
  List<Photo>? photos;
  BookingSettings? bookingSettings;
  // List<Booking>? bookings;
  String? balance;

  User({
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
    this.userInfo,
    this.userArtInfo,
    this.artworks,
    this.photos,
    this.bookingSettings,
    // this.bookings,
    this.balance
  });

  factory User.fromJson(Map<String, dynamic?> json)
  => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.empty() => User(
    id: '',
    firstName: '',
    lastName: '',
    email: '',
    imageUrl: '',
    userStatus: UserStatus.initialised,
  );
}


enum UserStatus {
  @JsonValue(0)
  initialised,
  @JsonValue(2)
  type,
  @JsonValue(3)
  personalInfo,
  @JsonValue(4)
  locationInfo,
  @JsonValue(5)
  venueInfo,
  @JsonValue(6)
  priceInfo,
  @JsonValue(7)
  photoInfo,
  @JsonValue(8)
  descriptionInfo,
  @JsonValue(9)
  capacityInfo,
  @JsonValue(10)
  availabilityInfo,
  @JsonValue(11)
  artInfo,
  @JsonValue(12)
  paymentInfo,
  @JsonValue(13)
  notVerified,
  @JsonValue(14)
  completed,
  @JsonValue(15)
  openingTimes,
  @JsonValue(16)
  spaceInfo,
}
