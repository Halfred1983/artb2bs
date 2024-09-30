
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
  String id;

  Unavailable({
    required this.id,
    this.from,
    this.to,
  });

  // Override == and hashCode to compare by 'id'
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Unavailable &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Unavailable{id: $id, from: $from, to: $to}';
  }


  factory Unavailable.fromJson(Map<String, dynamic> json)
  => _$UnavailableFromJson(json);

  Map<String, dynamic> toJson() => _$UnavailableToJson(this);

}