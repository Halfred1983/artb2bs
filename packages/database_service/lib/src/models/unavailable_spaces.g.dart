// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unavailable_spaces.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UnavailableSpacesCWProxy {
  UnavailableSpaces from(DateTime? from);

  UnavailableSpaces to(DateTime? to);

  UnavailableSpaces spaces(String? spaces);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UnavailableSpaces(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UnavailableSpaces(...).copyWith(id: 12, name: "My name")
  /// ````
  UnavailableSpaces call({
    DateTime? from,
    DateTime? to,
    String? spaces,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUnavailableSpaces.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUnavailableSpaces.copyWith.fieldName(...)`
class _$UnavailableSpacesCWProxyImpl implements _$UnavailableSpacesCWProxy {
  const _$UnavailableSpacesCWProxyImpl(this._value);

  final UnavailableSpaces _value;

  @override
  UnavailableSpaces from(DateTime? from) => this(from: from);

  @override
  UnavailableSpaces to(DateTime? to) => this(to: to);

  @override
  UnavailableSpaces spaces(String? spaces) => this(spaces: spaces);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UnavailableSpaces(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UnavailableSpaces(...).copyWith(id: 12, name: "My name")
  /// ````
  UnavailableSpaces call({
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? spaces = const $CopyWithPlaceholder(),
  }) {
    return UnavailableSpaces(
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as DateTime?,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as DateTime?,
      spaces: spaces == const $CopyWithPlaceholder()
          ? _value.spaces
          // ignore: cast_nullable_to_non_nullable
          : spaces as String?,
    );
  }
}

extension $UnavailableSpacesCopyWith on UnavailableSpaces {
  /// Returns a callable class that can be used as follows: `instanceOfUnavailableSpaces.copyWith(...)` or like so:`instanceOfUnavailableSpaces.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UnavailableSpacesCWProxy get copyWith =>
      _$UnavailableSpacesCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnavailableSpaces _$UnavailableSpacesFromJson(Map<String, dynamic> json) =>
    UnavailableSpaces(
      from: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['from'], const TimestampConverter().fromJson),
      to: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['to'], const TimestampConverter().fromJson),
      spaces: json['spaces'] as String?,
    );

Map<String, dynamic> _$UnavailableSpacesToJson(UnavailableSpaces instance) =>
    <String, dynamic>{
      'from': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.from, const TimestampConverter().toJson),
      'to': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.to, const TimestampConverter().toJson),
      'spaces': instance.spaces,
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
