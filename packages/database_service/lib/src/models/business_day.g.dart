// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_day.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BusinessDayCWProxy {
  BusinessDay dayOfWeek(DayOfWeek? dayOfWeek);

  BusinessDay hourInterval(List<BusinessHours> hourInterval);

  BusinessDay open(bool? open);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BusinessDay(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BusinessDay(...).copyWith(id: 12, name: "My name")
  /// ````
  BusinessDay call({
    DayOfWeek? dayOfWeek,
    List<BusinessHours>? hourInterval,
    bool? open,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBusinessDay.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBusinessDay.copyWith.fieldName(...)`
class _$BusinessDayCWProxyImpl implements _$BusinessDayCWProxy {
  const _$BusinessDayCWProxyImpl(this._value);

  final BusinessDay _value;

  @override
  BusinessDay dayOfWeek(DayOfWeek? dayOfWeek) => this(dayOfWeek: dayOfWeek);

  @override
  BusinessDay hourInterval(List<BusinessHours> hourInterval) =>
      this(hourInterval: hourInterval);

  @override
  BusinessDay open(bool? open) => this(open: open);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BusinessDay(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BusinessDay(...).copyWith(id: 12, name: "My name")
  /// ````
  BusinessDay call({
    Object? dayOfWeek = const $CopyWithPlaceholder(),
    Object? hourInterval = const $CopyWithPlaceholder(),
    Object? open = const $CopyWithPlaceholder(),
  }) {
    return BusinessDay(
      dayOfWeek == const $CopyWithPlaceholder()
          ? _value.dayOfWeek
          // ignore: cast_nullable_to_non_nullable
          : dayOfWeek as DayOfWeek?,
      hourInterval == const $CopyWithPlaceholder() || hourInterval == null
          ? _value.hourInterval
          // ignore: cast_nullable_to_non_nullable
          : hourInterval as List<BusinessHours>,
      open == const $CopyWithPlaceholder()
          ? _value.open
          // ignore: cast_nullable_to_non_nullable
          : open as bool?,
    );
  }
}

extension $BusinessDayCopyWith on BusinessDay {
  /// Returns a callable class that can be used as follows: `instanceOfBusinessDay.copyWith(...)` or like so:`instanceOfBusinessDay.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BusinessDayCWProxy get copyWith => _$BusinessDayCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessDay _$BusinessDayFromJson(Map<String, dynamic> json) => BusinessDay(
      $enumDecodeNullable(_$DayOfWeekEnumMap, json['dayOfWeek'],
              unknownValue: DayOfWeek.monday) ??
          DayOfWeek.monday,
      (json['hourInterval'] as List<dynamic>)
          .map((e) => BusinessHours.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['open'] as bool?,
    );

Map<String, dynamic> _$BusinessDayToJson(BusinessDay instance) =>
    <String, dynamic>{
      'dayOfWeek': _$DayOfWeekEnumMap[instance.dayOfWeek],
      'hourInterval': instance.hourInterval.map((e) => e.toJson()).toList(),
      'open': instance.open,
    };

const _$DayOfWeekEnumMap = {
  DayOfWeek.monday: 0,
  DayOfWeek.tuesday: 1,
  DayOfWeek.wednesday: 2,
  DayOfWeek.thursday: 3,
  DayOfWeek.friday: 4,
  DayOfWeek.saturday: 5,
  DayOfWeek.sunday: 6,
};
