// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PayoutInfoCWProxy {
  PayoutInfo bankCountry(String? bankCountry);

  PayoutInfo bankCountryCode(String? bankCountryCode);

  PayoutInfo currency(String? currency);

  PayoutInfo accountHolder(String? accountHolder);

  PayoutInfo iban(String? iban);

  PayoutInfo customerId(String? customerId);

  PayoutInfo bankAccountId(int? bankAccountId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PayoutInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PayoutInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  PayoutInfo call({
    String? bankCountry,
    String? bankCountryCode,
    String? currency,
    String? accountHolder,
    String? iban,
    String? customerId,
    int? bankAccountId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPayoutInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPayoutInfo.copyWith.fieldName(...)`
class _$PayoutInfoCWProxyImpl implements _$PayoutInfoCWProxy {
  const _$PayoutInfoCWProxyImpl(this._value);

  final PayoutInfo _value;

  @override
  PayoutInfo bankCountry(String? bankCountry) => this(bankCountry: bankCountry);

  @override
  PayoutInfo bankCountryCode(String? bankCountryCode) =>
      this(bankCountryCode: bankCountryCode);

  @override
  PayoutInfo currency(String? currency) => this(currency: currency);

  @override
  PayoutInfo accountHolder(String? accountHolder) =>
      this(accountHolder: accountHolder);

  @override
  PayoutInfo iban(String? iban) => this(iban: iban);

  @override
  PayoutInfo customerId(String? customerId) => this(customerId: customerId);

  @override
  PayoutInfo bankAccountId(int? bankAccountId) =>
      this(bankAccountId: bankAccountId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PayoutInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PayoutInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  PayoutInfo call({
    Object? bankCountry = const $CopyWithPlaceholder(),
    Object? bankCountryCode = const $CopyWithPlaceholder(),
    Object? currency = const $CopyWithPlaceholder(),
    Object? accountHolder = const $CopyWithPlaceholder(),
    Object? iban = const $CopyWithPlaceholder(),
    Object? customerId = const $CopyWithPlaceholder(),
    Object? bankAccountId = const $CopyWithPlaceholder(),
  }) {
    return PayoutInfo(
      bankCountry: bankCountry == const $CopyWithPlaceholder()
          ? _value.bankCountry
          // ignore: cast_nullable_to_non_nullable
          : bankCountry as String?,
      bankCountryCode: bankCountryCode == const $CopyWithPlaceholder()
          ? _value.bankCountryCode
          // ignore: cast_nullable_to_non_nullable
          : bankCountryCode as String?,
      currency: currency == const $CopyWithPlaceholder()
          ? _value.currency
          // ignore: cast_nullable_to_non_nullable
          : currency as String?,
      accountHolder: accountHolder == const $CopyWithPlaceholder()
          ? _value.accountHolder
          // ignore: cast_nullable_to_non_nullable
          : accountHolder as String?,
      iban: iban == const $CopyWithPlaceholder()
          ? _value.iban
          // ignore: cast_nullable_to_non_nullable
          : iban as String?,
      customerId: customerId == const $CopyWithPlaceholder()
          ? _value.customerId
          // ignore: cast_nullable_to_non_nullable
          : customerId as String?,
      bankAccountId: bankAccountId == const $CopyWithPlaceholder()
          ? _value.bankAccountId
          // ignore: cast_nullable_to_non_nullable
          : bankAccountId as int?,
    );
  }
}

extension $PayoutInfoCopyWith on PayoutInfo {
  /// Returns a callable class that can be used as follows: `instanceOfPayoutInfo.copyWith(...)` or like so:`instanceOfPayoutInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PayoutInfoCWProxy get copyWith => _$PayoutInfoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayoutInfo _$PayoutInfoFromJson(Map<String, dynamic> json) => PayoutInfo(
      bankCountry: json['bankCountry'] as String?,
      bankCountryCode: json['bankCountryCode'] as String?,
      currency: json['currency'] as String?,
      accountHolder: json['accountHolder'] as String?,
      iban: json['iban'] as String?,
      customerId: json['customerId'] as String?,
      bankAccountId: (json['bankAccountId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PayoutInfoToJson(PayoutInfo instance) =>
    <String, dynamic>{
      'bankCountry': instance.bankCountry,
      'bankCountryCode': instance.bankCountryCode,
      'currency': instance.currency,
      'accountHolder': instance.accountHolder,
      'iban': instance.iban,
      'customerId': instance.customerId,
      'bankAccountId': instance.bankAccountId,
    };
