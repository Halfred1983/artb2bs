// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CollectionCWProxy {
  Collection name(String? name);

  Collection collectionVibes(String? collectionVibes);

  Collection artworks(List<Artwork> artworks);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Collection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Collection(...).copyWith(id: 12, name: "My name")
  /// ````
  Collection call({
    String? name,
    String? collectionVibes,
    List<Artwork>? artworks,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCollection.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCollection.copyWith.fieldName(...)`
class _$CollectionCWProxyImpl implements _$CollectionCWProxy {
  const _$CollectionCWProxyImpl(this._value);

  final Collection _value;

  @override
  Collection name(String? name) => this(name: name);

  @override
  Collection collectionVibes(String? collectionVibes) =>
      this(collectionVibes: collectionVibes);

  @override
  Collection artworks(List<Artwork> artworks) => this(artworks: artworks);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Collection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Collection(...).copyWith(id: 12, name: "My name")
  /// ````
  Collection call({
    Object? name = const $CopyWithPlaceholder(),
    Object? collectionVibes = const $CopyWithPlaceholder(),
    Object? artworks = const $CopyWithPlaceholder(),
  }) {
    return Collection(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      collectionVibes: collectionVibes == const $CopyWithPlaceholder()
          ? _value.collectionVibes
          // ignore: cast_nullable_to_non_nullable
          : collectionVibes as String?,
      artworks: artworks == const $CopyWithPlaceholder() || artworks == null
          ? _value.artworks
          // ignore: cast_nullable_to_non_nullable
          : artworks as List<Artwork>,
    );
  }
}

extension $CollectionCopyWith on Collection {
  /// Returns a callable class that can be used as follows: `instanceOfCollection.copyWith(...)` or like so:`instanceOfCollection.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CollectionCWProxy get copyWith => _$CollectionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Collection _$CollectionFromJson(Map<String, dynamic> json) => Collection(
      name: json['name'] as String?,
      collectionVibes: json['collectionVibes'] as String?,
      artworks: (json['artworks'] as List<dynamic>?)
              ?.map((e) => Artwork.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'name': instance.name,
      'collectionVibes': instance.collectionVibes,
      'artworks': instance.artworks.map((e) => e.toJson()).toList(),
    };
