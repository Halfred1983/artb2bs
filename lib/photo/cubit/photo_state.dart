import 'package:equatable/equatable.dart';
import 'package:database_service/database.dart';


abstract class PhotoState extends Equatable {
  const PhotoState();
}

class InitialState extends PhotoState {
  const InitialState();

  @override
  List<Object> get props => [];
}

class LoadingState extends PhotoState {
  @override
  List<Object> get props => [];
}

class UploadingState extends PhotoState {
  @override
  List<Object> get props => [];
}

class UploadedState extends PhotoState {
  UploadedState(this.artwork);

  final Artwork artwork;

  @override
  List<Object> get props => [artwork];
}

class LoadedState extends PhotoState {
  LoadedState(this.user, this.artwork);

  final User user;
  final Artwork artwork;

  @override
  List<Object> get props => [user, artwork];
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

