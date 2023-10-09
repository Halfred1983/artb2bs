import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/artwork/view/artist_dashboard_page.dart';
import 'package:artb2b/booking_requests/view/booking_request_page.dart';
import 'package:artb2b/exhibition/view/exhibition_page.dart';
import 'package:artb2b/home/bloc/user_cubit.dart';
import 'package:artb2b/home/bloc/user_state.dart';
import 'package:artb2b/onboard/view/personal_info_page.dart';
import 'package:artb2b/profile/view/profile_page.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:artb2b/widgets/map_view.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../host/view/host_dashboard_page.dart';
import '../../onboard/view/art_info_page.dart';
import '../../utils/common.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  var _currentIndex = 0;


  List<Widget> _widgetOptions = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            Widget widget = Container();
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is LoadedState) {
              user = state.user;

              if (user!.userStatus == UserStatus.initialised) {
                return PersonalInfoPage();
              }
              if (user!.userStatus == UserStatus.personalInfo) {
                return ArtInfoPage();
              }

              widget =  MapView(user: user!);

              if(user!.userInfo!.userType == UserType.artist) {
                _widgetOptions = <Widget>[
                  widget,
                  ArtistDashboardPage(),
                  ExhibitionPage(),
                  ProfilePage(),
                ];
              }
              else {
                _widgetOptions = <Widget>[
                  widget,
                  HostDashboardPage(),
                  BookingRequestPage(),
                  ExhibitionPage(),
                  ProfilePage(),
                ];
              }
            }
            return Scaffold(
              body: Stack(
                  children: [
                    // _currentIndex == 0 ? widget : _widgetOptions.elementAt(_currentIndex),
                    _widgetOptions.elementAt(_currentIndex),
                  ]
              ),
              bottomNavigationBar:
              SalomonBottomBar(
                currentIndex: _currentIndex,
                onTap: (i) => setState(() => _currentIndex = i),
                items: [
                  /// Home
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.home),
                    title: const Text("Home"),
                    selectedColor: AppTheme.primaryColourViolet,
                  ),

                  /// Likes
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.dashboard),
                    title: const Text("Dashboard"),
                    selectedColor: AppTheme.primaryColourViolet,
                  ),

                  /// Requests
                  if(user!.userInfo!.userType != UserType.artist) ...[
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.add_alert_sharp),
                      title: const Text("Requests"),
                      selectedColor: AppTheme.primaryColourViolet,
                    ),
                  ],

                  /// Calendar
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.calendar_month),
                    title: const Text("Calendar"),
                    selectedColor: AppTheme.primaryColourViolet,
                  ),

                  /// Profile
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.person),
                    title: const Text("Profile"),
                    selectedColor: AppTheme.primaryColourViolet,
                  ),
                ],
              ),
            );
          }
      );
  }
}
