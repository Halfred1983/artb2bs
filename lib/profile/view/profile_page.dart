import 'package:artb2b/profile/view/profile_view.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';

import '../../../injection.dart';

class ProfilePage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => ProfilePage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return ProfileView();
      // BlocProvider<ArtworkCubit>(
      //   create: (context) => ArtworkCubit(
      //     databaseService: databaseService,
      //     userId: authService.getUser().id,
      //   ),
      //   child:  ArtworkView(),
      // );
  }
}
