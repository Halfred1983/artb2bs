
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
  DateTime? from;
  DateTime? to;
  String? hostId;
  String? artistId;
  String? spaces;
  String? price;
  String? commission;
  String? totalPrice;
  String? bookingId;

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
    this.bookingId
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

