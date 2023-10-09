import 'package:artb2b/booking_requests/cubit/booking_request_cubit.dart';
import 'package:artb2b/booking_requests/view/booking_request_view.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection.dart';

class BookingRequestPage extends StatelessWidget {

  BookingRequestPage({super.key});

  static Route<void> route(User host) {
    return MaterialPageRoute<void>(builder: (_) => BookingRequestPage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<BookingRequestCubit>(
        create: (context) => BookingRequestCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child:BookingRequestView()
      );
  }
}
