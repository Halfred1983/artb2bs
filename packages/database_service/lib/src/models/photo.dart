
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';


@JsonSerializable(explicitToJson: true)
@CopyWith()
class Photo {
  String? url;
  String? description;

  Photo({
    this.url,
    this.description,
  });

  factory Photo.fromJson(Map<String, dynamic?> json)
  => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);

}
