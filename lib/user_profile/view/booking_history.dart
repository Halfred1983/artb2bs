import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/booking_summary_card.dart';
import 'package:artb2b/widgets/summary_card.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';

import '../../app/resources/styles.dart';

class BookingHistory extends StatelessWidget {
  const BookingHistory({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    var pastBookings = user.bookings != null ?
    user.bookings!.where((element) => element.to!.isBefore(DateTime.now())).toList() : [];

    return Scaffold(
        appBar: AppBar(
          title: Text("Booking History", style: TextStyles.boldAccent24,),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: AppTheme.primaryColourViolet, //change your color here
          ),
        ),
        body: Padding(
            padding: horizontalPadding24,
            child: pastBookings.isNotEmpty ?
            ListView.builder(
              itemCount: pastBookings.length,
              itemBuilder: (BuildContext context, int index) {
                return BookingSummaryCard(userType: user.userInfo!.userType!,
                    user: user, booking: pastBookings[index]);
              },
            ): Center(child: Text("No past booking." , style: TextStyles.semiBoldViolet16,)))
    );
  }
}
