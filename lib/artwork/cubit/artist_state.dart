import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class ArtistState extends Equatable {}

class InitialState extends ArtistState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ArtistState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ArtistState {
  LoadedState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

// class DataSaved extends ArtworkState {
//   DataSaved(this.user);
//   final User user;
//
//
//   @override
//   List<Object> get props => [user];
// }

class ErrorState extends ArtistState {
  @override
  List<Object> get props => [];
}