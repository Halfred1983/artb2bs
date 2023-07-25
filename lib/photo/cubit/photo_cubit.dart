import 'dart:io';

import 'package:artb2b/photo/cubit/photo_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:database_service/database.dart';
import 'package:storage_service/storage.dart';


class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit({required this.databaseService, required this.storageService,
    required this.userId}) : super(InitialState()) {
    getUser(userId);
  }

  final DatabaseService databaseService;
  final StorageService storageService;
  final String userId;

  void getUser(String userId) async {
    try {
      emit(LoadingState());
      final user = await databaseService.getUser(userId: userId);
      emit(LoadedState(user!, Artwork.empty()));
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

  // void chooseTags(List<String> tags) {
  //   Artwork artwork = this.state.props[0] as Artwork;
  //
  //   try {
  //     artwork = artwork.copyWith(tags: tags);
  //   } catch (e) {
  //     emit(ErrorState());
  //   }
  // }

  UploadTask storePhoto(String path, File? image) {

    return storageService.addPhoto(path: path, image: image!);

  }

  void savePhoto(List<String> photoTags, String downloadUrl, User user) {
    Artwork artwork = this.state.props[1] as Artwork;

    artwork = artwork.copyWith(url: downloadUrl, tags: photoTags);
    if(user.artworks != null && user.artworks!.isNotEmpty) {
      user.artworks!.add(artwork);
    }
    else {
      user.artworks = List.of([artwork], growable: true);
    }
    databaseService.updateUser(user: user);

    emit(UploadedState(artwork));
  }
}
