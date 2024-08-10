// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VenueInfoCWProxy {
  VenueInfo aboutYou(String? aboutYou);

  VenueInfo spaces(String? spaces);

  VenueInfo audience(String? audience);

  VenueInfo vibes(List<String>? vibes);

  VenueInfo openingTimes(List<BusinessDay>? openingTimes);

  VenueInfo typeOfVenue(List<String>? typeOfVenue);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VenueInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VenueInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  VenueInfo call({
    String? aboutYou,
    String? spaces,
    String? audience,
    List<String>? vibes,
    List<BusinessDay>? openingTimes,
    List<String>? typeOfVenue,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVenueInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVenueInfo.copyWith.fieldName(...)`
class _$VenueInfoCWProxyImpl implements _$VenueInfoCWProxy {
  const _$VenueInfoCWProxyImpl(this._value);

  final VenueInfo _value;

  @override
  VenueInfo aboutYou(String? aboutYou) => this(aboutYou: aboutYou);

  @override
  VenueInfo spaces(String? spaces) => this(spaces: spaces);

  @override
  VenueInfo audience(String? audience) => this(audience: audience);

  @override
  VenueInfo vibes(List<String>? vibes) => this(vibes: vibes);

  @override
  VenueInfo openingTimes(List<BusinessDay>? openingTimes) =>
      this(openingTimes: openingTimes);

  @override
  VenueInfo typeOfVenue(List<String>? typeOfVenue) =>
      this(typeOfVenue: typeOfVenue);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VenueInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VenueInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  VenueInfo call({
    Object? aboutYou = const $CopyWithPlaceholder(),
    Object? spaces = const $CopyWithPlaceholder(),
    Object? audience = const $CopyWithPlaceholder(),
    Object? vibes = const $CopyWithPlaceholder(),
    Object? openingTimes = const $CopyWithPlaceholder(),
    Object? typeOfVenue = const $CopyWithPlaceholder(),
  }) {
    return VenueInfo(
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
      openingTimes: openingTimes == const $CopyWithPlaceholder()
          ? _value.openingTimes
          // ignore: cast_nullable_to_non_nullable
          : openingTimes as List<BusinessDay>?,
      typeOfVenue: typeOfVenue == const $CopyWithPlaceholder()
          ? _value.typeOfVenue
          // ignore: cast_nullable_to_non_nullable
          : typeOfVenue as List<String>?,
    );
  }
}

extension $VenueInfoCopyWith on VenueInfo {
  /// Returns a callable class that can be used as follows: `instanceOfVenueInfo.copyWith(...)` or like so:`instanceOfVenueInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VenueInfoCWProxy get copyWith => _$VenueInfoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueInfo _$VenueInfoFromJson(Map<String, dynamic> json) => VenueInfo(
      aboutYou: json['aboutYou'] as String?,
      spaces: json['spaces'] as String?,
      audience: json['audience'] as String?,
      vibes:
          (json['vibes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      openingTimes: (json['openingTimes'] as List<dynamic>?)
          ?.map((e) => BusinessDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      typeOfVenue: (json['typeOfVenue'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$VenueInfoToJson(VenueInfo instance) => <String, dynamic>{
      'aboutYou': instance.aboutYou,
      'spaces': instance.spaces,
      'audience': instance.audience,
      'vibes': instance.vibes,
      'openingTimes': instance.openingTimes?.map((e) => e.toJson()).toList(),
      'typeOfVenue': instance.typeOfVenue,
    };
