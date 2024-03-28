
import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/booking/service/booking_service.dart';
import 'package:artb2b/booking/view/booking_page.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingSummaryCard extends StatelessWidget {
  BookingSummaryCard({
    super.key,
    required this.userType,
    required this.user,
    required this.booking,
    this.bookingButton = false
  });

  final UserType userType;
  final User user;
  final Booking booking;
  bool bookingButton;

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
                  style: TextStyles.semiBoldAccent14,),
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
                    style: TextStyles.semiBoldAccent14,),
                  Flexible(child: Text(user
                      .userInfo!.address!
                      .city,
                    softWrap: true, style: TextStyles
                        .semiBoldAccent14,))
                ] else ...[
                  Text("Address: ",
                    style: TextStyles.semiBoldAccent14,),
                  Flexible(child: Text(user
                      .userInfo!.address!
                      .formattedAddress,
                    softWrap: true, style: TextStyles
                        .semiBoldAccent14,)),
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
                            .semiBoldAccent14,),
                      Text(booking.spaces!,
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
                            booking.from!,
                            booking.to!)
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
                            booking.from!),
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
                        booking.to!),
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
                    Text('${booking.price!} GBP',
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
                      '${booking.commission!} GBP',
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
                      '${booking.totalPrice!} GBP',
                      style: TextStyles
                          .semiBoldAccent14,),
                  ],
                ),
                verticalMargin12,
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .start,
                  children: [
                    Text('Status: ',
                      style: TextStyles
                          .semiBoldAccent14,),
                    Text(
                      booking.bookingStatus!.name.capitalize(),
                      style: TextStyles
                          .semiBoldAccent14.withColor(booking.bookingStatus!.name.getColorForBookingStatus()),),
                  ],
                ),
              ],
            ),
            if(user.userInfo!.userType! == UserType.gallery && bookingButton) ...[
              verticalMargin24,
              ElevatedButton(
                onPressed:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingPage(host: user,)),
                  );
                  // context.read<BookingCubit>().save();
                },
                child: Text("Book again", style: TextStyles.semiBoldAccent14,),
              )
            ] else ...[Container()] ,
          ]
      ),
    );
  }
}