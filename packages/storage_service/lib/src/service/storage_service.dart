

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageService {

  UploadTask addPhoto({
    required String path,
    required File image
  });

}