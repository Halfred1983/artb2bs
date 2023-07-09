// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artwork.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ArtworkCWProxy {
  Artwork id(String id);

  Artwork url(String url);

  Artwork tag(String tag);

  Artwork name(String name);

  Artwork year(String year);

  Artwork price(int price);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Artwork(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Artwork(...).copyWith(id: 12, name: "My name")
  /// ````
  Artwork call({
    String? id,
    String? url,
    String? tag,
    String? name,
    String? year,
    int? price,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfArtwork.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfArtwork.copyWith.fieldName(...)`
class _$ArtworkCWProxyImpl implements _$ArtworkCWProxy {
  const _$ArtworkCWProxyImpl(this._value);

  final Artwork _value;

  @override
  Artwork id(String id) => this(id: id);

  @override
  Artwork url(String url) => this(url: url);

  @override
  Artwork tag(String tag) => this(tag: tag);

  @override
  Artwork name(String name) => this(name: name);

  @override
  Artwork year(String year) => this(year: year);

  @override
  Artwork price(int price) => this(price: price);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Artwork(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Artwork(...).copyWith(id: 12, name: "My name")
  /// ````
  Artwork call({
    Object? id = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
    Object? tag = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? year = const $CopyWithPlaceholder(),
    Object? price = const $CopyWithPlaceholder(),
  }) {
    return Artwork(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      url: url == const $CopyWithPlaceholder() || url == null
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String,
      tag: tag == const $CopyWithPlaceholder() || tag == null
          ? _value.tag
          // ignore: cast_nullable_to_non_nullable
          : tag as String,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      year: year == const $CopyWithPlaceholder() || year == null
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as String,
      price: price == const $CopyWithPlaceholder() || price == null
          ? _value.price
          // ignore: cast_nullable_to_non_nullable
          : price as int,
    );
  }
}

extension $ArtworkCopyWith on Artwork {
  /// Returns a callable class that can be used as follows: `instanceOfArtwork.copyWith(...)` or like so:`instanceOfArtwork.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ArtworkCWProxy get copyWith => _$ArtworkCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artwork _$ArtworkFromJson(Map<String, dynamic> json) => Artwork(
      id: json['id'] as String,
      url: json['url'] as String,
      tag: json['tag'] as String,
      name: json['name'] as String,
      year: json['year'] as String,
      price: json['price'] as int,
    );

Map<String, dynamic> _$ArtworkToJson(Artwork instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'tag': instance.tag,
      'name': instance.name,
      'year': instance.year,
      'price': instance.price,
    };
