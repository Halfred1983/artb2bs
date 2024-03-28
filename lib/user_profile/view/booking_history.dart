import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/injection.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/booking_summary_card.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../app/resources/styles.dart';

class BookingHistory extends StatelessWidget {
  BookingHistory({super.key, required this.user});

  final DatabaseService databaseService = locator<FirestoreDatabaseService>();

  final User user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Booking>>(
      future: databaseService.findBookingsByUser(user).then((bookings) =>
      bookings.where((element) => element.to!.isBeforeWithoutTime(DateTime.now())).toList()
        ..sort((a, b) => b.to!.compareTo(a.to!))),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Booking History",
                style: TextStyles.boldAccent24,
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: AppTheme.primaryColor,
              ),
            ),
            body: Center(
              child: Center(
                child: Lottie.asset(
                  'assets/loading.json',
                  fit: BoxFit.fill,
                ),
              )
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Booking History",
                style: TextStyles.boldAccent24,
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: AppTheme.primaryColor,
              ),
            ),
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        } else {
          List<Booking> pastBookings = snapshot.data ?? [];
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Booking History",
                style: TextStyles.boldAccent24,
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: AppTheme.primaryColor,
              ),
            ),
            body: Padding(
              padding: horizontalPadding24,
              child: pastBookings.isNotEmpty
                  ? ListView.builder(
                itemCount: pastBookings.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isArtist =
                      user.userInfo!.userType! == UserType.artist;
                  return FutureBuilder<User?>(
                    future: databaseService.getUser(
                      userId: isArtist
                          ? pastBookings[index].hostId!
                          : pastBookings[index].artistId!,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState ==
                              ConnectionState.done) {
                        return Padding(
                          padding: verticalPadding12,
                          child: BookingSummaryCard(
                            userType: user.userInfo!.userType!,
                            user: snapshot.data!,
                            booking: pastBookings[index],
                            bookingButton: true,
                          ),
                        );
                      } else {
                        return Center(
                          child: Lottie.asset(
                            'assets/loading.json',
                            fit: BoxFit.fill,
                          ),
                        );
                      }
                    },
                  );
                },
              )
                  : Center(
                child: Text(
                  "No past booking.",
                  style: TextStyles.semiBoldAccent14,
                ),
              ),
            ),
          );
        }
      },
    );
  }


/*
  return FutureBuilder<User?>(
                                            future: firestoreDatabaseService.getUser(
                                                userId: pendingBookings[index].artistId!),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                return Padding(
                                                  padding: verticalPadding8,
                                                  child: InkWell(
                                                    onTap: () => context.pushNamed(
                                                      'profile',
                                                      pathParameters: {'userId': pendingBookings[index].artistId!},
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
                                                                      .semiBoldAccent14,)),
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
                                                                            .semiBoldAccent14,),
                                                                      Text(pendingBookings[index].spaces!,
                                                                        style: TextStyles
                                                                            .semiBoldAccent14,),
                                                                    ]
                                                                ),
                                                                verticalMargin12,
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text('Days: ', style: TextStyles
                                                                          .semiBoldAccent14,),
                                                                      Text(
                                                                        BookingService()
                                                                            .daysBetween(
                                                                            pendingBookings[index].from!,
                                                                            pendingBookings[index].to!)
                                                                            .toString(),
                                                                        style: TextStyles
                                                                            .semiBoldAccent14,),
                                                                    ]
                                                                ),

                                                                verticalMargin12,
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text('From: ', style: TextStyles
                                                                          .semiBoldAccent14,),
                                                                      Text(
                                                                        DateFormat.yMMMEd().format(
                                                                            pendingBookings[index].from!),
                                                                        style: TextStyles
                                                                            .semiBoldAccent14,),
                                                                    ]
                                                                ),
                                                                verticalMargin12,
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text('To: ', style: TextStyles
                                                                        .semiBoldAccent14,),
                                                                    Text(DateFormat.yMMMEd().format(
                                                                        pendingBookings[index].to!),
                                                                      style: TextStyles
                                                                          .semiBoldAccent14,),
                                                                  ],
                                                                ),
                                                                verticalMargin12,
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text('Price: ', style: TextStyles
                                                                        .semiBoldAccent14,),
                                                                    // Text('${booking!.spaces!} spaces X ${daysBetween(booking!.from!, booking!.to!)} days X ${int.parse(user!.bookingSettings!.basePrice!).toDouble()} GBP',
                                                                    //   style: TextStyles.semiBoldAccent14, ),
                                                                    Text('${pendingBookings[index].price!} GBP',
                                                                      style: TextStyles
                                                                          .semiBoldAccent14,),
                                                                  ],
                                                                ),
                                                                verticalMargin12,
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text('Commission (15%): ',
                                                                      style: TextStyles
                                                                          .semiBoldAccent14,),
                                                                    Text(
                                                                      '${pendingBookings[index].commission!} GBP',
                                                                      style: TextStyles
                                                                          .semiBoldAccent14,),
                                                                  ],
                                                                ),
                                                                verticalMargin12,
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text('Total price: ',
                                                                      style: TextStyles
                                                                          .semiBoldAccent14,),
                                                                    Text(
                                                                      '${pendingBookings[index].totalPrice!} GBP',
                                                                      style: TextStyles
                                                                          .semiBoldAccent14,),
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
                                                                          onPressed: () => context.read<BookingRequestCubit>().rejectBooking(pendingBookings[index], user!),
                                                                          child: Text('Reject' ,style: TextStyles.semiBoldAccent14.copyWith(
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
                                                                          onPressed: () => context.read<BookingRequestCubit>().acceptBooking(pendingBookings[index], user!),
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
   */
}
