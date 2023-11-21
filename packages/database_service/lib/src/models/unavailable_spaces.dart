
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:database_service/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'unavailable_spaces.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class UnavailableSpaces {

  @TimestampConverter()
  DateTime? from;
  @TimestampConverter()
  DateTime? to;
  String? spaces;

  UnavailableSpaces({
    this.from,
    this.to,
    this.spaces
  });


  factory UnavailableSpaces.fromJson(Map<String, dynamic> json)
  => _$UnavailableSpacesFromJson(json);

  Map<String, dynamic> toJson() => _$UnavailableSpacesToJson(this);

}