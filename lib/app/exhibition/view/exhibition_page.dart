import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection.dart';
import '../cubit/exhibition_cubit.dart';
import 'exhibition_view.dart';

class ExhibitionPage extends StatelessWidget {

  ExhibitionPage({super.key});

  static Route<void> route(User host) {
    return MaterialPageRoute<void>(builder: (_) => ExhibitionPage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<ExhibitionCubit>(
        create: (context) => ExhibitionCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child:ExhibitionView()
      );
  }
}
