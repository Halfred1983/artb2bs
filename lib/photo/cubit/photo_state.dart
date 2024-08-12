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

class ArtworkUpdatedState extends PhotoState {
  ArtworkUpdatedState(this.artwork);

  final Artwork artwork;

  @override
  List<Object> get props => [artwork];
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
  LoadedState(this.user);

  final User user;
  // final Artwork artwork;
  // final Photo photo;

  @override
  List<Object> get props => [user,];
}

class ErrorState extends PhotoState {
  final String errorMessage;
  final User user;

  ErrorState(this.user, this.errorMessage);
  @override
  List<Object> get props => [user, errorMessage];
}

class DataSaved extends PhotoState {
  DataSaved(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

//STATES


