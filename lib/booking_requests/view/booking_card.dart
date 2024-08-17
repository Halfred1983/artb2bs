import 'dart:io';

import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/booking/service/booking_service.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_cubit.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/common.dart';


class BookingCard extends StatelessWidget {
  final Booking booking;
  final User host;
  final User artist;
  final User user;
  final ValueChanged<Booking> onTap;
  bool isEmbedded = false;

  BookingCard({
    required this.booking,
    required this.host,
    required this.artist,
    required this.user,
    required this.onTap,
    this.isEmbedded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: verticalPadding8,
      child: InkWell(
        onTap: () => onTap(booking),
        child: CommonCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      breakLineAtWord(DateFormat('MMMM EEE, d').format(booking.from!), ' '),
                      style: TextStyles.boldN90012,
                    ),
                  ),
                  horizontalMargin12,
                  SizedBox(
                    height: 66,
                    child: VerticalDivider(
                      color: booking.bookingStatus!.name.getColorForBookingStatus(),
                      thickness: 0.5,
                    ),
                  ),
                  horizontalMargin12,
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text('Booking id', style: TextStyles.regularN10012),
                                SelectableText(
                                  booking.bookingId!.extractBookingId(),
                                  style: TextStyles.boldN90014,
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            StatusLabel(booking: booking),
                          ],
                        ),
                        verticalMargin12,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Venue name', style: TextStyles.regularN10012),
                                Text(host.userInfo!.name!, style: TextStyles.semiBoldN90012),
                              ],
                            ),
                            horizontalMargin16,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Days', style: TextStyles.regularN10012),
                                Text(
                                  BookingService().daysBetween(booking.from!, booking.to!).toString(),
                                  style: TextStyles.semiBoldN90012,
                                ),
                              ],
                            ),
                            horizontalMargin16,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Spaces', style: TextStyles.regularN10012),
                                Text(booking.spaces!, style: TextStyles.semiBoldN90012),
                              ],
                            ),
                          ],
                        ),
                        if (user.id == booking.hostId)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              verticalMargin12,
                              Text('Artist name', style: TextStyles.regularN10012),
                              Text(artist.artInfo!.artistName!, style: TextStyles.semiBoldN90012),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (booking.bookingStatus == BookingStatus.pending && user.userInfo!.userType == UserType.gallery)
                Padding(
                  padding: verticalPadding16,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 30,
                          child: OutlinedButton(
                            onPressed: () => context.read<BookingRequestCubit>().rejectBooking(booking, user),
                            child: Text(
                              'Reject',
                              style: TextStyles.semiBoldAccent14.copyWith(decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ),
                      horizontalMargin12,
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () => context.read<BookingRequestCubit>().acceptBooking(booking, user, artist),
                            child: Text('Accept', style: TextStyles.semiBoldAccent14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


String breakLineAtWord(String text, String word) {
  int index = text.indexOf(word);
  if (index != -1) {
    return text.substring(0, index + word.length) + '\n' + text.substring(index + word.length);
  }
  return text;
}

_whatsapp() async {
  String contact = "656756200";
  String text = '';
  String androidUrl = "whatsapp://send?phone=$contact&text=$text";
  String iosUrl = "https://wa.me/$contact?text=${Uri.parse(text)}";

  String webUrl = 'https://api.whatsapp.com/send/?phone=$contact&text=hi';

  try {
    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(iosUrl))) {
        await launchUrl(Uri.parse(iosUrl));
      }
    } else {
      if (await canLaunchUrl(Uri.parse(androidUrl))) {
        await launchUrl(Uri.parse(androidUrl));
      }
    }
  } catch(e) {
    print('object');
    await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
  }
}

_launchUrl(String webUrl) async {
  await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
}


class StatusLabel extends StatelessWidget {
  const StatusLabel({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: booking.bookingStatus!.name.getBackgroundColorForBookingStatus(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(booking.bookingStatus!.name.toString().capitalize(),
        style:
        TextStyles.semiBoldSV30014
            .withColor(booking.bookingStatus!.name.getColorForBookingStatus()),),
    );
  }


}


