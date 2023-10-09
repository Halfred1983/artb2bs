import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_cubit.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_state.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';
import '../../../utils/common.dart';

class BookingRequestView extends StatelessWidget {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  BookingRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<BookingRequestCubit, BookingRequestState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }

            if (state is LoadedState) {
              user = state.props[0] as User;

              return Scaffold(
                  appBar: AppBar(
                    title: Text("Your Booking Requests", style: TextStyles.boldAccent24,),
                    centerTitle: true,
                  ),
                  body: Padding(
                    padding: horizontalPadding24,
                    child: StreamBuilder(
                        stream: firestoreDatabaseService.findBookings(user: user!, fromIndex: 0, toIndex: 9),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text(
                              'No Data...',
                            );
                          } else {
                            return Container(
                                child : Text('')
                            );
                          }
                        }
                    ),
                  )
              );
            }
            return Container();
          }
      );
  }
}
