
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';


@JsonSerializable(explicitToJson: true)
@CopyWith()
class Photo {
  final String id;
  final String url;
  final String description;

  const Photo({
    required this.id,
    required this.url,
    required this.description,
  });

  factory Photo.fromJson(Map<String, dynamic?> json)
  => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);

}
