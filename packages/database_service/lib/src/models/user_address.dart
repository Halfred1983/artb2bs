
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'user_address.g.dart';

@JsonSerializable()
@CopyWith()
class UserAddress {
  final String address;
  final String place;
  final String province;
  final String city;
  final String zipcode;
  final String country;
  final String locale;
  final String currencyCode;
  final String number;
  final String formattedAddress;
  @JsonKey(
      fromJson: _fromJson,
      toJson: _toJson)
  GeoFirePoint? location;

  UserAddress({
    required this.address,
    required this.place,
    required this.province,
    required this.city,
    required this.zipcode,
    required this.country,
    required this.locale,
    required this.currencyCode,
    required this.number,
    required this.formattedAddress,
    this.location
  });

  factory UserAddress.fromJson(Map<String, dynamic?> json)
  => _$UserAddressFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddressToJson(this);

  static GeoFirePoint? _fromJson(Map<String, dynamic> location) {
    try {
      return GeoFirePoint(
          location['geopoint']['latitude'], location['geopoint']['longitude']);
    }
    catch (e){
      return GeoFirePoint(location['geopoint'].latitude, location['geopoint'].longitude);
    }
  }

  static Map<String, dynamic> _toJson(GeoFirePoint? location) {
    return location!.data;
  }

  @override
  String toString() {
    return "$address, ${this.number}, ${this.place}, ${this.city}, ${this.zipcode}";
  }

}

