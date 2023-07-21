import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class ArtworkState extends Equatable {}

class InitialState extends ArtworkState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ArtworkState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ArtworkState {
  LoadedState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class CapacityChosen extends ArtworkState {
  CapacityChosen(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class SpacesChosen extends ArtworkState {
  SpacesChosen(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class DataSaved extends ArtworkState {
  DataSaved(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class ErrorState extends ArtworkState {
  @override
  List<Object> get props => [];
}