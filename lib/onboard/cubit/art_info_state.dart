import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class ArtInfoState extends Equatable {}

class InitialState extends ArtInfoState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ArtInfoState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ArtInfoState {
  LoadedState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class CapacityChosen extends ArtInfoState {
  CapacityChosen(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class SpacesChosen extends ArtInfoState {
  SpacesChosen(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class DataSaved extends ArtInfoState {
  DataSaved(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class ErrorState extends ArtInfoState {
  final String errorMessage;

  ErrorState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}