import 'package:artb2b/booking_requests/cubit/booking_request_cubit.dart';
import 'package:artb2b/booking_requests/view/booking_request_view.dart';
import 'package:artb2b/calendar_availability/cubit/calendar_availability_cubit.dart';
import 'package:artb2b/calendar_availability/view/calendar_availability_view.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection.dart';

class CalendarAvailabilityPage extends StatelessWidget {

  CalendarAvailabilityPage({super.key, required this.user});
  final User user;


  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<CalendarAvailabilityCubit>(
        create: (context) => CalendarAvailabilityCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child:CalendarAvailabilityView(user: user, rangeChanged: (dateRangeChoosen) => print(dateRangeChoosen))
      );
  }
}
