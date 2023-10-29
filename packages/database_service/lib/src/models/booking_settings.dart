
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_settings.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class BookingSettings {

  String? basePrice;
  String? minLength;
  String? minSpaces;
  bool? active = true;

  BookingSettings({
    this.basePrice,
    this.minLength,
    this.minSpaces,
    this.active
  });


  factory BookingSettings.fromJson(Map<String, dynamic> json)
  => _$BookingSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$BookingSettingsToJson(this);

}

