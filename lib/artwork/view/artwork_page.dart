import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../cubit/artwork_cubit.dart';
import 'artwork_view.dart';

class ArtworkPage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => ArtworkPage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<ArtworkCubit>(
        create: (context) => ArtworkCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child:  ArtworkView(),
      );
  }
}
