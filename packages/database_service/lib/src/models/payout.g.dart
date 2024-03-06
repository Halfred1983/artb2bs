// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PayoutCWProxy {
  Payout payoutStatus(PayoutStatus? payoutStatus);

  Payout timestamp(DateTime? timestamp);

  Payout userId(String? userId);

  Payout amount(int? amount);

  Payout currency(String? currency);

  Payout paypalAccount(String? paypalAccount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Payout(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Payout(...).copyWith(id: 12, name: "My name")
  /// ````
  Payout call({
    PayoutStatus? payoutStatus,
    DateTime? timestamp,
    String? userId,
    int? amount,
    String? currency,
    String? paypalAccount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPayout.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPayout.copyWith.fieldName(...)`
class _$PayoutCWProxyImpl implements _$PayoutCWProxy {
  const _$PayoutCWProxyImpl(this._value);

  final Payout _value;

  @override
  Payout payoutStatus(PayoutStatus? payoutStatus) =>
      this(payoutStatus: payoutStatus);

  @override
  Payout timestamp(DateTime? timestamp) => this(timestamp: timestamp);

  @override
  Payout userId(String? userId) => this(userId: userId);

  @override
  Payout amount(int? amount) => this(amount: amount);

  @override
  Payout currency(String? currency) => this(currency: currency);

  @override
  Payout paypalAccount(String? paypalAccount) =>
      this(paypalAccount: paypalAccount);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Payout(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Payout(...).copyWith(id: 12, name: "My name")
  /// ````
  Payout call({
    Object? payoutStatus = const $CopyWithPlaceholder(),
    Object? timestamp = const $CopyWithPlaceholder(),
    Object? userId = const $CopyWithPlaceholder(),
    Object? amount = const $CopyWithPlaceholder(),
    Object? currency = const $CopyWithPlaceholder(),
    Object? paypalAccount = const $CopyWithPlaceholder(),
  }) {
    return Payout(
      payoutStatus == const $CopyWithPlaceholder()
          ? _value.payoutStatus
          // ignore: cast_nullable_to_non_nullable
          : payoutStatus as PayoutStatus?,
      timestamp == const $CopyWithPlaceholder()
          ? _value.timestamp
          // ignore: cast_nullable_to_non_nullable
          : timestamp as DateTime?,
      userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as String?,
      amount == const $CopyWithPlaceholder()
          ? _value.amount
          // ignore: cast_nullable_to_non_nullable
          : amount as int?,
      currency == const $CopyWithPlaceholder()
          ? _value.currency
          // ignore: cast_nullable_to_non_nullable
          : currency as String?,
      paypalAccount == const $CopyWithPlaceholder()
          ? _value.paypalAccount
          // ignore: cast_nullable_to_non_nullable
          : paypalAccount as String?,
    );
  }
}

extension $PayoutCopyWith on Payout {
  /// Returns a callable class that can be used as follows: `instanceOfPayout.copyWith(...)` or like so:`instanceOfPayout.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PayoutCWProxy get copyWith => _$PayoutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payout _$PayoutFromJson(Map<String, dynamic> json) => Payout(
      $enumDecodeNullable(_$PayoutStatusEnumMap, json['payoutStatus'],
              unknownValue: PayoutStatus.unknown) ??
          PayoutStatus.unknown,
      _$JsonConverterFromJson<Timestamp, DateTime>(
          json['timestamp'], const TimestampConverter().fromJson),
      json['userId'] as String?,
      json['amount'] as int?,
      json['currency'] as String?,
      json['paypalAccount'] as String?,
    );

Map<String, dynamic> _$PayoutToJson(Payout instance) => <String, dynamic>{
      'payoutStatus': _$PayoutStatusEnumMap[instance.payoutStatus],
      'timestamp': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.timestamp, const TimestampConverter().toJson),
      'userId': instance.userId,
      'amount': instance.amount,
      'currency': instance.currency,
      'paypalAccount': instance.paypalAccount,
    };

const _$PayoutStatusEnumMap = {
  PayoutStatus.success: 0,
  PayoutStatus.failed: 1,
  PayoutStatus.unknown: 2,
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
