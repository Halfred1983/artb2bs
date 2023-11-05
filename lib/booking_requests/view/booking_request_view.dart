import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/booking/service/booking_service.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_cubit.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_state.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../injection.dart';
import '../../../utils/common.dart';

class BookingRequestView extends StatelessWidget {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  String _errorMessage = '';
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
            if (state is OverlapErrorState) {
              _errorMessage = state.message;
              return AlertDialog( // <-- SEE HERE
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),

                title: Center(child:Text('Error', style: TextStyles.boldAccent16,)),
                content: Text(_errorMessage,textAlign: TextAlign.center, style: TextStyles.semiBoldViolet16,),
                actions: [
                  Center(child: TextButton(
                    onPressed: () {
                      context.read<BookingRequestCubit>().exitAlert(state.user); // Close the dialog
                    },
                    child: Text('OK', style: TextStyles.boldAccent16,),
                  )),
                ],
              );
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
                        stream: firestoreDatabaseService.getUserStream(user!.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const LoadingScreen();
                          } else if (snapshot.connectionState == ConnectionState.active
                              || snapshot.connectionState == ConnectionState.done) {

                            if (snapshot.hasData && snapshot.data != null) {

                              User user = User.fromJson(snapshot.data?.data() as Map<String, dynamic>);
                              var pendingBookings = user.bookings != null ? user.bookings!
                                  .where((element) => element.bookingStatus == BookingStatus.pending)
                                  .toList() : [];

                              if(pendingBookings.isNotEmpty) {
                                return ListView.builder(
                                    itemCount: user.bookings!.length,
                                    itemBuilder: (context, index) {
                                        return FutureBuilder<User?>(
                                            future: firestoreDatabaseService.getUser(
                                                userId: user.bookings![index].artistId!),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                return Padding(
                                                  padding: verticalPadding8,
                                                  child: InkWell(
                                                    onTap: () => context.pushNamed(
                                                      'profile',
                                                      pathParameters: {'userId': user.bookings![index].artistId!},
                                                    ),
                                                    child: CommonCard(
                                                      child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Image.asset('assets/images/artist.png',
                                                                  width: 40,),
                                                                horizontalMargin12,
                                                                Text(snapshot.data!.userInfo!.name!,
                                                                  style: TextStyles.boldViolet16,),
                                                              ],
                                                            ),
                                                            // verticalMargin12,
                                                            // const Divider(thickness: 0.5, color: AppTheme.primaryColor,),
                                                            // verticalMargin12,
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .start,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text("City: ",
                                                                  style: TextStyles.boldViolet16,),
                                                                Flexible(child: Text(snapshot.data!
                                                                    .userInfo!.address!
                                                                    .city,
                                                                  softWrap: true, style: TextStyles
                                                                      .semiBoldViolet16,)),
                                                              ],
                                                            ),
                                                            verticalMargin12,
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
                                                                      Text(user.bookings![index].spaces!,
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
                                                                        BookingService()
                                                                            .daysBetween(
                                                                            user.bookings![index].from!,
                                                                            user.bookings![index].to!)
                                                                            .toString(),
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
                                                                            user.bookings![index].from!),
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
                                                                        user.bookings![index].to!),
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
                                                                    Text('${user.bookings![index].price!} GBP',
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
                                                                    Text(
                                                                      '${user.bookings![index].commission!} GBP',
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
                                                                    Text(
                                                                      '${user.bookings![index].totalPrice!} GBP',
                                                                      style: TextStyles
                                                                          .semiBoldViolet16,),
                                                                  ],
                                                                ),
                                                                verticalMargin24,
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        child: OutlinedButton(
                                                                          onPressed: () => context.read<BookingRequestCubit>().rejectBooking(user.bookings![index], user!),
                                                                          child: Text('Reject' ,style: TextStyles.semiBoldAccent16.copyWith(
                                                                              decoration: TextDecoration.underline
                                                                          ),),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    horizontalMargin12,
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        child: ElevatedButton(
                                                                          onPressed: () => context.read<BookingRequestCubit>().acceptBooking(user.bookings![index], user!),
                                                                          child: Text("Accept", style: TextStyles.boldWhite16,),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            )
                                                          ]
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              else {
                                                return Center(
                                                    child: Lottie.asset(
                                                      'assets/loading.json',
                                                      fit: BoxFit.fill,
                                                    )
                                                );
                                              }
                                            }
                                        );

                                    });
                              } else {
                                return Center(
                                  child: Text('You have no booking requests',
                                    style: TextStyles.boldViolet16,),
                                );
                              }
                            }
                            else {
                              return Center(
                                child: Text('You have no booking requests',
                                  style: TextStyles.boldViolet16,),
                              );
                            }
                          }
                          return Text('State: ${snapshot.connectionState}');
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
