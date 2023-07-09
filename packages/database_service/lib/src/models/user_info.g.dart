// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserInfoCWProxy {
  UserInfo description(String? description);

  UserInfo userType(UserType? userType);

  UserInfo name(String? name);

  UserInfo address(UserAddress? address);

  UserInfo photos(List<Photo>? photos);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  UserInfo call({
    String? description,
    UserType? userType,
    String? name,
    UserAddress? address,
    List<Photo>? photos,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserInfo.copyWith.fieldName(...)`
class _$UserInfoCWProxyImpl implements _$UserInfoCWProxy {
  const _$UserInfoCWProxyImpl(this._value);

  final UserInfo _value;

  @override
  UserInfo description(String? description) => this(description: description);

  @override
  UserInfo userType(UserType? userType) => this(userType: userType);

  @override
  UserInfo name(String? name) => this(name: name);

  @override
  UserInfo address(UserAddress? address) => this(address: address);

  @override
  UserInfo photos(List<Photo>? photos) => this(photos: photos);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  UserInfo call({
    Object? description = const $CopyWithPlaceholder(),
    Object? userType = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? photos = const $CopyWithPlaceholder(),
  }) {
    return UserInfo(
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      userType: userType == const $CopyWithPlaceholder()
          ? _value.userType
          // ignore: cast_nullable_to_non_nullable
          : userType as UserType?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as UserAddress?,
      photos: photos == const $CopyWithPlaceholder()
          ? _value.photos
          // ignore: cast_nullable_to_non_nullable
          : photos as List<Photo>?,
    );
  }
}

extension $UserInfoCopyWith on UserInfo {
  /// Returns a callable class that can be used as follows: `instanceOfUserInfo.copyWith(...)` or like so:`instanceOfUserInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserInfoCWProxy get copyWith => _$UserInfoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      description: json['description'] as String?,
      userType: $enumDecodeNullable(_$UserTypeEnumMap, json['userType']),
      name: json['name'] as String?,
      address: json['address'] == null
          ? null
          : UserAddress.fromJson(json['address'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'userType': _$UserTypeEnumMap[instance.userType],
      'name': instance.name,
      'description': instance.description,
      'address': instance.address?.toJson(),
      'photos': instance.photos?.map((e) => e.toJson()).toList(),
    };

const _$UserTypeEnumMap = {
  UserType.artist: 0,
  UserType.gallery: 1,
  UserType.unknown: 2,
};
