import 'dart:async';

import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/injection.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/fadingin_picture.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:artb2b/widgets/map_view.dart';
import 'package:artb2b/widgets/venue_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../app/resources/assets.dart';
import '../../user_profile/view/user_profile_page.dart';
import '../../utils/currency/currency_helper.dart';
import '../../utils/user_utils.dart';
import '../../widgets/tags.dart';

class HomeVenue extends StatefulWidget {
  HomeVenue({super.key, required this.user});
  final User user;

  @override
  State<HomeVenue> createState() => _HomeVenueState();
}

class _HomeVenueState extends State<HomeVenue> {
  final FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  final List<BookingStatus> _bookingStatus = BookingStatus.values;
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalPadding32,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalMargin12,
              Text("Hello, ${widget.user.userInfo!.name!}", style: TextStyles.semiBoldS40014,),
              Text("Welcome back!", style: TextStyles.boldN90029,),
            ],
          ),
          centerTitle: false,
          titleSpacing: 0,
          actions: [
            IconButton(
              icon: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Icon(
                  size: 20,
                  Icons.person,
                  color: AppTheme.n900,
                ),
              ),
              onPressed: () {
                // Add your action here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: firestoreDatabaseService.getUserStream(widget.user.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset(
                    'assets/loading.json',
                    fit: BoxFit.fill,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return Center(child: Text('No data available'));
              }
              final user = User.fromJson(snapshot.data!.data() as Map<String, dynamic>);
              return Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalMargin32,
                  if(!UserUtils.isUserInformationComplete(user)) ...[
                    Container(
                      padding: horizontalPadding16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.n100, width: 0.5),
                      ),
                      height: 100,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalMargin16,
                          Text('Information is missing', style: TextStyles.regularN90012,),
                          verticalMargin4,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Your listing is not visible yet', style: TextStyles.regularN50012.copyWith(color: AppTheme.d200),),
                              Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppTheme.d200)
                                  ),
                                  child: const Icon( FontAwesomeIcons.exclamation, color: AppTheme.d200, size: 15,)
                              ),
                            ],
                          ),
                          verticalMargin12,
                          Text('Edit', style: TextStyles.semiBoldN90012,)
                        ],
                      ),
                    ),
                    verticalMargin32,
                  ],
                  Text('Current Listings', style: TextStyles.boldN90014,),
                  verticalMargin16,
                  VenueCard(user: user, showActive: true,),
                  verticalMargin32,
                  Text('Reservations', style: TextStyles.boldN90014,),
                  Tags(
                    _bookingStatus.map((status) =>
                    status.name
                        .toString()
                        .split('.')
                        .last).toList(),
          
                    _bookingStatus
                        .where((status) => _selectedStatus == status.name.toString().split('.').last)
                        .map((status) => status.name.toString().split('.').last)
                        .toList(),
          
                        (selectedStatus) {
                      setState(() {
                        _selectedStatus = selectedStatus.isNotEmpty ? selectedStatus.first : null;
          
                      });
                      // context.read<OnboardingCubit>().updateBusinessDay(
                      //     _businessDays.firstWhere((day) =>
                      //         selectedDays.contains(day.dayOfWeek
                      //             .toString()
                      //             .split('.')
                      //             .last)));
                    },
                    isScrollable: true,
                    isMultiple: false,
                  ),
                  FutureBuilder<List<Booking>>(
                    future: firestoreDatabaseService.findBookingsByUser(user),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Lottie.asset(
                            'assets/loading.json',
                            fit: BoxFit.fill,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('You have no bookings yet.' , style: TextStyles.regularN90012,);
                      }
                      final bookings = snapshot.data!;
                      if(_selectedStatus != null) {
                        bookings.retainWhere((booking) => booking.bookingStatus == _selectedStatus);
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          return ListTile(
                            title: Text('Booking ID: ${booking.bookingId}'),
                            subtitle: Text('From: ${booking.from} To: ${booking.to}'),
                          );
                        },
                      );
                    },
                  ),
                  verticalMargin32
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
