import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class HostState extends Equatable {}

class InitialState extends HostState {
  @override
  List<Object> get props => [];
}

class LoadingState extends HostState {
  @override
  List<Object> get props => [];
}

class LoadedState extends HostState {
  LoadedState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class CapacityChosen extends HostState {
  CapacityChosen(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class SpacesChosen extends HostState {
  SpacesChosen(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class DataSaved extends HostState {
  DataSaved(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class ErrorState extends HostState {
  ErrorState(this.user, this.message);

  final User user;
  final String message;

  @override
  List<Object> get props => [user, message];
}

class BookingSettingsDetail extends HostState {
  BookingSettingsDetail(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}
