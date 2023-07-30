// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PhotoCWProxy {
  Photo url(String? url);

  Photo description(String? description);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Photo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Photo(...).copyWith(id: 12, name: "My name")
  /// ````
  Photo call({
    String? url,
    String? description,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPhoto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPhoto.copyWith.fieldName(...)`
class _$PhotoCWProxyImpl implements _$PhotoCWProxy {
  const _$PhotoCWProxyImpl(this._value);

  final Photo _value;

  @override
  Photo url(String? url) => this(url: url);

  @override
  Photo description(String? description) => this(description: description);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Photo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Photo(...).copyWith(id: 12, name: "My name")
  /// ````
  Photo call({
    Object? url = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
  }) {
    return Photo(
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
    );
  }
}

extension $PhotoCopyWith on Photo {
  /// Returns a callable class that can be used as follows: `instanceOfPhoto.copyWith(...)` or like so:`instanceOfPhoto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PhotoCWProxy get copyWith => _$PhotoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      url: json['url'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'url': instance.url,
      'description': instance.description,
    };
