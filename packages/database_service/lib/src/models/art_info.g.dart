// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'art_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ArtInfoCWProxy {
  ArtInfo biography(String? biography);

  ArtInfo artStyle(ArtStyle? artStyle);

  ArtInfo artistName(String? artistName);

  ArtInfo collections(List<Collection> collections);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ArtInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ArtInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  ArtInfo call({
    String? biography,
    ArtStyle? artStyle,
    String? artistName,
    List<Collection>? collections,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfArtInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfArtInfo.copyWith.fieldName(...)`
class _$ArtInfoCWProxyImpl implements _$ArtInfoCWProxy {
  const _$ArtInfoCWProxyImpl(this._value);

  final ArtInfo _value;

  @override
  ArtInfo biography(String? biography) => this(biography: biography);

  @override
  ArtInfo artStyle(ArtStyle? artStyle) => this(artStyle: artStyle);

  @override
  ArtInfo artistName(String? artistName) => this(artistName: artistName);

  @override
  ArtInfo collections(List<Collection> collections) =>
      this(collections: collections);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ArtInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ArtInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  ArtInfo call({
    Object? biography = const $CopyWithPlaceholder(),
    Object? artStyle = const $CopyWithPlaceholder(),
    Object? artistName = const $CopyWithPlaceholder(),
    Object? collections = const $CopyWithPlaceholder(),
  }) {
    return ArtInfo(
      biography: biography == const $CopyWithPlaceholder()
          ? _value.biography
          // ignore: cast_nullable_to_non_nullable
          : biography as String?,
      artStyle: artStyle == const $CopyWithPlaceholder()
          ? _value.artStyle
          // ignore: cast_nullable_to_non_nullable
          : artStyle as ArtStyle?,
      artistName: artistName == const $CopyWithPlaceholder()
          ? _value.artistName
          // ignore: cast_nullable_to_non_nullable
          : artistName as String?,
      collections:
          collections == const $CopyWithPlaceholder() || collections == null
              ? _value.collections
              // ignore: cast_nullable_to_non_nullable
              : collections as List<Collection>,
    );
  }
}

extension $ArtInfoCopyWith on ArtInfo {
  /// Returns a callable class that can be used as follows: `instanceOfArtInfo.copyWith(...)` or like so:`instanceOfArtInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ArtInfoCWProxy get copyWith => _$ArtInfoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtInfo _$ArtInfoFromJson(Map<String, dynamic> json) => ArtInfo(
      biography: json['biography'] as String?,
      artStyle: $enumDecodeNullable(_$ArtStyleEnumMap, json['artStyle']),
      artistName: json['artistName'] as String?,
      collections: (json['collections'] as List<dynamic>?)
              ?.map((e) => Collection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ArtInfoToJson(ArtInfo instance) => <String, dynamic>{
      'biography': instance.biography,
      'artStyle': _$ArtStyleEnumMap[instance.artStyle],
      'artistName': instance.artistName,
      'collections': instance.collections.map((e) => e.toJson()).toList(),
    };

const _$ArtStyleEnumMap = {
  ArtStyle.realism: 0,
  ArtStyle.photorealism: 1,
  ArtStyle.expressionism: 2,
  ArtStyle.impressionism: 3,
  ArtStyle.abstract: 4,
  ArtStyle.surrealism: 5,
  ArtStyle.popArt: 6,
  ArtStyle.folkArt: 7,
  ArtStyle.hyperrealism: 8,
  ArtStyle.minimalism: 9,
};
