// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingCWProxy {
  Booking userStatus(BookingStatus? userStatus);

  Booking from(DateTime? from);

  Booking to(DateTime? to);

  Booking hostId(String? hostId);

  Booking artistId(String? artistId);

  Booking spaces(String? spaces);

  Booking price(String? price);

  Booking commission(String? commission);

  Booking totalPrice(String? totalPrice);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Booking(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Booking(...).copyWith(id: 12, name: "My name")
  /// ````
  Booking call({
    BookingStatus? userStatus,
    DateTime? from,
    DateTime? to,
    String? hostId,
    String? artistId,
    String? spaces,
    String? price,
    String? commission,
    String? totalPrice,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBooking.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBooking.copyWith.fieldName(...)`
class _$BookingCWProxyImpl implements _$BookingCWProxy {
  const _$BookingCWProxyImpl(this._value);

  final Booking _value;

  @override
  Booking userStatus(BookingStatus? userStatus) => this(userStatus: userStatus);

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

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Booking(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Booking(...).copyWith(id: 12, name: "My name")
  /// ````
  Booking call({
    Object? userStatus = const $CopyWithPlaceholder(),
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? hostId = const $CopyWithPlaceholder(),
    Object? artistId = const $CopyWithPlaceholder(),
    Object? spaces = const $CopyWithPlaceholder(),
    Object? price = const $CopyWithPlaceholder(),
    Object? commission = const $CopyWithPlaceholder(),
    Object? totalPrice = const $CopyWithPlaceholder(),
  }) {
    return Booking(
      userStatus: userStatus == const $CopyWithPlaceholder()
          ? _value.userStatus
          // ignore: cast_nullable_to_non_nullable
          : userStatus as BookingStatus?,
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
      userStatus: $enumDecodeNullable(
              _$BookingStatusEnumMap, json['userStatus'],
              unknownValue: BookingStatus.pending) ??
          BookingStatus.pending,
      from:
          json['from'] == null ? null : DateTime.parse(json['from'] as String),
      to: json['to'] == null ? null : DateTime.parse(json['to'] as String),
      hostId: json['hostId'] as String?,
      artistId: json['artistId'] as String?,
      spaces: json['spaces'] as String?,
      price: json['price'] as String?,
      commission: json['commission'] as String?,
      totalPrice: json['totalPrice'] as String?,
    );

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'userStatus': _$BookingStatusEnumMap[instance.userStatus],
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
      'hostId': instance.hostId,
      'artistId': instance.artistId,
      'spaces': instance.spaces,
      'price': instance.price,
      'commission': instance.commission,
      'totalPrice': instance.totalPrice,
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 0,
  BookingStatus.accepted: 1,
  BookingStatus.rejected: 2,
  BookingStatus.cancelled: 3,
};
