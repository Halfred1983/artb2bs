import 'dart:io';

import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/booking/service/booking_service.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_cubit.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_state.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:artb2b/widgets/summary_card.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../injection.dart';
import '../../../utils/common.dart';
import '../../app/resources/theme.dart';
import '../../widgets/photo_grid.dart';
import '../../widgets/scollable_chips.dart';
import 'booking_card.dart';


class BookingList extends StatelessWidget {
  final User user;
  final List<Booking> bookings;
  final ValueChanged<Booking> onBookingTap;
  bool isEmbedded = false;

  BookingList({
    required this.user,
    required this.bookings,
    required this.onBookingTap,
    this.isEmbedded = false
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Padding(
        padding: horizontalPadding24,
        child: Text(
          'No bookings for the selected criteria',
          style: TextStyles.boldN90029,
        ),
      );
    }

    return Padding(
      padding: isEmbedded ? EdgeInsets.zero : horizontalPadding32,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return FutureBuilder<User?>(
            future: locator<FirestoreDatabaseService>().getUser(userId: bookings[index].hostId!),
            builder: (context, hostSnapshot) {
              if (hostSnapshot.connectionState == ConnectionState.done && hostSnapshot.hasData) {
                return FutureBuilder<User?>(
                  future: locator<FirestoreDatabaseService>().getUser(userId: bookings[index].artistId!),
                  builder: (context, artistSnapshot) {
                    if (artistSnapshot.connectionState == ConnectionState.done && artistSnapshot.hasData) {
                      return BookingCard(
                        booking: bookings[index],
                        host: hostSnapshot.data!,
                        artist: artistSnapshot.data!,
                        user: user,
                        onTap: onBookingTap,
                        isEmbedded: isEmbedded,
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
      ),
    );
  }
}
