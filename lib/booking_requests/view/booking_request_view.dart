import 'dart:io';

import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_cubit.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_state.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../injection.dart';
import '../../../utils/common.dart';
import '../../app/resources/theme.dart';
import '../../widgets/scollable_chips.dart';
import 'booking_dialog.dart';
import 'booking_list.dart';

class BookingRequestView extends StatelessWidget {
  final FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();
  final List<String> choices;
  String _filter = 'Pending';
  bool isEmbedded = false;

  BookingRequestView({
    super.key,
    this.isEmbedded = false,
    List<String>? choices,
  }) : choices = choices ?? ['All'] + BookingStatus.values.map((e) => e.name.capitalize()).toList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingRequestCubit, BookingRequestState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }
        if (state is OverlapErrorState) {
          return _buildErrorDialog(context, state.message, state.user);
        }
        if (state is LoadedState || state is FilterState) {
          User user = state.props[0] as User;
          _filter = state is FilterState ? state.filter : _filter;


          Widget body = SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildFilterSection(context, user),
                verticalMargin24,
                StreamBuilder(
                  stream: firestoreDatabaseService.findBookingsByUserStream(user),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: const LoadingScreen());
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      List<Booking> bookings = snapshot.data!;
                      if (_filter != 'All') {
                        bookings = bookings.where((element) =>
                        element.bookingStatus == BookingStatus.values.byName(_filter.deCapitalize())).toList();
                      }
                      bookings.sort((a, b) => b.from!.compareTo(a.from!)); // Sort by date descending
                      return BookingList(
                        isEmbedded: isEmbedded,
                        user: user,
                        bookings: bookings,
                        onBookingTap: (booking) => _showBookingDetails(context, booking, user),
                      );
                    } else {
                      return _buildEmptyState();
                    }
                  },
                ),
              ],
            ),
          );

          if(!isEmbedded) {
            return Scaffold(
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  title: Padding(
                    padding: horizontalPadding32,
                    child: Text('Your Bookings', style: TextStyles.boldN90029),
                  ),
                  backgroundColor: AppTheme.white,
                  centerTitle: false,
                  titleSpacing: 0,
                ),
                body: body
            );
          }

          return body;
        }
        return Container();
      },
    );
  }

  Widget _buildErrorDialog(BuildContext context, String message, User user) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: Center(child: Text('Error', style: TextStyles.semiBoldAccent14)),
      content: Text(message, textAlign: TextAlign.center, style: TextStyles.semiBoldAccent14),
      actions: [
        Center(
          child: TextButton(
            onPressed: () {
              context.read<BookingRequestCubit>().exitAlert(user);
            },
            child: Text('OK', style: TextStyles.semiBoldAccent14),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context, User user) {
    return Container(
      decoration: ShapeDecoration(
        color: isEmbedded ? AppTheme.backgroundColor : AppTheme.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: EdgeInsets.zero,
        child: ScrollableChips(
          choices: choices,
          onSelectionChanged: (selectedValue) {
            _filter = selectedValue;
            context.read<BookingRequestCubit>().updateFilter(_filter, user);
          },
          selectedValue: _filter,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: horizontalPadding32,
      child: Padding(
        padding: horizontalPadding24,
        child: Text('No bookings for the selected criteria', style: TextStyles.boldN90029),
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Booking booking, User user) {
    // Retrieve host and artist data and show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<User?>(
          future: firestoreDatabaseService.getUser(userId: booking.hostId!),
          builder: (context, hostSnapshot) {
            if (hostSnapshot.connectionState == ConnectionState.done && hostSnapshot.hasData) {
              return FutureBuilder<User?>(
                future: firestoreDatabaseService.getUser(userId: booking.artistId!),
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

