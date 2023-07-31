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

class LoadedState extends BookingState {
  LoadedState(this.user, this.booking);

  final User user;
  final Booking booking;

  @override
  List<Object> get props => [user, booking];
}

class DateRangeChosen extends BookingState {
  DateRangeChosen(this.user, this.booking);

  final User user;
  final Booking booking;


  @override
  List<Object> get props => [user, booking];
}

class SpacesChosen extends BookingState {
  SpacesChosen(this.user, this.booking);

  final User user;
  final Booking booking;


  @override
  List<Object> get props => [user, booking];
}


class ErrorState extends BookingState {
  @override
  List<Object> get props => [];
}