import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class CalendarAvailabilityState extends Equatable {}

class InitialState extends CalendarAvailabilityState {
  @override
  List<Object> get props => [];
}

class LoadingState extends CalendarAvailabilityState {
  @override
  List<Object> get props => [];
}

class LoadedState extends CalendarAvailabilityState {
  LoadedState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}


class ErrorState extends CalendarAvailabilityState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class OverlapErrorState extends CalendarAvailabilityState {
  final String message;
  final User user;

  OverlapErrorState(this.message, this.user);


  @override
  // TODO: implement props
  List<Object> get props => [message, user];
}