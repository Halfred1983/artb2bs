import 'package:equatable/equatable.dart';
import 'package:database_service/database.dart';


abstract class PhotoState extends Equatable {
  const PhotoState();
}

class InitialState extends PhotoState {
  InitialState(this.artwork);

  final Artwork artwork;

  @override
  List<Object> get props => [artwork];
}

class LoadingState extends PhotoState {
  @override
  List<Object> get props => [];
}

class LoadedState extends PhotoState {
  LoadedState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class ErrorState extends PhotoState {
  @override
  List<Object> get props => [];
}

//STATES

class NameChosen extends PhotoState {
  NameChosen(this.artwork);
  final Artwork artwork;


  @override
  List<Object> get props => [artwork];
}

