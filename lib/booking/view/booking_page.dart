import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';
import '../cubit/booking_cubit.dart';
import 'booking_view.dart';

class BookingPage extends StatelessWidget {

  final User host;

  BookingPage({super.key, required this.host});

  static Route<void> route(User host) {
    return MaterialPageRoute<void>(builder: (_) => BookingPage(host: host,));
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<BookingCubit>(
        create: (context) => BookingCubit(host,
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child: BookingView(host: host),
      );
  }
}
