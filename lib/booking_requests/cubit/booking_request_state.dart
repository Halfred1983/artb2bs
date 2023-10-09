import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class BookingRequestState extends Equatable {}

class InitialState extends BookingRequestState {
  @override
  List<Object> get props => [];
}

class LoadingState extends BookingRequestState {
  @override
  List<Object> get props => [];
}

class PaymentLoadingState extends BookingRequestState {
  @override
  List<Object> get props => [];
}

class LoadedState extends BookingRequestState {
  LoadedState(this.user, this.booking);

  final User user;
  final Booking booking;

  @override
  List<Object> get props => [user, booking];
}

class PaymentLoadedState extends BookingRequestState {
  PaymentLoadedState(this.user, this.booking);

  final User user;
  final Booking booking;

  @override
  List<Object> get props => [user, booking];
}

class DateRangeChosen extends BookingRequestState {
  DateRangeChosen(this.user, this.booking);

  final User user;
  final Booking booking;


  @override
  List<Object> get props => [user, booking];
}

class SpacesChosen extends BookingRequestState {
  SpacesChosen(this.user, this.booking);

  final User user;
  final Booking booking;


  @override
  List<Object> get props => [user, booking];
}

class FinaliseBooking extends BookingRequestState {
  FinaliseBooking(this.user, this.booking);

  final User user;
  final Booking booking;


  @override
  List<Object> get props => [user, booking];
}


class DateRangeErrorState extends BookingRequestState {
  DateRangeErrorState(this.user, this.booking, this.message);

  final User user;
  final Booking booking;
  final String message;


  @override
  List<Object> get props => [user, booking, message];
}

class SpacesErrorState extends BookingRequestState {
  SpacesErrorState(this.user, this.booking, this.message);

  final User user;
  final Booking booking;
  final String message;


  @override
  List<Object> get props => [user, booking, message];
}

class ErrorState extends BookingRequestState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}