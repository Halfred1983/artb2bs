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

class BookingDetailsDialog extends StatelessWidget {
  final Booking booking;
  final User host;
  final User artist;
  final User currentUser;

  BookingDetailsDialog({
    required this.booking,
    required this.host,
    required this.artist,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: horizontalPadding24,
          child: Container(
            padding: verticalPadding32 + horizontalPadding24,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StatusLabel(booking: booking),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  verticalMargin16,
                  SummaryCard(booking: booking, host: host, currentUser: currentUser,
                      title: 'Booking details', padding: EdgeInsets.zero),
                  verticalMargin16,
                  const Divider(thickness: 0.5, color: AppTheme.divider),

                  if (currentUser.id == booking.hostId) ...[
                    verticalMargin16,
                    Text('Requesting artist', style: TextStyles.boldN90017),
                    verticalMargin8,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${artist.artInfo!.artistName!}', style: TextStyles.semiBoldN90014),
                        verticalMargin8,
                        Text('Location: ${artist.userInfo!.address!.city}', style: TextStyles.semiBoldN90014),
                        verticalMargin8,
                        StreamBuilder(
                          stream: locator<FirestoreDatabaseService>().findArtworkByUser(user: artist),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text("Loading");
                            }
                            if (snapshot.hasData) {
                              User artistData = User.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                              var collectionWithPhotos = artistData.artInfo!.collections.firstWhere(
                                    (collection) => collection.artworks.isNotEmpty,
                                orElse: () => Collection(artworks: []),
                              );
                              if (collectionWithPhotos.artworks.isNotEmpty) {
                                return PhotoGridWidget(
                                  artworks: collectionWithPhotos.artworks,
                                  moreCount: collectionWithPhotos.artworks.length > 4 ? collectionWithPhotos.artworks.length - 4 : 0,
                                );
                              } else {
                                return Text('The artist has no artwork yet', style: TextStyles.semiBoldN90014);
                              }
                            }
                            return Container();
                          },
                        ),
                      ],
                    )
                  ] else...[
                    verticalMargin16,
                    Text('Venue details', style: TextStyles.boldN90017),
                    verticalMargin16,
                    GestureDetector(
                      onTap: () async {
                        final availableMaps = await MapLauncher.installedMaps;
                        await availableMaps.first.showMarker(
                          coords: Coords(host.userInfo!.address!.location!.latitude, host.userInfo!.address!.location!.longitude),
                          title: host.userInfo!.name!,
                        );
                      },
                      child: Text('📍 Venue location', style: TextStyles.semiBoldS40014),
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
                  ]
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

