// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accepted.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AcceptedCWProxy {
  Accepted hostId(String? hostId);

  Accepted artistId(String? artistId);

  Accepted bookingId(String? bookingId);

  Accepted acceptedTimestamp(DateTime? acceptedTimestamp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Accepted(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Accepted(...).copyWith(id: 12, name: "My name")
  /// ````
  Accepted call({
    String? hostId,
    String? artistId,
    String? bookingId,
    DateTime? acceptedTimestamp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAccepted.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAccepted.copyWith.fieldName(...)`
class _$AcceptedCWProxyImpl implements _$AcceptedCWProxy {
  const _$AcceptedCWProxyImpl(this._value);

  final Accepted _value;

  @override
  Accepted hostId(String? hostId) => this(hostId: hostId);

  @override
  Accepted artistId(String? artistId) => this(artistId: artistId);

  @override
  Accepted bookingId(String? bookingId) => this(bookingId: bookingId);

  @override
  Accepted acceptedTimestamp(DateTime? acceptedTimestamp) =>
      this(acceptedTimestamp: acceptedTimestamp);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Accepted(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Accepted(...).copyWith(id: 12, name: "My name")
  /// ````
  Accepted call({
    Object? hostId = const $CopyWithPlaceholder(),
    Object? artistId = const $CopyWithPlaceholder(),
    Object? bookingId = const $CopyWithPlaceholder(),
    Object? acceptedTimestamp = const $CopyWithPlaceholder(),
  }) {
    return Accepted(
      hostId: hostId == const $CopyWithPlaceholder()
          ? _value.hostId
          // ignore: cast_nullable_to_non_nullable
          : hostId as String?,
      artistId: artistId == const $CopyWithPlaceholder()
          ? _value.artistId
          // ignore: cast_nullable_to_non_nullable
          : artistId as String?,
      bookingId: bookingId == const $CopyWithPlaceholder()
          ? _value.bookingId
          // ignore: cast_nullable_to_non_nullable
          : bookingId as String?,
      acceptedTimestamp: acceptedTimestamp == const $CopyWithPlaceholder()
          ? _value.acceptedTimestamp
          // ignore: cast_nullable_to_non_nullable
          : acceptedTimestamp as DateTime?,
    );
  }
}

extension $AcceptedCopyWith on Accepted {
  /// Returns a callable class that can be used as follows: `instanceOfAccepted.copyWith(...)` or like so:`instanceOfAccepted.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AcceptedCWProxy get copyWith => _$AcceptedCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Accepted _$AcceptedFromJson(Map<String, dynamic> json) => Accepted(
      hostId: json['hostId'] as String?,
      artistId: json['artistId'] as String?,
      bookingId: json['bookingId'] as String?,
      acceptedTimestamp: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['acceptedTimestamp'], const TimestampConverter().fromJson),
    );

Map<String, dynamic> _$AcceptedToJson(Accepted instance) => <String, dynamic>{
      'bookingId': instance.bookingId,
      'hostId': instance.hostId,
      'artistId': instance.artistId,
      'acceptedTimestamp': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.acceptedTimestamp, const TimestampConverter().toJson),
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
