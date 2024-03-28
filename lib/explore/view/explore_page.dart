import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../cubit/explore_cubit.dart';
import 'explore_view.dart';

class ExplorePage extends StatelessWidget {
   ExplorePage({super.key});


  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => ExplorePage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<ExploreCubit>(
        create: (context) => ExploreCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child: const ExploreView(),
      );
  }
}
