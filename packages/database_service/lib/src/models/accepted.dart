
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:database_service/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'accepted.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Accepted {

  String? bookingId;
  String? hostId;
  String? artistId;
  @TimestampConverter()
  DateTime? acceptedTimestamp;

  Accepted({
    this.hostId,
    this.artistId,
    this.bookingId,
    this.acceptedTimestamp
  });


  factory Accepted.fromJson(Map<String, dynamic> json)
  => _$AcceptedFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptedToJson(this);

}