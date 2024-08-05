
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_settings.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class BookingSettings {

  String? basePrice;
  String? minLength;
  String? minSpaces;
  String? paypalAccount;
  bool? active = false;

  BookingSettings({
    this.basePrice,
    this.minLength,
    this.minSpaces,
    this.paypalAccount,
    this.active
  });


  factory BookingSettings.fromJson(Map<String, dynamic> json)
  => _$BookingSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$BookingSettingsToJson(this);

}

