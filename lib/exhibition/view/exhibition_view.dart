import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';
import '../../../utils/common.dart';
import '../../../widgets/reservation_calendar_widget.dart';
import '../cubit/exhibition_cubit.dart';
import '../cubit/exhibition_state.dart';

class ExhibitionView extends StatelessWidget {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  ExhibitionView({super.key});

  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<ExhibitionCubit, ExhibitionState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }

            if (state is LoadedState) {
              user = state.props[0] as User;

              return Scaffold(
                appBar: AppBar(
                  title: Text("Your Bookings", style: TextStyles.boldAccent24,),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: horizontalPadding24,
                  child: ReservationCalendarWidget(user: user!)
                ),

              );
            }
            return Container();
          }
      );
  }
}