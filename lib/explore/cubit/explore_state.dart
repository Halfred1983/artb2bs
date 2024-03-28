import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class ExploreState extends Equatable {}

class InitialState extends ExploreState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ExploreState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ExploreState {
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

class ErrorState extends ExploreState {
  @override
  List<Object> get props => [];
}