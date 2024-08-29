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

  User venueInfo(VenueInfo? venueInfo);

  User payoutInfo(PayoutInfo? payoutInfo);

  User artInfo(ArtInfo? artInfo);

  User photos(List<Photo>? photos);

  User bookingSettings(BookingSettings? bookingSettings);

  User exhibitionCount(int exhibitionCount);

  User balance(String? balance);

  User createdAt(DateTime? createdAt);

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
    VenueInfo? venueInfo,
    PayoutInfo? payoutInfo,
    ArtInfo? artInfo,
    List<Photo>? photos,
    BookingSettings? bookingSettings,
    int? exhibitionCount,
    String? balance,
    DateTime? createdAt,
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
  User venueInfo(VenueInfo? venueInfo) => this(venueInfo: venueInfo);

  @override
  User payoutInfo(PayoutInfo? payoutInfo) => this(payoutInfo: payoutInfo);

  @override
  User artInfo(ArtInfo? artInfo) => this(artInfo: artInfo);

  @override
  User photos(List<Photo>? photos) => this(photos: photos);

  @override
  User bookingSettings(BookingSettings? bookingSettings) =>
      this(bookingSettings: bookingSettings);

  @override
  User exhibitionCount(int exhibitionCount) =>
      this(exhibitionCount: exhibitionCount);

  @override
  User balance(String? balance) => this(balance: balance);

  @override
  User createdAt(DateTime? createdAt) => this(createdAt: createdAt);

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
    Object? venueInfo = const $CopyWithPlaceholder(),
    Object? payoutInfo = const $CopyWithPlaceholder(),
    Object? artInfo = const $CopyWithPlaceholder(),
    Object? photos = const $CopyWithPlaceholder(),
    Object? bookingSettings = const $CopyWithPlaceholder(),
    Object? exhibitionCount = const $CopyWithPlaceholder(),
    Object? balance = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
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
      venueInfo: venueInfo == const $CopyWithPlaceholder()
          ? _value.venueInfo
          // ignore: cast_nullable_to_non_nullable
          : venueInfo as VenueInfo?,
      payoutInfo: payoutInfo == const $CopyWithPlaceholder()
          ? _value.payoutInfo
          // ignore: cast_nullable_to_non_nullable
          : payoutInfo as PayoutInfo?,
      artInfo: artInfo == const $CopyWithPlaceholder()
          ? _value.artInfo
          // ignore: cast_nullable_to_non_nullable
          : artInfo as ArtInfo?,
      photos: photos == const $CopyWithPlaceholder()
          ? _value.photos
          // ignore: cast_nullable_to_non_nullable
          : photos as List<Photo>?,
      bookingSettings: bookingSettings == const $CopyWithPlaceholder()
          ? _value.bookingSettings
          // ignore: cast_nullable_to_non_nullable
          : bookingSettings as BookingSettings?,
      exhibitionCount: exhibitionCount == const $CopyWithPlaceholder() ||
              exhibitionCount == null
          ? _value.exhibitionCount
          // ignore: cast_nullable_to_non_nullable
          : exhibitionCount as int,
      balance: balance == const $CopyWithPlaceholder()
          ? _value.balance
          // ignore: cast_nullable_to_non_nullable
          : balance as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
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
      venueInfo: json['venueInfo'] == null
          ? null
          : VenueInfo.fromJson(json['venueInfo'] as Map<String, dynamic>),
      payoutInfo: json['payoutInfo'] == null
          ? null
          : PayoutInfo.fromJson(json['payoutInfo'] as Map<String, dynamic>),
      artInfo: json['artInfo'] == null
          ? null
          : ArtInfo.fromJson(json['artInfo'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookingSettings: json['bookingSettings'] == null
          ? null
          : BookingSettings.fromJson(
              json['bookingSettings'] as Map<String, dynamic>),
      exhibitionCount: (json['exhibitionCount'] as num?)?.toInt() ?? 0,
      balance: json['balance'] as String?,
      createdAt: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['createdAt'], const TimestampConverter().fromJson),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'userStatus': _$UserStatusEnumMap[instance.userStatus],
      'userInfo': instance.userInfo?.toJson(),
      'venueInfo': instance.venueInfo?.toJson(),
      'payoutInfo': instance.payoutInfo?.toJson(),
      'artInfo': instance.artInfo?.toJson(),
      'photos': instance.photos?.map((e) => e.toJson()).toList(),
      'bookingSettings': instance.bookingSettings?.toJson(),
      'exhibitionCount': instance.exhibitionCount,
      'balance': instance.balance,
      'createdAt': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.createdAt, const TimestampConverter().toJson),
    };

const _$UserStatusEnumMap = {
  UserStatus.initialised: 0,
  UserStatus.type: 2,
  UserStatus.personalInfo: 3,
  UserStatus.locationInfo: 4,
  UserStatus.venueInfo: 5,
  UserStatus.priceInfo: 6,
  UserStatus.photoInfo: 7,
  UserStatus.descriptionInfo: 8,
  UserStatus.capacityInfo: 9,
  UserStatus.availabilityInfo: 10,
  UserStatus.artInfo: 11,
  UserStatus.paymentInfo: 12,
  UserStatus.notVerified: 13,
  UserStatus.completed: 14,
  UserStatus.openingTimes: 15,
  UserStatus.spaceInfo: 16,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
