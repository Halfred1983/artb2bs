import 'package:auto_route/auto_route.dart';
import 'package:artb2b/home/bloc/user_cubit.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import 'home_view.dart';

@RoutePage()
class HomaPage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => HomaPage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<UserCubit>(
        create: (context) => UserCubit(
          databaseService: databaseService,
          userId: authService.currentUser.id,
        ),
        child:  HomeView(),
      );
  }
}
