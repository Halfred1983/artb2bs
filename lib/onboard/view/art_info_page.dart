import 'package:artb2b/onboard/cubit/personal_info_cubit.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../cubit/art_info_cubit.dart';
import 'art_info_view.dart';

class ArtInfoPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => ArtInfoPage());
  }

  ArtInfoPage({Key? key}) : super(key: key);
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArtInfoCubit>(
    create: (context) => ArtInfoCubit(
      databaseService: databaseService,
      userId: authService.getUser().id,
    ),
    child: ArtInfoView(),
  );
  }
}
