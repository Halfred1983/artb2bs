// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserCWProxy {
  User id(String id);

  User firstName(String firstName);

  User lastName(String lastName);

  User email(String email);

  User imageUrl(String imageUrl);

  User userStatus(UserStatus? userStatus);

  User userInfo(UserInfo? userInfo);

  User userArtInfo(UserArtInfo? userArtInfo);

  User artworks(List<Artwork>? artworks);

  User photos(List<Photo>? photos);

  User bookingSettings(BookingSettings? bookingSettings);

  User bookings(List<Booking>? bookings);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `User(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// User(...).copyWith(id: 12, name: "My name")
  /// ````
  User call({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? imageUrl,
    UserStatus? userStatus,
    UserInfo? userInfo,
    UserArtInfo? userArtInfo,
    List<Artwork>? artworks,
    List<Photo>? photos,
    BookingSettings? bookingSettings,
    List<Booking>? bookings,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUser.copyWith.fieldName(...)`
class _$UserCWProxyImpl implements _$UserCWProxy {
  const _$UserCWProxyImpl(this._value);

  final User _value;

  @override
  User id(String id) => this(id: id);

  @override
  User firstName(String firstName) => this(firstName: firstName);

  @override
  User lastName(String lastName) => this(lastName: lastName);

  @override
  User email(String email) => this(email: email);

  @override
  User imageUrl(String imageUrl) => this(imageUrl: imageUrl);

  @override
  User userStatus(UserStatus? userStatus) => this(userStatus: userStatus);

  @override
  User userInfo(UserInfo? userInfo) => this(userInfo: userInfo);

  @override
  User userArtInfo(UserArtInfo? userArtInfo) => this(userArtInfo: userArtInfo);

  @override
  User artworks(List<Artwork>? artworks) => this(artworks: artworks);

  @override
  User photos(List<Photo>? photos) => this(photos: photos);

  @override
  User bookingSettings(BookingSettings? bookingSettings) =>
      this(bookingSettings: bookingSettings);

  @override
  User bookings(List<Booking>? bookings) => this(bookings: bookings);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `User(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// User(...).copyWith(id: 12, name: "My name")
  /// ````
  User call({
    Object? id = const $CopyWithPlaceholder(),
    Object? firstName = const $CopyWithPlaceholder(),
    Object? lastName = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? imageUrl = const $CopyWithPlaceholder(),
    Object? userStatus = const $CopyWithPlaceholder(),
    Object? userInfo = const $CopyWithPlaceholder(),
    Object? userArtInfo = const $CopyWithPlaceholder(),
    Object? artworks = const $CopyWithPlaceholder(),
    Object? photos = const $CopyWithPlaceholder(),
    Object? bookingSettings = const $CopyWithPlaceholder(),
    Object? bookings = const $CopyWithPlaceholder(),
  }) {
    return User(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      firstName: firstName == const $CopyWithPlaceholder() || firstName == null
          ? _value.firstName
          // ignore: cast_nullable_to_non_nullable
          : firstName as String,
      lastName: lastName == const $CopyWithPlaceholder() || lastName == null
          ? _value.lastName
          // ignore: cast_nullable_to_non_nullable
          : lastName as String,
      email: email == const $CopyWithPlaceholder() || email == null
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
      imageUrl: imageUrl == const $CopyWithPlaceholder() || imageUrl == null
          ? _value.imageUrl
          // ignore: cast_nullable_to_non_nullable
          : imageUrl as String,
      userStatus: userStatus == const $CopyWithPlaceholder()
          ? _value.userStatus
          // ignore: cast_nullable_to_non_nullable
          : userStatus as UserStatus?,
      userInfo: userInfo == const $CopyWithPlaceholder()
          ? _value.userInfo
          // ignore: cast_nullable_to_non_nullable
          : userInfo as UserInfo?,
      userArtInfo: userArtInfo == const $CopyWithPlaceholder()
          ? _value.userArtInfo
          // ignore: cast_nullable_to_non_nullable
          : userArtInfo as UserArtInfo?,
      artworks: artworks == const $CopyWithPlaceholder()
          ? _value.artworks
          // ignore: cast_nullable_to_non_nullable
          : artworks as List<Artwork>?,
      photos: photos == const $CopyWithPlaceholder()
          ? _value.photos
          // ignore: cast_nullable_to_non_nullable
          : photos as List<Photo>?,
      bookingSettings: bookingSettings == const $CopyWithPlaceholder()
          ? _value.bookingSettings
          // ignore: cast_nullable_to_non_nullable
          : bookingSettings as BookingSettings?,
      bookings: bookings == const $CopyWithPlaceholder()
          ? _value.bookings
          // ignore: cast_nullable_to_non_nullable
          : bookings as List<Booking>?,
    );
  }
}

extension $UserCopyWith on User {
  /// Returns a callable class that can be used as follows: `instanceOfUser.copyWith(...)` or like so:`instanceOfUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserCWProxy get copyWith => _$UserCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      imageUrl: json['imageUrl'] as String,
      userStatus: $enumDecodeNullable(_$UserStatusEnumMap, json['userStatus']),
      userInfo: json['userInfo'] == null
          ? null
          : UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
      userArtInfo: json['userArtInfo'] == null
          ? null
          : UserArtInfo.fromJson(json['userArtInfo'] as Map<String, dynamic>),
      artworks: (json['artworks'] as List<dynamic>?)
          ?.map((e) => Artwork.fromJson(e as Map<String, dynamic>))
          .toList(),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookingSettings: json['bookingSettings'] == null
          ? null
          : BookingSettings.fromJson(
              json['bookingSettings'] as Map<String, dynamic>),
      bookings: (json['bookings'] as List<dynamic>?)
          ?.map((e) => Booking.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'userStatus': _$UserStatusEnumMap[instance.userStatus],
      'userInfo': instance.userInfo?.toJson(),
      'userArtInfo': instance.userArtInfo?.toJson(),
      'artworks': instance.artworks?.map((e) => e.toJson()).toList(),
      'photos': instance.photos?.map((e) => e.toJson()).toList(),
      'bookingSettings': instance.bookingSettings?.toJson(),
      'bookings': instance.bookings?.map((e) => e.toJson()).toList(),
    };

const _$UserStatusEnumMap = {
  UserStatus.initialised: 0,
  UserStatus.personalInfo: 1,
  UserStatus.artInfo: 2,
  UserStatus.paymentInfo: 3,
};
