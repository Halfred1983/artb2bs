import 'package:artb2b/onboard/cubit/personal_info_cubit.dart';
import 'package:artb2b/onboard/view/personal_info_view.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';

class PersonalInfoPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => PersonalInfoPage());
  }

  PersonalInfoPage({Key? key}) : super(key: key);
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalInfoCubit>(
    create: (context) => PersonalInfoCubit(
      databaseService: databaseService,
      userId: authService.getUser().id,
    ),
    child: PersonalInfoView(),
  );
  }
}
