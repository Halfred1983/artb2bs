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
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'userStatus': _$UserStatusEnumMap[instance.userStatus],
      'userInfo': instance.userInfo?.toJson(),
    };

const _$UserStatusEnumMap = {
  UserStatus.initialised: 0,
  UserStatus.personalInfo: 1,
  UserStatus.artInfo: 2,
  UserStatus.paymentInfo: 3,
};
