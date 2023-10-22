// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unavailable.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UnavailableCWProxy {
  Unavailable from(DateTime? from);

  Unavailable to(DateTime? to);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Unavailable(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Unavailable(...).copyWith(id: 12, name: "My name")
  /// ````
  Unavailable call({
    DateTime? from,
    DateTime? to,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUnavailable.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUnavailable.copyWith.fieldName(...)`
class _$UnavailableCWProxyImpl implements _$UnavailableCWProxy {
  const _$UnavailableCWProxyImpl(this._value);

  final Unavailable _value;

  @override
  Unavailable from(DateTime? from) => this(from: from);

  @override
  Unavailable to(DateTime? to) => this(to: to);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Unavailable(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Unavailable(...).copyWith(id: 12, name: "My name")
  /// ````
  Unavailable call({
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
  }) {
    return Unavailable(
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as DateTime?,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as DateTime?,
    );
  }
}

extension $UnavailableCopyWith on Unavailable {
  /// Returns a callable class that can be used as follows: `instanceOfUnavailable.copyWith(...)` or like so:`instanceOfUnavailable.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UnavailableCWProxy get copyWith => _$UnavailableCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Unavailable _$UnavailableFromJson(Map<String, dynamic> json) => Unavailable(
      from: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['from'], const TimestampConverter().fromJson),
      to: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['to'], const TimestampConverter().fromJson),
    );

Map<String, dynamic> _$UnavailableToJson(Unavailable instance) =>
    <String, dynamic>{
      'from': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.from, const TimestampConverter().toJson),
      'to': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.to, const TimestampConverter().toJson),
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
