
import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/booking/service/booking_service.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({
    super.key,
    required this.userType,
    required this.user,
    required this.booking,
  });

  final UserType userType;
  final User user;
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
          children: [
            Row(
              children: [
                Image.asset(userType == UserType.gallery ?
                'assets/images/artist.png' : 'assets/images/gallery.png',
                  width: 40,),
                horizontalMargin12,
                Text(user.userInfo!.name!,
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
                if(user.userInfo!.userType! == UserType.artist) ...[
                  Text("City: ",
                    style: TextStyles.boldViolet14,),
                  Flexible(child: Text(user
                      .userInfo!.address!
                      .city,
                    softWrap: true, style: TextStyles
                        .semiBoldViolet14,))
                ] else ...[
                  Text("Address: ",
                    style: TextStyles.boldViolet14,),
                  Flexible(child: Text(user
                      .userInfo!.address!
                      .formattedAddress,
                    softWrap: true, style: TextStyles
                        .semiBoldViolet14,)),
                ]

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
                      Text(booking.spaces!,
                        style: TextStyles
                            .semiBoldViolet14,),
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
                            booking.from!,
                            booking.to!)
                            .toString(),
                        style: TextStyles
                            .semiBoldViolet14,),
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
                            booking.from!),
                        style: TextStyles
                            .semiBoldViolet14,),
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
                        booking.to!),
                      style: TextStyles
                          .semiBoldViolet14,),
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
                          .semiBoldViolet14,),
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
                      '${booking.commission!} GBP',
                      style: TextStyles
                          .semiBoldViolet14,),
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
                      '${booking.totalPrice!} GBP',
                      style: TextStyles
                          .semiBoldViolet14,),
                  ],
                ),
                verticalMargin12,
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .start,
                  children: [
                    Text('Status: ',
                      style: TextStyles
                          .semiBoldAccent16,),
                    Text(
                      booking.bookingStatus!.name,
                      style: TextStyles
                          .semiBoldViolet14,),
                  ],
                ),
              ],
            )
          ]
      ),
    );
  }
}