import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class SpaceAvailabilityState extends Equatable {}

class InitialState extends SpaceAvailabilityState {
  @override
  List<Object> get props => [];
}

class LoadingState extends SpaceAvailabilityState {
  @override
  List<Object> get props => [];
}

class LoadedState extends SpaceAvailabilityState {
  LoadedState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}


class ErrorState extends SpaceAvailabilityState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class OverlapErrorState extends SpaceAvailabilityState {
  final String message;
  final User user;

  OverlapErrorState(this.message, this.user);


  @override
  // TODO: implement props
  List<Object> get props => [message, user];
}