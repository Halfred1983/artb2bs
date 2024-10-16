import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/host/view/payout_info_page.dart';
import 'package:artb2b/host/view/settings/host_venue_booking_setting_page.dart';
import 'package:artb2b/host/view/settings/host_venue_info_page.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/view/7_venue_photo.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/utils/user_utils.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';
import '../../app/resources/theme.dart';
import '../../onboard/cubit/onboarding_state.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/exclamation_icon.dart';
import '../../widgets/host_widget.dart';
import '../../widgets/loading_screen.dart';
import 'settings/host_booking_availability_page.dart';

class HostSettingPage extends StatelessWidget {
  static const String routeName = '/hostSetting';

  static Route<void> route({int initialIndex = 0}) {
    return MaterialPageRoute<void>(
      builder: (_) => HostSettingPage(initialIndex: initialIndex,),
      settings: RouteSettings(name: routeName),
    );
  }

  final int initialIndex;

  HostSettingPage({Key? key, this.initialIndex = 0}) : super(key: key);

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<OnboardingCubit>(
        create: (context) => OnboardingCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child: HostSettingView(initialIndex: initialIndex),
      );
  }
}


class HostSettingView extends StatefulWidget {
  final int initialIndex;

  const HostSettingView({super.key, this.initialIndex = 0});

  @override
  State<HostSettingView> createState() => _HostSettingViewState();
}

class _HostSettingViewState extends State<HostSettingView> {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is LoadedState) {
              user = state.user;
            }
            return Scaffold(
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  title: Text(user!.userInfo!.name!, style: TextStyles.boldN90017,),
                  centerTitle: true,
                  iconTheme: const IconThemeData(
                    color: AppTheme.n900, //change your color here
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48.0),
                    child: SegmentedButton(
                      segments: [
                        ButtonSegment(value: 0, label: Text('Listing preview', style: TextStyles.boldN90014,)),
                        ButtonSegment(value: 1, label: Text('Listing settings', style: TextStyles.boldN90014,)),
                      ],
                      selected: {_selectedIndex},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _selectedIndex = newSelection.first;
                        });
                      },
                    ),
                  ),
                ),
              body: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: _selectedIndex == 0 ?
                _buildVenuePreview(user!) :
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 96,
                        padding: horizontalPadding24 + verticalPadding24,
                        child: SwitchListTile(
                          subtitle: Text('When Active artists can book you',
                            style: TextStyles.regularN90012),
                          activeColor: AppTheme.accentColor,
                          inactiveTrackColor: AppTheme.n900.withOpacity(0.2),
                          onChanged: (value) {
                            List<VenueInformationMissing> missingInfo = UserUtils.isUserInformationComplete(user!);
                            if (missingInfo.isNotEmpty && !user!.bookingSettings!.active!) {

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomAlertDialog(
                                    type: AlertType.error,
                                    title: 'Incomplete Information',
                                    content: 'You need to fix the errors before setting your venue as active.',
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              context.read<OnboardingCubit>().setActive(value);
                            }
                          },
                          value: user!.bookingSettings!.active!,
                          title: Text(
                            'Active', style: TextStyles.regularN90014),
                        ),
                      ),
                      _buildVenueSettings(user!),
                    ],
                  ),
              ),
            );
          },
      );
  }

  Widget _buildVenuePreview(User user) {
   return Padding(
       padding: horizontalPadding24 + verticalPadding24,
       child: HostProfileWidget(user: user));
  }

  Widget _buildVenueSettings(User user) {

    final List<String> tileTitles = [
      'About Venue',
      'Add/Edit photos',
      'Payout Settings',
      'Booking Settings',
      'Booking Availability'
    ];

    List<VenueInformationMissing> missingInfo = UserUtils.isUserInformationComplete(user);

    return Padding(
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
              isMissing = missingInfo.any((info) => info.category == VenueInformationMissingCategory.venue);
              targetPage = HostVenueInfoPage();
              break;
            case 1:
              isMissing = missingInfo.any((info) => info.category == VenueInformationMissingCategory.photo);
              targetPage = VenuePhotoPage(isOnboarding: false,);
              break;
            case 2:
              isMissing = missingInfo.any((info) => info.category == VenueInformationMissingCategory.payout);
              targetPage = PayoutInfoPage();
              break;
            case 3:
              isMissing = missingInfo.any((info) => info.category == VenueInformationMissingCategory.booking);
              targetPage = HostBookingSettingsPage();
              break;
            case 4:
              targetPage = HostBookingAvailabilityPage();
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
    );
  }
}



