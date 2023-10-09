import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class ExhibitionState extends Equatable {}

class InitialState extends ExhibitionState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ExhibitionState {
  @override
  List<Object> get props => [];
}

class PaymentLoadingState extends ExhibitionState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ExhibitionState {
  LoadedState(this.user, this.booking);

  final User user;
  final Booking booking;

  @override
  List<Object> get props => [user, booking];
}

class PaymentLoadedState extends ExhibitionState {
  PaymentLoadedState(this.user, this.booking);

  final User user;
  final Booking booking;

  @override
  List<Object> get props => [user, booking];
}

class DateRangeChosen extends ExhibitionState {
  DateRangeChosen(this.user, this.booking);

  final User user;
  final Booking booking;


  @override
  List<Object> get props => [user, booking];
}

class SpacesChosen extends ExhibitionState {
  SpacesChosen(this.user, this.booking);

  final User user;
  final Booking booking;


  @override
  List<Object> get props => [user, booking];
}

class FinaliseBooking extends ExhibitionState {
  FinaliseBooking(this.user, this.booking);

  final User user;
  final Booking booking;


  @override
  List<Object> get props => [user, booking];
}


class DateRangeErrorState extends ExhibitionState {
  DateRangeErrorState(this.user, this.booking, this.message);

  final User user;
  final Booking booking;
  final String message;


  @override
  List<Object> get props => [user, booking, message];
}

class SpacesErrorState extends ExhibitionState {
  SpacesErrorState(this.user, this.booking, this.message);

  final User user;
  final Booking booking;
  final String message;


  @override
  List<Object> get props => [user, booking, message];
}

class ErrorState extends ExhibitionState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}