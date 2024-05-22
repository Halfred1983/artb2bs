import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';

import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:artb2b/artwork/view/artist_dashboard_page.dart';
import 'package:artb2b/booking_requests/view/booking_request_page.dart';
import 'package:artb2b/exhibition/view/exhibition_page.dart';
import 'package:artb2b/home/bloc/user_cubit.dart';
import 'package:artb2b/home/bloc/user_state.dart';
import 'package:artb2b/home/view/home_list_view.dart';
import 'package:artb2b/notification/bloc/notification_bloc.dart';
import 'package:artb2b/onboard/view/personal_info_page.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../explore/view/explore_page.dart';
import '../../host/view/host_dashboard_page.dart';
import '../../onboard/view/1_select_account.dart';
import '../../onboard/view/art_info_page.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key, this.index});

  int? index;

  @override
  State<HomeView> createState() => _HomeViewState(index);
}

class _HomeViewState extends State<HomeView> {

  var _currentIndex = 0;

  List<Widget> _widgetOptions = List.empty(growable: true);

  _HomeViewState(int? index) {
    _currentIndex = index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    User? user;
    int? pendingRequests;
    return  BlocListener<NotificationBloc, NotificationState>(
        listenWhen: (previous, current) {
          return previous != current &&
              current.notification != null &&
              current.appState != null;
        },
        listener: (context, state) {
          final notification = state.notification!;
          if (state.appState!.isForeground) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: ListTile(
                  title: Text(notification.title),
                  subtitle: Text(notification.body),
                ),
              ),
            );
          }
          if (state.appState!.isBackground) {
            if(notification.screen.isNotEmpty) {
              context.pushNamed(notification.screen);
            }
          }
        },
        child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              Widget widget = Container();
              if (state is LoadingState) {
                return const LoadingScreen();
              }
              if (state is LoadedState) {
                user = state.user;
                pendingRequests = state.pendingRequests;

                if (user!.userStatus == UserStatus.initialised) {
                  return SelectAccountPage();
                }
                if (user!.userStatus == UserStatus.personalInfo) {
                  return ArtInfoPage();
                }

                widget =  HomeList(user: user!);

                if(user!.userInfo!.userType == UserType.artist) {
                  _widgetOptions = <Widget>[
                    widget,
                    ExplorePage(),
                    ArtistDashboardPage(),
                    BookingRequestPage(),
                    ExhibitionPage(),
                    // UserProfilePage(),
                  ];
                }
                else {
                  _widgetOptions = <Widget>[
                    widget,
                    ExplorePage(),
                    HostDashboardPage(),
                    BookingRequestPage(),
                    ExhibitionPage(),
                    // UserProfilePage(),
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
                StylishBottomBar(
                  option: BubbleBarOptions(
                    unselectedIconColor: AppTheme.n200,
                    barStyle: BubbleBarStyle.vertical,
                    bubbleFillStyle: BubbleFillStyle.fill,
                    opacity: 0.8,
                    inkEffect: false
                  ),
                  items: [
                    BottomBarItem(
                      icon: const Icon(Icons.home, size: 20, color: AppTheme.n200,),
                      title: Text("Home", style: TextStyles.semiBoldN90012),
                      backgroundColor: AppTheme.primaryColor,
                      selectedIcon: const Icon(Icons.home, size: 20, color: AppTheme.n900,),
                    ),
                    BottomBarItem(
                      icon: const Icon(Icons.search, size: 20, color: AppTheme.n200,),
                      title: Text("Explore", style: TextStyles.semiBoldN90012),
                      backgroundColor: AppTheme.primaryColor,
                      selectedIcon: const Icon(Icons.search, size: 20, color: AppTheme.n900,),
                    ),
                    BottomBarItem(
                      icon: const Icon(Icons.dashboard, size: 20, color: AppTheme.n200,),
                      title: Text("Dashboard", style: TextStyles.semiBoldN90012),
                      backgroundColor: AppTheme.primaryColor,
                      selectedIcon: const Icon(Icons.dashboard, size: 20, color: AppTheme.n900,),
                    ),
                    BottomBarItem(
                      icon: pendingRequests != null && pendingRequests! > 0 ?
                      Badge(
                          label: Text(pendingRequests!.toString()),
                          child: const Icon(Icons.add_alert_sharp, size: 22)
                      ) : const Icon(Icons.add_alert_sharp, size: 22,),
                      title: Text("Bookings", style: TextStyles.semiBoldN90012),
                      backgroundColor: AppTheme.primaryColor,
                      selectedIcon: const Icon(Icons.add_alert_sharp, size: 20, color: AppTheme.n900,),
                    ),
                    BottomBarItem(
                      icon: const Icon(Icons.calendar_month, size: 20, color: AppTheme.n200,),
                      title: Text("Calendar", style: TextStyles.semiBoldN90012),
                      backgroundColor: AppTheme.primaryColor,
                      selectedIcon: const Icon(Icons.calendar_month, size: 20, color: AppTheme.n900,),
                    ),
                  ],
                  hasNotch: false,
                  borderRadius: BorderRadius.circular(15),
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              );
            }
        )
    );
  }
}

