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

class LoadedState extends BookingRequestState {
  LoadedState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}


class ErrorState extends BookingRequestState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class OverlapErrorState extends BookingRequestState {
  final String message;
  final User user;

  OverlapErrorState(this.message, this.user);


  @override
  // TODO: implement props
  List<Object> get props => [message, user];
}