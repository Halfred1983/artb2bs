import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class BookingRequestState extends Equatable {
  final List<Booking> bookings;
  final User user;
  final String filter;

  const BookingRequestState(this.bookings, this.user, this.filter);

  @override
  List<Object?> get props => [bookings, user, filter];
}

class InitialState extends BookingRequestState {
  InitialState(User user)
      : super([], user, 'All'); // Default filter to 'All'

  @override
  List<Object> get props => [user];
}

class LoadingState extends BookingRequestState {
  LoadingState({required User user, required List<Booking> bookings, required String filter})
      : super(bookings, user, filter);

  @override
  List<Object?> get props => [bookings, user, filter];
}

class LoadedState extends BookingRequestState {
  final bool hasMoreData;

  LoadedState({required User user, required List<Booking> bookings, required String filter, this.hasMoreData = true})
      : super(bookings, user, filter);

  @override
  List<Object?> get props => [bookings, user, filter, hasMoreData];
}

class FilterState extends BookingRequestState {
  FilterState({required User user, required String filter, required List<Booking> bookings})
      : super(bookings, user, filter);

  @override
  List<Object?> get props => [bookings, user, filter];
}

class ErrorState extends BookingRequestState {
  final String error;

  ErrorState({required User user, required List<Booking> bookings, required String filter, required this.error})
      : super(bookings, user, filter);

  @override
  List<Object?> get props => [bookings, user, filter, error];
}

class OverlapErrorState extends BookingRequestState {
  final String message;

  OverlapErrorState({required User user, required List<Booking> bookings, required String filter, required this.message})
      : super(bookings, user, filter);

  @override
  List<Object?> get props => [bookings, user, filter, message];
}
