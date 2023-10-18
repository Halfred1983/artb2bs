import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {}

class InitialState extends BookingState {
  @override
  List<Object> get props => [];
}

class LoadingState extends BookingState {
  @override
  List<Object> get props => [];
}

class PaymentLoadingState extends BookingState {
  @override
  List<Object> get props => [];
}

class LoadedState extends BookingState {
  LoadedState(this.user, this.booking);

  final User user;
  final Booking booking;

  @override
  List<Object> get props => [user, booking];
}

class PaymentLoadedState extends BookingState {
  PaymentLoadedState(this.user, this.booking);

  final User user;
  final Booking booking;

  @override
  List<Object> get props => [user, booking];
}

class DateRangeChosen extends BookingState {
  DateRangeChosen(this.user, this.booking, this.maxSpacesForRange);

  final User user;
  final Booking booking;
  final int maxSpacesForRange;


  @override
  List<Object> get props => [user, booking, maxSpacesForRange];
}

class SpacesChosen extends BookingState {
  SpacesChosen(this.user, this.booking);

  final User user;
  final Booking booking;


  @override
  List<Object> get props => [user, booking];
}

class FinaliseBooking extends BookingState {
  FinaliseBooking(this.user, this.booking);

  final User user;
  final Booking booking;


  @override
  List<Object> get props => [user, booking];
}


class DateRangeErrorState extends BookingState {
  DateRangeErrorState(this.user, this.booking, this.message);

  final User user;
  final Booking booking;
  final String message;


  @override
  List<Object> get props => [user, booking, message];
}

class SpacesErrorState extends BookingState {
  SpacesErrorState(this.user, this.booking, this.message);

  final User user;
  final Booking booking;
  final String message;


  @override
  List<Object> get props => [user, booking, message];
}

class ErrorState extends BookingState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}