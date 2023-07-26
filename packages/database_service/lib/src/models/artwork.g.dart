// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artwork.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ArtworkCWProxy {
  Artwork id(String? id);

  Artwork url(String? url);

  Artwork tags(List<String>? tags);

  Artwork name(String? name);

  Artwork year(String? year);

  Artwork price(String? price);

  Artwork height(String? height);

  Artwork width(String? width);

  Artwork technique(String? technique);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Artwork(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Artwork(...).copyWith(id: 12, name: "My name")
  /// ````
  Artwork call({
    String? id,
    String? url,
    List<String>? tags,
    String? name,
    String? year,
    String? price,
    String? height,
    String? width,
    String? technique,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfArtwork.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfArtwork.copyWith.fieldName(...)`
class _$ArtworkCWProxyImpl implements _$ArtworkCWProxy {
  const _$ArtworkCWProxyImpl(this._value);

  final Artwork _value;

  @override
  Artwork id(String? id) => this(id: id);

  @override
  Artwork url(String? url) => this(url: url);

  @override
  Artwork tags(List<String>? tags) => this(tags: tags);

  @override
  Artwork name(String? name) => this(name: name);

  @override
  Artwork year(String? year) => this(year: year);

  @override
  Artwork price(String? price) => this(price: price);

  @override
  Artwork height(String? height) => this(height: height);

  @override
  Artwork width(String? width) => this(width: width);

  @override
  Artwork technique(String? technique) => this(technique: technique);

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
    Object? tags = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? year = const $CopyWithPlaceholder(),
    Object? price = const $CopyWithPlaceholder(),
    Object? height = const $CopyWithPlaceholder(),
    Object? width = const $CopyWithPlaceholder(),
    Object? technique = const $CopyWithPlaceholder(),
  }) {
    return Artwork(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<String>?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      year: year == const $CopyWithPlaceholder()
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as String?,
      price: price == const $CopyWithPlaceholder()
          ? _value.price
          // ignore: cast_nullable_to_non_nullable
          : price as String?,
      height: height == const $CopyWithPlaceholder()
          ? _value.height
          // ignore: cast_nullable_to_non_nullable
          : height as String?,
      width: width == const $CopyWithPlaceholder()
          ? _value.width
          // ignore: cast_nullable_to_non_nullable
          : width as String?,
      technique: technique == const $CopyWithPlaceholder()
          ? _value.technique
          // ignore: cast_nullable_to_non_nullable
          : technique as String?,
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
      id: json['id'] as String?,
      url: json['url'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      name: json['name'] as String?,
      year: json['year'] as String?,
      price: json['price'] as String?,
      height: json['height'] as String?,
      width: json['width'] as String?,
      technique: json['technique'] as String?,
    );

Map<String, dynamic> _$ArtworkToJson(Artwork instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'tags': instance.tags,
      'name': instance.name,
      'year': instance.year,
      'price': instance.price,
      'height': instance.height,
      'width': instance.width,
      'technique': instance.technique,
    };
