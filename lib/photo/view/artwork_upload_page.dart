import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_service/storage.dart';

import '../../injection.dart';
import '../cubit/photo_cubit.dart';
import 'artwork_upload_view.dart';

class ArtworkUploadPage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => ArtworkUploadPage());
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
        child: const ArtworkUploadView(),
      );
  }
}
