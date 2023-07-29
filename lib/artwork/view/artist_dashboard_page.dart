import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../cubit/artist_cubit.dart';
import 'artist_dashboard_view.dart';

class ArtistDashboardPage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => ArtistDashboardPage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<ArtistCubit>(
        create: (context) => ArtistCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child: const ArtistDashboardView(),
      );
  }
}
