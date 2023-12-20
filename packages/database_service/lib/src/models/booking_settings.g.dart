// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_settings.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingSettingsCWProxy {
  BookingSettings basePrice(String? basePrice);

  BookingSettings minLength(String? minLength);

  BookingSettings minSpaces(String? minSpaces);

  BookingSettings paypalAccount(String? paypalAccount);

  BookingSettings active(bool? active);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingSettings call({
    String? basePrice,
    String? minLength,
    String? minSpaces,
    String? paypalAccount,
    bool? active,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingSettings.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingSettings.copyWith.fieldName(...)`
class _$BookingSettingsCWProxyImpl implements _$BookingSettingsCWProxy {
  const _$BookingSettingsCWProxyImpl(this._value);

  final BookingSettings _value;

  @override
  BookingSettings basePrice(String? basePrice) => this(basePrice: basePrice);

  @override
  BookingSettings minLength(String? minLength) => this(minLength: minLength);

  @override
  BookingSettings minSpaces(String? minSpaces) => this(minSpaces: minSpaces);

  @override
  BookingSettings paypalAccount(String? paypalAccount) =>
      this(paypalAccount: paypalAccount);

  @override
  BookingSettings active(bool? active) => this(active: active);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingSettings call({
    Object? basePrice = const $CopyWithPlaceholder(),
    Object? minLength = const $CopyWithPlaceholder(),
    Object? minSpaces = const $CopyWithPlaceholder(),
    Object? paypalAccount = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
  }) {
    return BookingSettings(
      basePrice: basePrice == const $CopyWithPlaceholder()
          ? _value.basePrice
          // ignore: cast_nullable_to_non_nullable
          : basePrice as String?,
      minLength: minLength == const $CopyWithPlaceholder()
          ? _value.minLength
          // ignore: cast_nullable_to_non_nullable
          : minLength as String?,
      minSpaces: minSpaces == const $CopyWithPlaceholder()
          ? _value.minSpaces
          // ignore: cast_nullable_to_non_nullable
          : minSpaces as String?,
      paypalAccount: paypalAccount == const $CopyWithPlaceholder()
          ? _value.paypalAccount
          // ignore: cast_nullable_to_non_nullable
          : paypalAccount as String?,
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool?,
    );
  }
}

extension $BookingSettingsCopyWith on BookingSettings {
  /// Returns a callable class that can be used as follows: `instanceOfBookingSettings.copyWith(...)` or like so:`instanceOfBookingSettings.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingSettingsCWProxy get copyWith => _$BookingSettingsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingSettings _$BookingSettingsFromJson(Map<String, dynamic> json) =>
    BookingSettings(
      basePrice: json['basePrice'] as String?,
      minLength: json['minLength'] as String?,
      minSpaces: json['minSpaces'] as String?,
      paypalAccount: json['paypalAccount'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$BookingSettingsToJson(BookingSettings instance) =>
    <String, dynamic>{
      'basePrice': instance.basePrice,
      'minLength': instance.minLength,
      'minSpaces': instance.minSpaces,
      'paypalAccount': instance.paypalAccount,
      'active': instance.active,
    };
