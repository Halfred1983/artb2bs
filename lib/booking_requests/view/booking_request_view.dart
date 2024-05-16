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
import '../../widgets/scollable_chips.dart';

class BookingRequestView extends StatelessWidget {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  String _errorMessage = '';
  BookingRequestView({super.key});

  List<String> choices = ['All'] + BookingStatus.values.map((e) => e.name.capitalize()).toList();
  String _filter = 'All';


  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<BookingRequestCubit, BookingRequestState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is OverlapErrorState) {
              _errorMessage = state.message;
              return AlertDialog( // <-- SEE HERE
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),

                title: Center(child:Text('Error', style: TextStyles.semiBoldAccent14,)),
                content: Text(_errorMessage,textAlign: TextAlign.center, style: TextStyles.semiBoldAccent14,),
                actions: [
                  Center(child: TextButton(
                    onPressed: () {
                      context.read<BookingRequestCubit>().exitAlert(state.user); // Close the dialog
                    },
                    child: Text('OK', style: TextStyles.semiBoldAccent14,),
                  )),
                ],
              );
            }

            if (state is LoadedState || state is FilterState) {
              user = state.props[0] as User;

              _filter = state is FilterState ? state.filter : _filter;

              return Scaffold(
                  appBar: AppBar(
                    title: Padding(
                      padding: horizontalPadding32,
                      child: Text('Your Bookings', style: TextStyles.boldN90029,),
                    ),
                    backgroundColor: AppTheme.white,
                    centerTitle: false,
                    titleSpacing: 0,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: ShapeDecoration(
                            color: AppTheme.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Padding(
                            padding: horizontalPadding32,
                            child: ScrollableChips(choices: choices,
                              onSelectionChanged:
                                  (selectedValue) {
                                _filter = selectedValue;
                                context.read<BookingRequestCubit>().updateFilter(_filter, user!);
                              },
                              selectedValue: _filter,
                            ),
                          ),
                        ),
                        verticalMargin24,
                        StreamBuilder(
                            stream: firestoreDatabaseService.findBookingsByUserStream(user!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container(width: 200, height: 200, child: const LoadingScreen());
                              } else if (snapshot.connectionState == ConnectionState.active
                                  || snapshot.connectionState == ConnectionState.done) {

                                if (snapshot.hasData && snapshot.data != null) {

                                  List<Booking> bookings = snapshot.data!;
                                  if(_filter != 'All') {
                                    bookings = snapshot.data!
                                        .where((element) => element.bookingStatus == BookingStatus.values.byName(_filter.deCapitalize()))
                                        .toList();
                                  }

                                  if(bookings.isNotEmpty) {

                                    return Padding(
                                      padding: horizontalPadding32,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: bookings.length,
                                          itemBuilder: (context, index) {
                                            return FutureBuilder<User?>(
                                                future: firestoreDatabaseService.getUser(
                                                    userId: bookings[index].hostId!),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData &&
                                                      snapshot.connectionState ==
                                                          ConnectionState.done) {
                                                    return Padding(
                                                        padding: verticalPadding8,
                                                        child: InkWell(
                                                          onTap: () => _showBookingDetails(context,  bookings[index], snapshot.data!),


                                                          //     context.pushNamed(
                                                          //   'profile',
                                                          //   pathParameters: {'userId': !isArtist ?
                                                          //   bookings[index].artistId! :
                                                          //   bookings[index].hostId!},
                                                          // ),
                                                          child:
                                                          CommonCard(
                                                            padding: const EdgeInsets.all(16),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                          breakLineAtWord(DateFormat('MMMM EEE, d').format(bookings[index].from!), ' '),
                                                                          style: TextStyles.boldN90012,
                                                                        ),
                                                                      ),
                                                                      horizontalMargin12,
                                                                      SizedBox(height: 66, child: VerticalDivider(color:
                                                                      bookings[index].bookingStatus!.name.getColorForBookingStatus(),
                                                                        thickness: 0.5,)),
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
                                                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text('Booking id', style: TextStyles.regularN10012),
                                                                                    SelectableText(bookings[index].bookingId!.extractBookingId(),
                                                                                      style: TextStyles.boldN90014,)
                                                                                  ],
                                                                                ),
                                                                                Expanded(child: Container(),),
                                                                                StatusLabel( booking: bookings[index],),
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
                                                                                    Text(snapshot.data!.userInfo!.name!, style: TextStyles.semiBoldN90012),
                                                                                  ],
                                                                                ),
                                                                                horizontalMargin16,
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text('Days', style: TextStyles.regularN10012),
                                                                                    Text(BookingService().daysBetween(bookings[index]!.from!,
                                                                                        bookings[index]!.to!).toString(), style: TextStyles.semiBoldN90012),
                                                                                  ],
                                                                                ),
                                                                                horizontalMargin16,
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text('Spaces', style: TextStyles.regularN10012),
                                                                                    Text(bookings[index].spaces!, style: TextStyles.semiBoldN90012),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ]
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                    );
                                                  }
                                                  else {
                                                    return Center(
                                                        child: Lottie.asset(
                                                          'assets/loading.json',
                                                          fit: BoxFit.fill,
                                                        )
                                                    );
                                                  }
                                                }
                                            );

                                          }),
                                    );
                                  } else {
                                    return Padding(
                                      padding: horizontalPadding32,
                                      child: Center(
                                        child: Text('No bookings for the selected criteria',
                                          style: TextStyles.boldN90029,),
                                      ),
                                    );
                                  }
                                }
                                else {
                                  return Padding(
                                    padding: horizontalPadding32,
                                    child: Center(
                                      child: Text('No bookings for the selected criteria',
                                        style: TextStyles.boldN90029,),
                                    ),
                                  );
                                }
                              }
                              return Text('State: ${snapshot.connectionState}');
                            }
                        ),
                      ],
                    ),
                  )
              );
            }
            return Container();
          }
      );
  }

  String breakLineAtWord(String text, String word) {
    int index = text.indexOf(word);
    if (index != -1) {
      return text.substring(0, index + word.length) + '\n' + text.substring(index + word.length);
    }
    return text;
  }

  void _showBookingDetails(BuildContext context, Booking booking, User host) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: horizontalPadding24,
          child: Container(
            padding: verticalPadding32 + horizontalPadding24,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.all(Radius.circular(16))
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StatusLabel( booking: booking,),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  verticalMargin16,
                  SummaryCard(booking: booking, host: host, title: 'Booking details', padding: EdgeInsets.zero,),
                  verticalMargin16,
                  const Divider(thickness: 0.5, color: AppTheme.divider,),
                  verticalMargin16,
                  Text('Venue details', style: TextStyles.boldN90017),
                  verticalMargin16,
                  GestureDetector(
                    onTap: () async {
                      final availableMaps = await MapLauncher.installedMaps;
                      print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
                      await availableMaps.first.showMarker(
                        coords: Coords(host.userInfo!.address!.location!.latitude,
                            host.userInfo!.address!.location!.longitude),
                        title: host.userInfo!.name!,
                      );
                      // Implement your contact functionality
                    },
                    child: Text('📍 Venue location', style: TextStyles.semiBoldS40014,),
                  ),
                  verticalMargin16,
                  TextButton(
                    onPressed: () {
                      _whatsapp();
                    },
                    child: const Text('📞 Contact customer service'),
                  ),
                  verticalMargin16,
                  GestureDetector(
                    onTap: () {
                      _launchUrl('https://www.google.com');
                    },
                    child: Text('📝 Read T&Cs', style: TextStyles.semiBoldS40014),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

