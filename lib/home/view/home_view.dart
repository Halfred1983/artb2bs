import 'package:artb2b/app/profile/view/profile_page.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/artwork/view/artist_dashboard_page.dart';
import 'package:artb2b/home/bloc/user_cubit.dart';
import 'package:artb2b/home/bloc/user_state.dart';
import 'package:artb2b/onboard/view/personal_info_page.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:artb2b/widgets/map_view.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../login/cubit/login_cubit.dart';
import '../../login/view/login_page.dart';
import '../../onboard/view/art_info_page.dart';
import '../../utils/common.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  var _currentIndex = 0;


  static List<Widget> _widgetOptions = <Widget>[
    ArtistDashboardPage(),
    ArtistDashboardPage(),
    ArtistDashboardPage(),
    ProfilePage(),
  ];

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
            }
            return Scaffold(
              body: Stack(
                  children: [
                    _currentIndex == 0 ? widget : _widgetOptions.elementAt(_currentIndex),
                  ]
              ),
              bottomNavigationBar:
              Padding(
                padding: horizontalPadding24,
                child: SalomonBottomBar(
                  currentIndex: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
                  items: [
                    /// Home
                    SalomonBottomBarItem(
                      icon: Icon(Icons.home),
                      title: Text("Home"),
                      selectedColor: AppTheme.primaryColourViolet,
                    ),

                    /// Likes
                    SalomonBottomBarItem(
                      icon: Icon(Icons.image_rounded),
                      title: Text("Artwork"),
                      selectedColor: AppTheme.primaryColourViolet,
                    ),

                    /// Search
                    SalomonBottomBarItem(
                      icon: Icon(Icons.search),
                      title: Text("Search"),
                      selectedColor: AppTheme.primaryColourViolet,
                    ),

                    /// Profile
                    SalomonBottomBarItem(
                      icon: Icon(Icons.person),
                      title: Text("Profile"),
                      selectedColor: AppTheme.primaryColourViolet,
                    ),
                  ],
                ),
              ),
            );
          }
      );
  }
}
