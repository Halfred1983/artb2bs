import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:storage_service/src/service/storage_service.dart';


class FirestoreStorageService implements StorageService {
  FirestoreStorageService({
    required FirebaseStorage storage
  }) : _firebaseStorage = storage;

  final FirebaseStorage _firebaseStorage;


  @override
  UploadTask addPhoto({required String path, required File image }) {
    try  {
      final metadata = SettableMetadata(contentType: "image/jpeg");

      return _firebaseStorage.ref()
          .child(path)
          .putFile(image, metadata);

    } on Exception catch (e) {
      throw e;
    }
  }
}

