import 'package:flutter/material.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:artb2b/booking_requests/view/booking_dialog.dart';
import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/injection.dart';
import 'package:database_service/database.dart';

class BookingUtils {
  static void showBookingDetails(BuildContext context, Booking booking, User user) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder<User?>(
            future: locator<FirestoreDatabaseService>().getUser(userId: booking.hostId!),
            builder: (context, hostSnapshot) {
              if (hostSnapshot.connectionState == ConnectionState.done && hostSnapshot.hasData) {
                return FutureBuilder<User?>(
                  future: locator<FirestoreDatabaseService>().getUser(userId: booking.artistId!),
                  builder: (context, artistSnapshot) {
                    if (artistSnapshot.connectionState == ConnectionState.done && artistSnapshot.hasData) {
                      return BookingDetailsDialog(
                        booking: booking,
                        host: hostSnapshot.data!,
                        artist: artistSnapshot.data!,
                        currentUser: user,
                      );
                    }
                    return const LoadingScreen();
                  },
                );
              }
              return const LoadingScreen();
            },
          );
        },
      );
    });
  }
}