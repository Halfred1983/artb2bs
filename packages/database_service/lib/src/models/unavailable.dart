
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:database_service/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'unavailable.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Unavailable {

  @TimestampConverter()
  DateTime? from;
  @TimestampConverter()
  DateTime? to;

  Unavailable({
    this.from,
    this.to,
  });


  factory Unavailable.fromJson(Map<String, dynamic> json)
  => _$UnavailableFromJson(json);

  Map<String, dynamic> toJson() => _$UnavailableToJson(this);

}