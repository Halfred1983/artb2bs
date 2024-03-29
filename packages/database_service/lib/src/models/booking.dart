
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Booking {

  @JsonKey(
      defaultValue: BookingStatus.pending,
      unknownEnumValue: BookingStatus.pending
  )
  BookingStatus? bookingStatus;
  @TimestampConverter()
  DateTime? from;
  @TimestampConverter()
  DateTime? to;
  String? hostId;
  String? artistId;
  String? spaces;
  String? price;
  String? commission;
  String? totalPrice;
  String? currencyCode;
  String? bookingId;
  String? paymentIntentId;
  @TimestampConverter()
  DateTime? bookingTime;
  @TimestampConverter()
  DateTime? reviewdTime;

  Booking({
    this.bookingStatus,
    this.from,
    this.to,
    this.hostId,
    this.artistId,
    this.spaces,
    this.price,
    this.commission,
    this.totalPrice,
    this.currencyCode,
    this.bookingId,
    this.paymentIntentId,
    this.bookingTime,
    this.reviewdTime
  });


  factory Booking.fromJson(Map<String, dynamic> json)
  => _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);

}


enum BookingStatus {
  @JsonValue(0)
  pending,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  rejected,
  @JsonValue(3)
  cancelled,
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}


