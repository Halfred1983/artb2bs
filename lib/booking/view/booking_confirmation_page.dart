import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';
import '../cubit/booking_cubit.dart';
import 'booking_confirmation_view.dart';

class BookingConfirmationPage extends StatelessWidget {

  final User host;
  final Booking booking;

  BookingConfirmationPage({super.key, required this.host, required this.booking});

  static Route<void> route(User host, Booking booking) {
    return MaterialPageRoute<void>(builder: (_) => BookingConfirmationPage(host: host,
      booking: booking));
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<BookingCubit>(
        create: (context) => BookingCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child: BookingConfirmationView(host: host, booking: booking,),
      );
  }
}
