// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_hours.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BusinessHoursCWProxy {
  BusinessHours from(String? from);

  BusinessHours to(String? to);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BusinessHours(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BusinessHours(...).copyWith(id: 12, name: "My name")
  /// ````
  BusinessHours call({
    String? from,
    String? to,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBusinessHours.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBusinessHours.copyWith.fieldName(...)`
class _$BusinessHoursCWProxyImpl implements _$BusinessHoursCWProxy {
  const _$BusinessHoursCWProxyImpl(this._value);

  final BusinessHours _value;

  @override
  BusinessHours from(String? from) => this(from: from);

  @override
  BusinessHours to(String? to) => this(to: to);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BusinessHours(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BusinessHours(...).copyWith(id: 12, name: "My name")
  /// ````
  BusinessHours call({
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
  }) {
    return BusinessHours(
      from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as String?,
      to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as String?,
    );
  }
}

extension $BusinessHoursCopyWith on BusinessHours {
  /// Returns a callable class that can be used as follows: `instanceOfBusinessHours.copyWith(...)` or like so:`instanceOfBusinessHours.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BusinessHoursCWProxy get copyWith => _$BusinessHoursCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessHours _$BusinessHoursFromJson(Map<String, dynamic> json) =>
    BusinessHours(
      json['from'] as String?,
      json['to'] as String?,
    );

Map<String, dynamic> _$BusinessHoursToJson(BusinessHours instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
    };
