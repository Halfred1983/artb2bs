// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_address.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserAddressCWProxy {
  UserAddress address(String address);

  UserAddress place(String place);

  UserAddress province(String province);

  UserAddress city(String city);

  UserAddress zipcode(String zipcode);

  UserAddress country(String country);

  UserAddress locale(String locale);

  UserAddress currencyCode(String currencyCode);

  UserAddress number(String number);

  UserAddress aptBuilding(String? aptBuilding);

  UserAddress formattedAddress(String formattedAddress);

  UserAddress location(Geo? location);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserAddress(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserAddress(...).copyWith(id: 12, name: "My name")
  /// ````
  UserAddress call({
    String? address,
    String? place,
    String? province,
    String? city,
    String? zipcode,
    String? country,
    String? locale,
    String? currencyCode,
    String? number,
    String? aptBuilding,
    String? formattedAddress,
    Geo? location,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserAddress.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserAddress.copyWith.fieldName(...)`
class _$UserAddressCWProxyImpl implements _$UserAddressCWProxy {
  const _$UserAddressCWProxyImpl(this._value);

  final UserAddress _value;

  @override
  UserAddress address(String address) => this(address: address);

  @override
  UserAddress place(String place) => this(place: place);

  @override
  UserAddress province(String province) => this(province: province);

  @override
  UserAddress city(String city) => this(city: city);

  @override
  UserAddress zipcode(String zipcode) => this(zipcode: zipcode);

  @override
  UserAddress country(String country) => this(country: country);

  @override
  UserAddress locale(String locale) => this(locale: locale);

  @override
  UserAddress currencyCode(String currencyCode) =>
      this(currencyCode: currencyCode);

  @override
  UserAddress number(String number) => this(number: number);

  @override
  UserAddress aptBuilding(String? aptBuilding) =>
      this(aptBuilding: aptBuilding);

  @override
  UserAddress formattedAddress(String formattedAddress) =>
      this(formattedAddress: formattedAddress);

  @override
  UserAddress location(Geo? location) => this(location: location);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserAddress(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserAddress(...).copyWith(id: 12, name: "My name")
  /// ````
  UserAddress call({
    Object? address = const $CopyWithPlaceholder(),
    Object? place = const $CopyWithPlaceholder(),
    Object? province = const $CopyWithPlaceholder(),
    Object? city = const $CopyWithPlaceholder(),
    Object? zipcode = const $CopyWithPlaceholder(),
    Object? country = const $CopyWithPlaceholder(),
    Object? locale = const $CopyWithPlaceholder(),
    Object? currencyCode = const $CopyWithPlaceholder(),
    Object? number = const $CopyWithPlaceholder(),
    Object? aptBuilding = const $CopyWithPlaceholder(),
    Object? formattedAddress = const $CopyWithPlaceholder(),
    Object? location = const $CopyWithPlaceholder(),
  }) {
    return UserAddress(
      address: address == const $CopyWithPlaceholder() || address == null
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String,
      place: place == const $CopyWithPlaceholder() || place == null
          ? _value.place
          // ignore: cast_nullable_to_non_nullable
          : place as String,
      province: province == const $CopyWithPlaceholder() || province == null
          ? _value.province
          // ignore: cast_nullable_to_non_nullable
          : province as String,
      city: city == const $CopyWithPlaceholder() || city == null
          ? _value.city
          // ignore: cast_nullable_to_non_nullable
          : city as String,
      zipcode: zipcode == const $CopyWithPlaceholder() || zipcode == null
          ? _value.zipcode
          // ignore: cast_nullable_to_non_nullable
          : zipcode as String,
      country: country == const $CopyWithPlaceholder() || country == null
          ? _value.country
          // ignore: cast_nullable_to_non_nullable
          : country as String,
      locale: locale == const $CopyWithPlaceholder() || locale == null
          ? _value.locale
          // ignore: cast_nullable_to_non_nullable
          : locale as String,
      currencyCode:
          currencyCode == const $CopyWithPlaceholder() || currencyCode == null
              ? _value.currencyCode
              // ignore: cast_nullable_to_non_nullable
              : currencyCode as String,
      number: number == const $CopyWithPlaceholder() || number == null
          ? _value.number
          // ignore: cast_nullable_to_non_nullable
          : number as String,
      aptBuilding: aptBuilding == const $CopyWithPlaceholder()
          ? _value.aptBuilding
          // ignore: cast_nullable_to_non_nullable
          : aptBuilding as String?,
      formattedAddress: formattedAddress == const $CopyWithPlaceholder() ||
              formattedAddress == null
          ? _value.formattedAddress
          // ignore: cast_nullable_to_non_nullable
          : formattedAddress as String,
      location: location == const $CopyWithPlaceholder()
          ? _value.location
          // ignore: cast_nullable_to_non_nullable
          : location as Geo?,
    );
  }
}

extension $UserAddressCopyWith on UserAddress {
  /// Returns a callable class that can be used as follows: `instanceOfUserAddress.copyWith(...)` or like so:`instanceOfUserAddress.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserAddressCWProxy get copyWith => _$UserAddressCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAddress _$UserAddressFromJson(Map<String, dynamic> json) => UserAddress(
      address: json['address'] as String,
      place: json['place'] as String,
      province: json['province'] as String,
      city: json['city'] as String,
      zipcode: json['zipcode'] as String,
      country: json['country'] as String,
      locale: json['locale'] as String,
      currencyCode: json['currencyCode'] as String,
      number: json['number'] as String,
      aptBuilding: json['aptBuilding'] as String?,
      formattedAddress: json['formattedAddress'] as String,
      location: UserAddress._fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserAddressToJson(UserAddress instance) =>
    <String, dynamic>{
      'address': instance.address,
      'place': instance.place,
      'province': instance.province,
      'city': instance.city,
      'zipcode': instance.zipcode,
      'country': instance.country,
      'locale': instance.locale,
      'currencyCode': instance.currencyCode,
      'number': instance.number,
      'aptBuilding': instance.aptBuilding,
      'formattedAddress': instance.formattedAddress,
      'location': UserAddress._toJson(instance.location),
    };
