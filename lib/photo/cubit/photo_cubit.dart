import 'dart:io';

import 'package:artb2b/photo/cubit/photo_state.dart';
import 'package:database_service/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_service/storage.dart';


class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit({required this.databaseService, required this.storageService,
    required this.userId}) : super(const InitialState()) {
    getUser(userId);
  }

  final DatabaseService databaseService;
  final StorageService storageService;
  final String userId;

  void getUser(String userId) async {
    try {
      emit(LoadingState());
      final user = await databaseService.getUser(userId: userId);
      emit(LoadedState(user!, Artwork.empty(), Photo()));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void chooseName(String name) {
    Artwork artwork = this.state.props[1] as Artwork;

    try {
      artwork.name = name;
    } catch (e) {
      emit(ErrorState());
    }
  }

  void chooseDescription(String description) {
    Photo photo = this.state.props[2] as Photo;

    photo.description = description;

  }

  void chooseYear(String year) {
    Artwork artwork = this.state.props[1] as Artwork;

    try {
      artwork.year = year;
    } catch (e) {
      emit(ErrorState());
    }
  }

  void choosePrice(String price) {
    Artwork artwork = this.state.props[1] as Artwork;

    try {
      artwork.price = price;
    } catch (e) {
      emit(ErrorState());
    }
  }

  void chooseTechnique(String technique) {
    Artwork artwork = this.state.props[1] as Artwork;

    try {
      artwork.technique = technique;
    } catch (e) {
      emit(ErrorState());
    }
  }

  void chooseHeight(String height) {
    Artwork artwork = this.state.props[1] as Artwork;

    try {
      artwork.height = height;
    } catch (e) {
      emit(ErrorState());
    }
  }


  void chooseWidth(String width) {
    Artwork artwork = this.state.props[1] as Artwork;

    try {
      artwork.width = width;
    } catch (e) {
      emit(ErrorState());
    }
  }

  UploadTask storePhoto(String path, File? image) {

    return storageService.addPhoto(path: path, image: image!);
  }

  void saveArtwork(List<String> photoTags, String downloadUrl, User user) {
    Artwork artwork = this.state.props[1] as Artwork;

    artwork = artwork.copyWith(url: downloadUrl, tags: photoTags);
    if(user.artworks != null && user.artworks!.isNotEmpty) {
      user.artworks!.add(artwork);
    }
    else {
      user.artworks = List.of([artwork], growable: true);
    }
    databaseService.updateUser(user: user);

    emit(ArtworkUploadedState(artwork));
  }

  void savePhoto(String downloadUrl, User user) {
    Photo photo = this.state.props[2] as Photo;

    photo = photo.copyWith(url: downloadUrl);
    if(user.photos != null && user.photos!.isNotEmpty) {
      user.photos!.add(photo);
    }
    else {
      user.photos = List.of([photo], growable: true);
    }
    databaseService.updateUser(user: user);

    emit(PhotoUploadedState(photo));
  }

  Future<void> deleteArtwork(String imageUrl) {
    User user = this.state.props[0] as User;

    if(user.artworks != null && user.artworks!.isNotEmpty) {
      user.artworks?.removeWhere((element) => element.url == imageUrl);
    }
    databaseService.updateUser(user: user);

    return storageService.deletePhoto(imageUrl: imageUrl);
  }

  Future<void> deletePhoto(String imageUrl) {
    User user = this.state.props[0] as User;

    if(user.photos != null && user.photos!.isNotEmpty) {
      user.photos?.removeWhere((element) => element.url == imageUrl);
    }
    databaseService.updateUser(user: user);

    return storageService.deletePhoto(imageUrl: imageUrl);
  }




}
