// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingCWProxy {
  Booking bookingStatus(BookingStatus? bookingStatus);

  Booking from(DateTime? from);

  Booking to(DateTime? to);

  Booking hostId(String? hostId);

  Booking artistId(String? artistId);

  Booking spaces(String? spaces);

  Booking price(String? price);

  Booking commission(String? commission);

  Booking totalPrice(String? totalPrice);

  Booking bookingId(String? bookingId);

  Booking paymentIntentId(String? paymentIntentId);

  Booking bookingTime(DateTime? bookingTime);

  Booking reviewdTime(DateTime? reviewdTime);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Booking(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Booking(...).copyWith(id: 12, name: "My name")
  /// ````
  Booking call({
    BookingStatus? bookingStatus,
    DateTime? from,
    DateTime? to,
    String? hostId,
    String? artistId,
    String? spaces,
    String? price,
    String? commission,
    String? totalPrice,
    String? bookingId,
    String? paymentIntentId,
    DateTime? bookingTime,
    DateTime? reviewdTime,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBooking.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBooking.copyWith.fieldName(...)`
class _$BookingCWProxyImpl implements _$BookingCWProxy {
  const _$BookingCWProxyImpl(this._value);

  final Booking _value;

  @override
  Booking bookingStatus(BookingStatus? bookingStatus) =>
      this(bookingStatus: bookingStatus);

  @override
  Booking from(DateTime? from) => this(from: from);

  @override
  Booking to(DateTime? to) => this(to: to);

  @override
  Booking hostId(String? hostId) => this(hostId: hostId);

  @override
  Booking artistId(String? artistId) => this(artistId: artistId);

  @override
  Booking spaces(String? spaces) => this(spaces: spaces);

  @override
  Booking price(String? price) => this(price: price);

  @override
  Booking commission(String? commission) => this(commission: commission);

  @override
  Booking totalPrice(String? totalPrice) => this(totalPrice: totalPrice);

  @override
  Booking bookingId(String? bookingId) => this(bookingId: bookingId);

  @override
  Booking paymentIntentId(String? paymentIntentId) =>
      this(paymentIntentId: paymentIntentId);

  @override
  Booking bookingTime(DateTime? bookingTime) => this(bookingTime: bookingTime);

  @override
  Booking reviewdTime(DateTime? reviewdTime) => this(reviewdTime: reviewdTime);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Booking(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Booking(...).copyWith(id: 12, name: "My name")
  /// ````
  Booking call({
    Object? bookingStatus = const $CopyWithPlaceholder(),
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? hostId = const $CopyWithPlaceholder(),
    Object? artistId = const $CopyWithPlaceholder(),
    Object? spaces = const $CopyWithPlaceholder(),
    Object? price = const $CopyWithPlaceholder(),
    Object? commission = const $CopyWithPlaceholder(),
    Object? totalPrice = const $CopyWithPlaceholder(),
    Object? bookingId = const $CopyWithPlaceholder(),
    Object? paymentIntentId = const $CopyWithPlaceholder(),
    Object? bookingTime = const $CopyWithPlaceholder(),
    Object? reviewdTime = const $CopyWithPlaceholder(),
  }) {
    return Booking(
      bookingStatus: bookingStatus == const $CopyWithPlaceholder()
          ? _value.bookingStatus
          // ignore: cast_nullable_to_non_nullable
          : bookingStatus as BookingStatus?,
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as DateTime?,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as DateTime?,
      hostId: hostId == const $CopyWithPlaceholder()
          ? _value.hostId
          // ignore: cast_nullable_to_non_nullable
          : hostId as String?,
      artistId: artistId == const $CopyWithPlaceholder()
          ? _value.artistId
          // ignore: cast_nullable_to_non_nullable
          : artistId as String?,
      spaces: spaces == const $CopyWithPlaceholder()
          ? _value.spaces
          // ignore: cast_nullable_to_non_nullable
          : spaces as String?,
      price: price == const $CopyWithPlaceholder()
          ? _value.price
          // ignore: cast_nullable_to_non_nullable
          : price as String?,
      commission: commission == const $CopyWithPlaceholder()
          ? _value.commission
          // ignore: cast_nullable_to_non_nullable
          : commission as String?,
      totalPrice: totalPrice == const $CopyWithPlaceholder()
          ? _value.totalPrice
          // ignore: cast_nullable_to_non_nullable
          : totalPrice as String?,
      bookingId: bookingId == const $CopyWithPlaceholder()
          ? _value.bookingId
          // ignore: cast_nullable_to_non_nullable
          : bookingId as String?,
      paymentIntentId: paymentIntentId == const $CopyWithPlaceholder()
          ? _value.paymentIntentId
          // ignore: cast_nullable_to_non_nullable
          : paymentIntentId as String?,
      bookingTime: bookingTime == const $CopyWithPlaceholder()
          ? _value.bookingTime
          // ignore: cast_nullable_to_non_nullable
          : bookingTime as DateTime?,
      reviewdTime: reviewdTime == const $CopyWithPlaceholder()
          ? _value.reviewdTime
          // ignore: cast_nullable_to_non_nullable
          : reviewdTime as DateTime?,
    );
  }
}

extension $BookingCopyWith on Booking {
  /// Returns a callable class that can be used as follows: `instanceOfBooking.copyWith(...)` or like so:`instanceOfBooking.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingCWProxy get copyWith => _$BookingCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
      bookingStatus: $enumDecodeNullable(
              _$BookingStatusEnumMap, json['bookingStatus'],
              unknownValue: BookingStatus.pending) ??
          BookingStatus.pending,
      from: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['from'], const TimestampConverter().fromJson),
      to: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['to'], const TimestampConverter().fromJson),
      hostId: json['hostId'] as String?,
      artistId: json['artistId'] as String?,
      spaces: json['spaces'] as String?,
      price: json['price'] as String?,
      commission: json['commission'] as String?,
      totalPrice: json['totalPrice'] as String?,
      bookingId: json['bookingId'] as String?,
      paymentIntentId: json['paymentIntentId'] as String?,
      bookingTime: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['bookingTime'], const TimestampConverter().fromJson),
      reviewdTime: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['reviewdTime'], const TimestampConverter().fromJson),
    );

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'bookingStatus': _$BookingStatusEnumMap[instance.bookingStatus],
      'from': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.from, const TimestampConverter().toJson),
      'to': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.to, const TimestampConverter().toJson),
      'hostId': instance.hostId,
      'artistId': instance.artistId,
      'spaces': instance.spaces,
      'price': instance.price,
      'commission': instance.commission,
      'totalPrice': instance.totalPrice,
      'bookingId': instance.bookingId,
      'paymentIntentId': instance.paymentIntentId,
      'bookingTime': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.bookingTime, const TimestampConverter().toJson),
      'reviewdTime': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.reviewdTime, const TimestampConverter().toJson),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 0,
  BookingStatus.accepted: 1,
  BookingStatus.rejected: 2,
  BookingStatus.cancelled: 3,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
