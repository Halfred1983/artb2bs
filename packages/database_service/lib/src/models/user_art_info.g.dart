// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_art_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserArtInfoCWProxy {
  UserArtInfo aboutYou(String? aboutYou);

  UserArtInfo spaces(String? spaces);

  UserArtInfo audience(String? audience);

  UserArtInfo vibes(List<String>? vibes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserArtInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserArtInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  UserArtInfo call({
    String? aboutYou,
    String? spaces,
    String? audience,
    List<String>? vibes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserArtInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserArtInfo.copyWith.fieldName(...)`
class _$UserArtInfoCWProxyImpl implements _$UserArtInfoCWProxy {
  const _$UserArtInfoCWProxyImpl(this._value);

  final UserArtInfo _value;

  @override
  UserArtInfo aboutYou(String? aboutYou) => this(aboutYou: aboutYou);

  @override
  UserArtInfo spaces(String? spaces) => this(spaces: spaces);

  @override
  UserArtInfo audience(String? audience) => this(audience: audience);

  @override
  UserArtInfo vibes(List<String>? vibes) => this(vibes: vibes);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserArtInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserArtInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  UserArtInfo call({
    Object? aboutYou = const $CopyWithPlaceholder(),
    Object? spaces = const $CopyWithPlaceholder(),
    Object? audience = const $CopyWithPlaceholder(),
    Object? vibes = const $CopyWithPlaceholder(),
  }) {
    return UserArtInfo(
      aboutYou: aboutYou == const $CopyWithPlaceholder()
          ? _value.aboutYou
          // ignore: cast_nullable_to_non_nullable
          : aboutYou as String?,
      spaces: spaces == const $CopyWithPlaceholder()
          ? _value.spaces
          // ignore: cast_nullable_to_non_nullable
          : spaces as String?,
      audience: audience == const $CopyWithPlaceholder()
          ? _value.audience
          // ignore: cast_nullable_to_non_nullable
          : audience as String?,
      vibes: vibes == const $CopyWithPlaceholder()
          ? _value.vibes
          // ignore: cast_nullable_to_non_nullable
          : vibes as List<String>?,
    );
  }
}

extension $UserArtInfoCopyWith on UserArtInfo {
  /// Returns a callable class that can be used as follows: `instanceOfUserArtInfo.copyWith(...)` or like so:`instanceOfUserArtInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserArtInfoCWProxy get copyWith => _$UserArtInfoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserArtInfo _$UserArtInfoFromJson(Map<String, dynamic> json) => UserArtInfo(
      aboutYou: json['aboutYou'] as String?,
      spaces: json['spaces'] as String?,
      audience: json['audience'] as String?,
      vibes:
          (json['vibes'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserArtInfoToJson(UserArtInfo instance) =>
    <String, dynamic>{
      'aboutYou': instance.aboutYou,
      'spaces': instance.spaces,
      'audience': instance.audience,
      'vibes': instance.vibes,
    };
