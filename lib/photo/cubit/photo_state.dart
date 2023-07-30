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

class ArtworkUploadedState extends PhotoState {
  ArtworkUploadedState(this.artwork);

  final Artwork artwork;

  @override
  List<Object> get props => [artwork];
}

class PhotoUploadedState extends PhotoState {
  PhotoUploadedState(this.photo);

  final Photo photo;

  @override
  List<Object> get props => [photo];
}

class LoadedState extends PhotoState {
  LoadedState(this.user, this.artwork, this.photo);

  final User user;
  final Artwork artwork;
  final Photo photo;

  @override
  List<Object> get props => [user, artwork, photo];
}

class ErrorState extends PhotoState {
  @override
  List<Object> get props => [];
}

//STATES


