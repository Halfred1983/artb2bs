import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/host/cubit/host_state.dart';
import 'package:artb2b/onboard/view/10_venue_opening_time.dart';
import 'package:artb2b/onboard/view/3_venue_info.dart';
import 'package:artb2b/onboard/view/4_venue_address.dart';
import 'package:artb2b/onboard/view/8_venue_description.dart';
import 'package:artb2b/onboard/view/9_venue_audience.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/utils/user_utils.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection.dart';
import '../../../app/resources/theme.dart';
import '../../../calendar_availability/view/calendar_availability_page.dart';
import '../../../onboard/view/5_venue_spaces.dart';
import '../../../space_availability/view/space_availability_page.dart';
import '../../../widgets/exclamation_icon.dart';
import '../../../widgets/loading_screen.dart';
import '../../cubit/host_cubit.dart';

class HostVenueInfoPage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => HostVenueInfoPage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<HostCubit>(
        create: (context) => HostCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child: const HostVenueInfoView(),
      );
  }
}


class HostVenueInfoView extends StatefulWidget {
  const HostVenueInfoView({super.key});

  @override
  State<HostVenueInfoView> createState() => _HostVenueInfoViewState();
}

class _HostVenueInfoViewState extends State<HostVenueInfoView> {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  final List<String> tileTitles = [
    'Venue name',
    'Venue address',
    'Venue description',
    'Venue audience',
    'Venue spaces',
    'Venue opening hours',
  ];

  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<HostCubit, HostState>(
        builder: (context, state) {
          if(state is BookingSettingsDetail) {
          }
          if (state is LoadingState) {
            return const LoadingScreen();
          }
          if (state is LoadedState) {
            user = state.user;
          }
          List<VenueInformationMissing> missingInfo = UserUtils.isVenueInformationComplete(user!);

          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: Text(user!.userInfo!.name!, style: TextStyles.boldN90017,),
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: AppTheme.n900, //change your color here
              ),
            ),
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: verticalPadding24,
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: horizontalPadding8,
                  itemCount: tileTitles.length,
                  itemBuilder: (context, index) {
                    bool isMissing = false;
                    Widget targetPage = Container();
                    switch (index) {
                      case 0:
                        isMissing = missingInfo.any((info) => info.category == VenueInformationMissingCategory.type);
                        targetPage = VenueInfoPage(isOnboarding: false,);
                        break;
                      case 1:
                        isMissing = missingInfo.any((info) => info.category == VenueInformationMissingCategory.venue);
                        targetPage = VenueAddressPage(isOnboarding: false,);
                        break;
                      case 2:
                        isMissing = missingInfo.any((info) => info.category == VenueInformationMissingCategory.venueDescription);
                        targetPage = VenueDescription(isOnboarding: false,);
                        break;
                      case 3:
                        isMissing = missingInfo.any((info) => info.category == VenueInformationMissingCategory.vibes);
                        targetPage = VenueAudience(isOnboarding: false,);
                        break;
                      case 4:
                        targetPage = VenueSpacesPage(isOnboarding: false,);
                        break;
                      case 5:
                        isMissing = missingInfo.any((info) => info.category == VenueInformationMissingCategory.openingHours);
                        targetPage = VenueOpeningTime(isOnboarding: false,);
                        break;
                    }

                    return InkWell (
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => targetPage),
                        );
                      },
                      child: Container(
                        height: 90,
                        padding: horizontalPadding32,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5),
                            bottom: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                        child: Center(
                          child: ListTile(
                            contentPadding: horizontalPadding8,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(tileTitles[index], style: TextStyles.regularN90014,),
                                    if (isMissing) ...[
                                      horizontalMargin8,
                                      const ExclamationIcon()
                                    ]
                                  ],
                                ),
                                const Icon(Icons.play_arrow_sharp, color: AppTheme.n900, size: 20,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => verticalMargin8,
                ),
              )
            ),
          );
        },
      );
  }
}
