
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../database.dart';

part 'collection.g.dart';


@JsonSerializable(explicitToJson: true)
@CopyWith()
class Collection {
  String? name;
  String? collectionVibes;
  List<Artwork> artworks;

  Collection({
    this.name,
    this.collectionVibes,
    this.artworks = const [],
  });

  factory Collection.fromJson(Map<String, dynamic?> json)
  => _$CollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionToJson(this);

}
