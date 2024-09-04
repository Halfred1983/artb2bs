
import 'package:database_service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../app/resources/styles.dart';
import '../app/resources/theme.dart';
import '../booking/service/booking_service.dart';
import '../utils/common.dart';
import '../utils/currency/currency_helper.dart';
import 'common_card_widget.dart';

class SummaryCard extends StatelessWidget {
  SummaryCard({
    super.key,
    required this.booking,
    required this.host,
    required this.currentUser,
    this.padding,
    this.title
  });

  final Booking? booking;
  final User host;
  final User currentUser;
  EdgeInsets? padding;
  String? title;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
        borderRadius: BorderRadius.zero,
        boxShadow: const BoxShadow(
          color: Colors.transparent, // Makes the shadow completely transparent
          spreadRadius: 0,
          blurRadius: 0,
          offset: Offset(0, 0), // No offset from the container
        ),
        padding: padding ?? const EdgeInsets.only(right: 20, left: 20, top: 16),
        child: Column(
          children: [
            Text(title ?? 'Booking details:', style: TextStyles.boldN90017, ),
            verticalMargin16,
            const Divider(thickness: 0.5, color: AppTheme.divider,),
            verticalMargin16,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Venue name', style: TextStyles.regularN10012),
                    Text(host.userInfo!.name!, style: TextStyles.boldN90017),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 3 * horizontalPadding32.horizontal, // Adjust width to fit within screen bounds considering padding
                      child: Text(
                        host.userInfo!.address!.formattedAddress,
                        softWrap: true,
                        style: TextStyles.semiBoldN90012,
                        maxLines: 4, // Allow up to 2 lines
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Booking id', style: TextStyles.regularN10012),
                    Container(
                        height: 30,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: AppTheme.n900,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        child: Center(
                          child: SelectableText(booking!.bookingId!.extractBookingId(),
                            style: TextStyles.semiBoldAccent14,),
                        )
                    )
                  ],
                ),
              ],
            ),
            verticalMargin16,
            Container(
              height: 70,
              padding: const EdgeInsets.all(16),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: AppTheme.s50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From', style: TextStyles.regularN10012),
                      Text(
                        DateFormat.yMMMEd().format(booking!.from!),
                        style: TextStyles.boldN90012, ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To', style: TextStyles.regularN10012),
                      Text(
                        DateFormat.yMMMEd().format(booking!.to!),
                        style: TextStyles.boldN90012, ),
                    ],
                  ),
                ],
              ),
            ),
            verticalMargin16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Days', style: TextStyles.regularN10012),
                    Text(BookingService().daysBetween(booking!.from!, booking!.to!).toString(),
                      style: TextStyles.boldN90016, ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Spaces', style: TextStyles.regularN10012),
                    Text(booking!.spaces!,
                      style: TextStyles.boldN90016,textAlign: TextAlign.center, ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price/space', style: TextStyles.regularN10012),
                    Text('${double.parse(host.bookingSettings!.basePrice!)} ${CurrencyHelper.currency(host.userInfo!.address!.country).currencySymbol}',
                      style: TextStyles.boldN90016, ),
                  ],
                ),
              ],
            ),
            verticalMargin16,
            const Divider(thickness: 0.5, color: AppTheme.divider,),
            verticalMargin16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(flex: 1, child: Container(),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total/Day', style: TextStyles.regularN10012),

                    Text('${BookingService().calculatePricePerDay(double.parse(host.bookingSettings!.basePrice!),
                        int.parse(booking!.spaces!))} ${CurrencyHelper.currency(host.userInfo!.address!.country).currencySymbol}',
                      style: TextStyles.boldN90016, ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total', style: TextStyles.regularN10012),
                    Text('${BookingService().calculatePrice(booking!, host!)} ${CurrencyHelper.currency(host.userInfo!.address!.country).currencySymbol}',
                      style: TextStyles.boldN90016, ),
                    if(currentUser.id == booking!.hostId) ...[

                    verticalMargin16,
                    Text('ArtB2B Commission', style: TextStyles.regularN10012),
                    Text('${double.parse(booking!.commission!)} ${CurrencyHelper.currency(host.userInfo!.address!.country).currencySymbol}',
                      style: TextStyles.boldN90016, ),
                    ]

                  ],
                ),

              ],
            ),
            verticalMargin16
          ],
        )
    );
  }
}