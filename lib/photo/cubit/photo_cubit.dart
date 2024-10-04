import 'dart:io';

import 'package:artb2b/photo/cubit/photo_state.dart';
import 'package:database_service/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_service/storage.dart';

import '../../utils/currency/currency_helper.dart';

class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit({
    required this.databaseService,
    required this.storageService,
    required this.userId,
  }) : super(const InitialState()) {
    _initializeState();
  }

  final DatabaseService databaseService;
  final StorageService storageService;
  final String userId;
  late Artwork artwork;

  void _initializeState() async {
    artwork = Artwork.empty();
    await getUser(userId);
  }

  void choseCollectionName(String collectionName) {
    final User user = state.props[0] as User;

    try {
      emit(LoadingState());
      if (collectionName.isNotEmpty) {
        if (!user.artInfo!.hasCollectionWithName(collectionName)) {
          emit(LoadedState(user));
        } else {
          emit(ErrorState(user, "A collection with this name already exists"));
        }
      } else {
        emit(ErrorState(user, "Collection name cannot be empty"));
      }
    } catch (e) {
      emit(ErrorState(user, "An error occurred while adding the collection"));
    }
  }

  Future<void> getUser(String userId) async {
    try {
      emit(LoadingState());
      final user = await databaseService.getUser(userId: userId);
      emit(LoadedState(user!));
    } catch (e) {
      emit(ErrorState(User.empty(), e.toString()));
    }
  }

  void chooseName(String name) {
    artwork = artwork.copyWith(name: name);
    emit(ArtworkUpdatedState(artwork));
  }

  void chooseYear(String year) {
    artwork = artwork.copyWith(year: year);
    emit(ArtworkUpdatedState(artwork));
  }

  void choosePrice(String price) {
    artwork = artwork.copyWith(price: price);
    emit(ArtworkUpdatedState(artwork));
  }

  void chooseTechnique(String technique) {
    artwork = artwork.copyWith(technique: technique);
    emit(ArtworkUpdatedState(artwork));
  }

  void chooseType(String type) {
    artwork = artwork.copyWith(type: type);
    emit(ArtworkUpdatedState(artwork));
  }

  void chooseHeight(String height) {
    artwork = artwork.copyWith(height: height);
    emit(ArtworkUpdatedState(artwork));
  }

  void chooseWidth(String width) {
    artwork = artwork.copyWith(width: width);
    emit(ArtworkUpdatedState(artwork));
  }

  void chooseDescription(String description) {
    Photo photo = this.state.props[2] as Photo;

    photo.description = description;

  }

  void _updateUserWithArtwork(User user, String collectionId) {
    bool collectionFound = true;

    Collection? collection = user.artInfo!.collections.firstWhere(
          (element) => element.name == collectionId,
      orElse: () {
        emit(ErrorState(user, "Collection not found"));
        collectionFound = false;
        return Collection(name: collectionId, artworks: []); // Dummy collection to satisfy return type
      },
    );

    if (!collectionFound) return;

    final updatedArtworks = List.of(collection.artworks)..add(artwork);

    final updatedCollection = collection.copyWith(artworks: updatedArtworks);
    final updatedCollections = List.of(user.artInfo!.collections)
      ..removeWhere((c) => c.name == collectionId)
      ..add(updatedCollection);

    final updatedUser = user.copyWith(
      artInfo: user.artInfo!.copyWith(collections: updatedCollections),
    );

    // Save the updated user to the database
    databaseService.updateUser(user: updatedUser);
    emit(LoadedState(updatedUser));
  }

  UploadTask storePhoto(String path, File? image) {
    return storageService.addPhoto(path: path, image: image!);
  }

  void saveArtwork(List<String> photoTags, String downloadUrl, User user, String collectionName) {
    artwork = artwork.copyWith(
      url: downloadUrl,
      tags: photoTags,
      currencyCode: CurrencyHelper.currency(user.userInfo!.address!.country).currencySymbol,
    );

    _updateUserWithArtwork(user, collectionName);

    emit(ArtworkUploadedState(artwork));
  }

  void savePhoto(Photo photo, String downloadUrl, User user) {
    if (user.photos == null) {
      user = user.copyWith(photos: [photo]);
    } else {
      user.photos?.add(photo);
    }

    databaseService.updateUser(user: user);

    emit(PhotoUploadedState(photo));
  }

  void saveProfilePhoto(String downloadUrl, User user) async {
    user = user.copyWith(imageUrl: downloadUrl);

    await databaseService.updateUser(user: user);

    emit(LoadedState(user));
  }

  Future<void> deleteArtwork(String imageUrl) async {
    final User user = state.props[0] as User;
    // Update the user in the database by removing the artwork
    databaseService.updateUser(user: user);
    await storageService.deletePhoto(imageUrl: imageUrl);
  }

  Future<void> deletePhoto(String imageUrl) async {
    final User user = state.props[0] as User;
    user.photos?.removeWhere((element) => element.url == imageUrl);
    databaseService.updateUser(user: user);
    await storageService.deletePhoto(imageUrl: imageUrl);
  }

  void save(User user, [UserStatus? userStatus]) async {
    emit(LoadingState());

    try {
      if (userStatus != null) {
        user = user.copyWith(userStatus: userStatus);
      }
      await databaseService.updateUser(user: user);
      emit(DataSaved(user));
    } catch (e) {
      emit(ErrorState(user, "Error saving the art details"));
    }
  }
}
