import 'package:artb2b/home/bloc/user_cubit.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import 'home_view.dart';

class HomePage extends StatelessWidget {
  HomePage({this.index});

  int? index = 0;
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<UserCubit>(
        create: (context) => UserCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child:  PopScope(
            canPop : false,
            child:HomeView(index: index ?? 0)
        ),
      );
  }

}
