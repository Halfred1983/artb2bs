import 'package:artb2b/home/bloc/user_cubit.dart';
import 'package:artb2b/host/cubit/host_cubit.dart';
import 'package:artb2b/user_profile/view/user_profile_view.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';

class UserProfilePage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => UserProfilePage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return BlocProvider<HostCubit>(
          create: (context) => HostCubit(
            databaseService: databaseService,
            userId: authService.getUser().id,
          ),
          child:  const UserProfileView(),
    );
  }
}
