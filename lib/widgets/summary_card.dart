
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app/resources/styles.dart';
import '../booking/service/booking_service.dart';
import '../utils/common.dart';
import 'common_card_widget.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.booking,
    required this.host,
  });

  final Booking? booking;
  final User host;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
        child: Column(
          children: [
            Text('Your booking details:', style: TextStyles.semiBoldAccent18, ),
            const Divider(thickness: 0.6, color: Colors.black38,),
            Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Spaces: ', style: TextStyles.semiBoldAccent16, ),
                      Text(booking!.spaces!, style: TextStyles.semiBoldViolet16, ),
                    ]
                ),
                verticalMargin12,
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Days: ', style: TextStyles.semiBoldAccent16, ),
                      Text(BookingService().daysBetween(booking!.from!, booking!.to!).toString(), style: TextStyles.semiBoldViolet16, ),
                    ]
                ),
                verticalMargin12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Price per day: ', style: TextStyles.semiBoldAccent16, ),
                    Text('${double.parse(host.bookingSettings!.basePrice!)} GBP', style: TextStyles.semiBoldViolet16, ),
                  ],
                ),
                verticalMargin12,
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('From: ', style: TextStyles.semiBoldAccent16, ),
                      Text(
                        DateFormat.yMMMEd().format(booking!.from!), style: TextStyles.semiBoldViolet16, ),
                    ]
                ),
                verticalMargin12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('To: ', style: TextStyles.semiBoldAccent16, ),
                    Text(DateFormat.yMMMEd().format(booking!.to!), style: TextStyles.semiBoldViolet16, ),
                  ],
                ),
                verticalMargin12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Price: ', style: TextStyles.semiBoldAccent16, ),
                    // Text('${booking!.spaces!} spaces X ${daysBetween(booking!.from!, booking!.to!)} days X ${int.parse(user!.bookingSettings!.basePrice!).toDouble()} GBP',
                    //   style: TextStyles.semiBoldViolet16, ),
                    Text('${BookingService().calculatePrice(booking!, host!)} GBP',
                      style: TextStyles.semiBoldViolet16, ),
                  ],
                ),
                verticalMargin12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Commission (15%): ', style: TextStyles.semiBoldAccent16, ),
                    Text('${BookingService().calculateCommission(
                        BookingService().calculatePrice(booking!, host!))} GBP',
                      style: TextStyles.semiBoldViolet16, ),
                  ],
                ),
                verticalMargin12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Grand Total: ', style: TextStyles.semiBoldAccent16, ),
                    Text('${BookingService().calculateGrandTotal(BookingService().calculatePrice(booking!, host!),
                        BookingService().calculateCommission(BookingService().calculatePrice(booking!, host!)))} GBP',
                      style: TextStyles.semiBoldViolet16, ),
                  ],
                ),
              ],
            )
          ],
        )
    );
  }
}