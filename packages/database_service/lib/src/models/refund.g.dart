// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RefundCWProxy {
  Refund refundStatus(RefundStatus? refundStatus);

  Refund refundId(String? refundId);

  Refund bookingId(String? bookingId);

  Refund paymentIntentId(String? paymentIntentId);

  Refund artistId(String? artistId);

  Refund hostId(String? hostId);

  Refund refundTimestamp(DateTime? refundTimestamp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Refund(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Refund(...).copyWith(id: 12, name: "My name")
  /// ````
  Refund call({
    RefundStatus? refundStatus,
    String? refundId,
    String? bookingId,
    String? paymentIntentId,
    String? artistId,
    String? hostId,
    DateTime? refundTimestamp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRefund.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRefund.copyWith.fieldName(...)`
class _$RefundCWProxyImpl implements _$RefundCWProxy {
  const _$RefundCWProxyImpl(this._value);

  final Refund _value;

  @override
  Refund refundStatus(RefundStatus? refundStatus) =>
      this(refundStatus: refundStatus);

  @override
  Refund refundId(String? refundId) => this(refundId: refundId);

  @override
  Refund bookingId(String? bookingId) => this(bookingId: bookingId);

  @override
  Refund paymentIntentId(String? paymentIntentId) =>
      this(paymentIntentId: paymentIntentId);

  @override
  Refund artistId(String? artistId) => this(artistId: artistId);

  @override
  Refund hostId(String? hostId) => this(hostId: hostId);

  @override
  Refund refundTimestamp(DateTime? refundTimestamp) =>
      this(refundTimestamp: refundTimestamp);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Refund(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Refund(...).copyWith(id: 12, name: "My name")
  /// ````
  Refund call({
    Object? refundStatus = const $CopyWithPlaceholder(),
    Object? refundId = const $CopyWithPlaceholder(),
    Object? bookingId = const $CopyWithPlaceholder(),
    Object? paymentIntentId = const $CopyWithPlaceholder(),
    Object? artistId = const $CopyWithPlaceholder(),
    Object? hostId = const $CopyWithPlaceholder(),
    Object? refundTimestamp = const $CopyWithPlaceholder(),
  }) {
    return Refund(
      refundStatus: refundStatus == const $CopyWithPlaceholder()
          ? _value.refundStatus
          // ignore: cast_nullable_to_non_nullable
          : refundStatus as RefundStatus?,
      refundId: refundId == const $CopyWithPlaceholder()
          ? _value.refundId
          // ignore: cast_nullable_to_non_nullable
          : refundId as String?,
      bookingId: bookingId == const $CopyWithPlaceholder()
          ? _value.bookingId
          // ignore: cast_nullable_to_non_nullable
          : bookingId as String?,
      paymentIntentId: paymentIntentId == const $CopyWithPlaceholder()
          ? _value.paymentIntentId
          // ignore: cast_nullable_to_non_nullable
          : paymentIntentId as String?,
      artistId: artistId == const $CopyWithPlaceholder()
          ? _value.artistId
          // ignore: cast_nullable_to_non_nullable
          : artistId as String?,
      hostId: hostId == const $CopyWithPlaceholder()
          ? _value.hostId
          // ignore: cast_nullable_to_non_nullable
          : hostId as String?,
      refundTimestamp: refundTimestamp == const $CopyWithPlaceholder()
          ? _value.refundTimestamp
          // ignore: cast_nullable_to_non_nullable
          : refundTimestamp as DateTime?,
    );
  }
}

extension $RefundCopyWith on Refund {
  /// Returns a callable class that can be used as follows: `instanceOfRefund.copyWith(...)` or like so:`instanceOfRefund.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RefundCWProxy get copyWith => _$RefundCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Refund _$RefundFromJson(Map<String, dynamic> json) => Refund(
      refundStatus: $enumDecodeNullable(
              _$RefundStatusEnumMap, json['refundStatus'],
              unknownValue: RefundStatus.pending) ??
          RefundStatus.pending,
      refundId: json['refundId'] as String?,
      bookingId: json['bookingId'] as String?,
      paymentIntentId: json['paymentIntentId'] as String?,
      artistId: json['artistId'] as String?,
      hostId: json['hostId'] as String?,
      refundTimestamp: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['refundTimestamp'], const TimestampConverter().fromJson),
    );

Map<String, dynamic> _$RefundToJson(Refund instance) => <String, dynamic>{
      'refundStatus': _$RefundStatusEnumMap[instance.refundStatus],
      'refundId': instance.refundId,
      'bookingId': instance.bookingId,
      'paymentIntentId': instance.paymentIntentId,
      'artistId': instance.artistId,
      'hostId': instance.hostId,
      'refundTimestamp': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.refundTimestamp, const TimestampConverter().toJson),
    };

const _$RefundStatusEnumMap = {
  RefundStatus.pending: 0,
  RefundStatus.completed: 1,
  RefundStatus.failed: 2,
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
