
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  String? aptBuilding = '';
  final String formattedAddress;
  @JsonKey(
      fromJson: _fromJson,
      toJson: _toJson)
  Geo? location;

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
    this.aptBuilding,
    required this.formattedAddress,
    this.location
  });

  factory UserAddress.fromJson(Map<String, dynamic?> json)
  => _$UserAddressFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddressToJson(this);

  static Geo? _fromJson(Map<String, dynamic> location) {
    try {
      return Geo.fromJson(location);
    }
    catch (e) {
      return Geo.fromJson(location);
    }
  }

  static Map<String, dynamic> _toJson(Geo? location) {
    return location!.toJson();
  }

  @override
  String toString() {
    return "$address, ${this.number}, ${this.place}, ${this.city}, ${this.zipcode}";
  }

}

class Geo {
  Geo({
    required this.geohash,
    required this.geopoint,
  });

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
    geohash: json['geohash'] as String,
    geopoint: json['geopoint'] as GeoPoint,
  );

  final String geohash;
  final GeoPoint geopoint;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'geohash': geohash,
    'geopoint': geopoint,
  };
}
