import 'package:artb2b/payment/view/payment_page.dart';
import 'package:artb2b/widgets/booking_calendar_widget.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../booking/service/booking_service.dart';
import '../../../injection.dart';
import '../../../utils/common.dart';
import '../../../widgets/input_text_widget.dart';
import '../../../widgets/summary_card.dart';
import '../../resources/styles.dart';
import '../../resources/theme.dart';
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
                  child: StreamBuilder(
                      stream: firestoreDatabaseService.findBookings(user: user!, dateFrom: DateTime.now()),
                      builder: (context, snapshot){

                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading");
                        }

                        if(snapshot.hasData) {
                          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                          // Build your UI using the documents
                          return ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              final DocumentSnapshot document = documents[index];
                              final Booking booking = Booking.fromJson(
                                  document.data() as Map<String, dynamic>);

                              if(booking.from!.isAfter(DateTime.now())) {
                                // Customize how you display each document here
                                return CommonCard(
                                    child: Column(
                                      children: [
                                        Text('Your booking details:',
                                          style: TextStyles.semiBoldAccent18,),
                                        const Divider(
                                          thickness: 0.6, color: Colors.black38,),
                                        Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                                  Text('Spaces: ',
                                                    style: TextStyles
                                                        .semiBoldAccent16,),
                                                  Text(booking!.spaces!,
                                                    style: TextStyles
                                                        .semiBoldViolet16,),
                                                ]
                                            ),
                                            verticalMargin12,
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                                  Text('Days: ', style: TextStyles
                                                      .semiBoldAccent16,),
                                                  Text(
                                                    BookingService().daysBetween(
                                                        booking!.from!,
                                                        booking!.to!).toString(),
                                                    style: TextStyles
                                                        .semiBoldViolet16,),
                                                ]
                                            ),

                                            verticalMargin12,
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                                  Text('From: ', style: TextStyles
                                                      .semiBoldAccent16,),
                                                  Text(
                                                    DateFormat.yMMMEd().format(
                                                        booking!.from!),
                                                    style: TextStyles
                                                        .semiBoldViolet16,),
                                                ]
                                            ),
                                            verticalMargin12,
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: [
                                                Text('To: ', style: TextStyles
                                                    .semiBoldAccent16,),
                                                Text(DateFormat.yMMMEd().format(
                                                    booking!.to!),
                                                  style: TextStyles
                                                      .semiBoldViolet16,),
                                              ],
                                            ),
                                            verticalMargin12,
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: [
                                                Text('Price: ', style: TextStyles
                                                    .semiBoldAccent16,),
                                                // Text('${booking!.spaces!} spaces X ${daysBetween(booking!.from!, booking!.to!)} days X ${int.parse(user!.bookingSettings!.basePrice!).toDouble()} GBP',
                                                //   style: TextStyles.semiBoldViolet16, ),
                                                Text('${booking.price!} GBP',
                                                  style: TextStyles
                                                      .semiBoldViolet16,),
                                              ],
                                            ),
                                            verticalMargin12,
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: [
                                                Text('Commission (15%): ',
                                                  style: TextStyles
                                                      .semiBoldAccent16,),
                                                Text('${booking.commission!} GBP',
                                                  style: TextStyles
                                                      .semiBoldViolet16,),
                                              ],
                                            ),
                                            verticalMargin12,
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: [
                                                Text('Total price: ',
                                                  style: TextStyles
                                                      .semiBoldAccent16,),
                                                Text('${booking.totalPrice!} GBP',
                                                  style: TextStyles
                                                      .semiBoldViolet16,),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                );
                              }
                            },

                          );
                        }
                        return Container();
                      }),
                ),

              );
            }
            return Container();
          }
      );
  }
}
