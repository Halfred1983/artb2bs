import 'package:artb2b/photo/view/photo_upload_view.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_service/storage.dart';

import '../../injection.dart';
import '../cubit/photo_cubit.dart';

class PhotoUploadPage extends StatelessWidget {
  final bool isOnboarding;

  PhotoUploadPage({this.isOnboarding = false});

  static Route<void> route({bool isOnboarding = false}) {
    return MaterialPageRoute<void>(
      builder: (_) => PhotoUploadPage(isOnboarding: isOnboarding),
    );
  }
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();
  final FirestoreStorageService storageService = locator<FirestoreStorageService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<PhotoCubit>(
        create: (context) => PhotoCubit(
          databaseService: databaseService,
          storageService: storageService,
          userId: authService.getUser().id,
        ),
        child: PhotoUploadView(isOnboarding: isOnboarding),
      );
  }
}
