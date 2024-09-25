// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PayoutCWProxy {
  Payout payoutStatus(PayoutStatus? payoutStatus);

  Payout createdAt(DateTime? createdAt);

  Payout userId(String? userId);

  Payout sourceAmount(double? sourceAmount);

  Payout totalFee(double? totalFee);

  Payout targetAmount(double? targetAmount);

  Payout targetCurrency(String? targetCurrency);

  Payout transferId(int? transferId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Payout(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Payout(...).copyWith(id: 12, name: "My name")
  /// ````
  Payout call({
    PayoutStatus? payoutStatus,
    DateTime? createdAt,
    String? userId,
    double? sourceAmount,
    double? totalFee,
    double? targetAmount,
    String? targetCurrency,
    int? transferId,
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
  Payout createdAt(DateTime? createdAt) => this(createdAt: createdAt);

  @override
  Payout userId(String? userId) => this(userId: userId);

  @override
  Payout sourceAmount(double? sourceAmount) => this(sourceAmount: sourceAmount);

  @override
  Payout totalFee(double? totalFee) => this(totalFee: totalFee);

  @override
  Payout targetAmount(double? targetAmount) => this(targetAmount: targetAmount);

  @override
  Payout targetCurrency(String? targetCurrency) =>
      this(targetCurrency: targetCurrency);

  @override
  Payout transferId(int? transferId) => this(transferId: transferId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Payout(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Payout(...).copyWith(id: 12, name: "My name")
  /// ````
  Payout call({
    Object? payoutStatus = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? userId = const $CopyWithPlaceholder(),
    Object? sourceAmount = const $CopyWithPlaceholder(),
    Object? totalFee = const $CopyWithPlaceholder(),
    Object? targetAmount = const $CopyWithPlaceholder(),
    Object? targetCurrency = const $CopyWithPlaceholder(),
    Object? transferId = const $CopyWithPlaceholder(),
  }) {
    return Payout(
      payoutStatus == const $CopyWithPlaceholder()
          ? _value.payoutStatus
          // ignore: cast_nullable_to_non_nullable
          : payoutStatus as PayoutStatus?,
      createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as String?,
      sourceAmount == const $CopyWithPlaceholder()
          ? _value.sourceAmount
          // ignore: cast_nullable_to_non_nullable
          : sourceAmount as double?,
      totalFee == const $CopyWithPlaceholder()
          ? _value.totalFee
          // ignore: cast_nullable_to_non_nullable
          : totalFee as double?,
      targetAmount == const $CopyWithPlaceholder()
          ? _value.targetAmount
          // ignore: cast_nullable_to_non_nullable
          : targetAmount as double?,
      targetCurrency == const $CopyWithPlaceholder()
          ? _value.targetCurrency
          // ignore: cast_nullable_to_non_nullable
          : targetCurrency as String?,
      transferId == const $CopyWithPlaceholder()
          ? _value.transferId
          // ignore: cast_nullable_to_non_nullable
          : transferId as int?,
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
              unknownValue: PayoutStatus.initialised) ??
          PayoutStatus.initialised,
      _$JsonConverterFromJson<Timestamp, DateTime>(
          json['createdAt'], const TimestampConverter().fromJson),
      json['userId'] as String?,
      (json['sourceAmount'] as num?)?.toDouble(),
      (json['totalFee'] as num?)?.toDouble(),
      (json['targetAmount'] as num?)?.toDouble(),
      json['targetCurrency'] as String?,
      (json['transferId'] as num?)?.toInt(),
    )
      ..quoteId = json['quoteId'] as String?
      ..customerTransactionId = json['customerTransactionId'] as String?;

Map<String, dynamic> _$PayoutToJson(Payout instance) => <String, dynamic>{
      'payoutStatus': _$PayoutStatusEnumMap[instance.payoutStatus],
      'createdAt': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.createdAt, const TimestampConverter().toJson),
      'userId': instance.userId,
      'sourceAmount': instance.sourceAmount,
      'totalFee': instance.totalFee,
      'targetAmount': instance.targetAmount,
      'targetCurrency': instance.targetCurrency,
      'transferId': instance.transferId,
      'quoteId': instance.quoteId,
      'customerTransactionId': instance.customerTransactionId,
    };

const _$PayoutStatusEnumMap = {
  PayoutStatus.initialised: 0,
  PayoutStatus.onProgress: 1,
  PayoutStatus.completed: 2,
  PayoutStatus.failed: 4,
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
