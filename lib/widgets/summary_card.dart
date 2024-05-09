
import 'package:database_service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    this.padding,
    this.title
  });

  final Booking? booking;
  final User host;
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
            Text(title ?? 'Your booking details:', style: TextStyles.boldN90017, ),
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
                    Text(host.userInfo!.address!.formattedAddress,
                      softWrap: true, style: TextStyles.semiBoldN90012,),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Booking id', style: TextStyles.regularN10012),
                    Container(
                        height: 30,
                        margin: const EdgeInsets.all(5),
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
                      style: TextStyles.boldN90012, ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Spaces', style: TextStyles.regularN10012),
                    Text(booking!.spaces!,
                      style: TextStyles.boldN90012, ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price/space', style: TextStyles.regularN10012),
                    Text('${double.parse(host.bookingSettings!.basePrice!)} ${CurrencyHelper.currency(host.userInfo!.address!.country).currencySymbol}',
                      style: TextStyles.boldN90012, ),
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
                      style: TextStyles.boldN90012, ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total', style: TextStyles.regularN10012),
                    Text('${BookingService().calculateGrandTotal(BookingService().calculatePrice(booking!, host!),
                        0)} ${CurrencyHelper.currency(host.userInfo!.address!.country).currencySymbol}',
                      style: TextStyles.boldN90012, ),
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