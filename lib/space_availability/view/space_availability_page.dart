import 'package:artb2b/space_availability/cubit/space_availability_cubit.dart';
import 'package:artb2b/space_availability/view/space_availability_view.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection.dart';

class SpaceAvailabilityPage extends StatelessWidget {

  SpaceAvailabilityPage({super.key, required this.user});
  final User user;


  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<SpaceAvailabilityCubit>(
        create: (context) => SpaceAvailabilityCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child:SpaceAvailabilityView(user: user, rangeChanged: (dateRangeChoosen) => print(dateRangeChoosen))
      );
  }
}
