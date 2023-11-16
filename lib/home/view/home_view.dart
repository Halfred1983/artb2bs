import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/artwork/view/artist_dashboard_page.dart';
import 'package:artb2b/booking_requests/view/booking_request_page.dart';
import 'package:artb2b/exhibition/view/exhibition_page.dart';
import 'package:artb2b/home/bloc/user_cubit.dart';
import 'package:artb2b/home/bloc/user_state.dart';
import 'package:artb2b/injection.dart';
import 'package:artb2b/notification/bloc/notification_bloc.dart';
import 'package:artb2b/onboard/view/personal_info_page.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:artb2b/widgets/map_view.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../host/view/host_dashboard_page.dart';
import '../../onboard/view/art_info_page.dart';
import '../../user_profile/view/user_profile_page.dart';

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
                  return PersonalInfoPage();
                }
                if (user!.userStatus == UserStatus.personalInfo) {
                  return ArtInfoPage();
                }

                widget =  HomeList();

                if(user!.userInfo!.userType == UserType.artist) {
                  _widgetOptions = <Widget>[
                    widget,
                    ArtistDashboardPage(),
                    ExhibitionPage(),
                    UserProfilePage(),
                  ];
                }
                else {
                  _widgetOptions = <Widget>[
                    widget,
                    HostDashboardPage(),
                    BookingRequestPage(),
                    ExhibitionPage(),
                    UserProfilePage(),
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
                      icon: const Icon(Icons.home, size: 20,),
                      title: Text("Home", style: TextStyles.semiBoldViolet14,),
                      selectedColor: AppTheme.primaryColourViolet,
                    ),

                    /// Likes
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.dashboard, size: 20,),
                      title: Text("Dashboard", style: TextStyles.semiBoldViolet14,),
                      selectedColor: AppTheme.primaryColourViolet,
                    ),

                    /// Requests
                    if(user!.userInfo!.userType != UserType.artist) ...[
                      SalomonBottomBarItem(
                        icon: pendingRequests != null && pendingRequests! > 0 ?
                        Badge(
                            label: Text(pendingRequests!.toString()),
                            child: const Icon(Icons.add_alert_sharp, size: 22)
                        ) : const Icon(Icons.add_alert_sharp, size: 22,),
                        title:  Text("Requests", style: TextStyles.semiBoldViolet14,),
                        selectedColor: AppTheme.primaryColourViolet,
                      ),
                    ],

                    /// Calendar
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.calendar_month, size: 20),
                      title: Text("Calendar", style: TextStyles.semiBoldViolet14,),
                      selectedColor: AppTheme.primaryColourViolet,
                    ),

                    /// Profile
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.person, size: 20),
                      title: Text("Profile", style: TextStyles.semiBoldViolet14,),
                      selectedColor: AppTheme.primaryColourViolet,
                    ),
                  ],
                ),
              );
            }
        )
    );
  }
}

class HomeList extends StatelessWidget {
  HomeList({super.key});

  final FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestoreDatabaseService.getHostsStream(),
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          if(snapshot.hasData) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text("Hosts", style: TextStyles.boldAccent24,),
                centerTitle: true,
              ),
              body: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  var user = snapshot.data![index];
                  // Build your list item using the user data
                  return InkWell(
                        onTap: () => context.pushNamed(
                          'profile',
                          pathParameters: {'userId': user.id},
                        ),
                    child: Padding(
                      padding: horizontalPadding24 + verticalPadding12,
                      child: CommonCard(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text("More Details", style: TextStyles.boldAccent24, textAlign: TextAlign.left,),
                              // verticalMargin24,
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // mainAxisSize: MainAxisSize.max,
                                children: [
                                  Image.asset('assets/images/gallery.png', width: 40,),
                                  horizontalMargin12,
                                  Text(user.userInfo!.name!, style: TextStyles.boldViolet16,),
                                  Expanded(child: Container()),
                                  Image.asset('assets/images/marker.png', width: 20,),
                                  horizontalMargin12,
                                  Text(user.userInfo!.address!.city,
                                    softWrap: true, style: TextStyles.semiBoldViolet14,),
                                ],
                              ),
                              verticalMargin12,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Spaces: ", style: TextStyles.boldViolet14,),
                                  Text(user.userArtInfo!.spaces!, style: TextStyles.semiBoldViolet14,),
                                ],
                              ),
                              verticalMargin12,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(flex: 1, child: Text("Vibes: ", softWrap: true, style: TextStyles.boldViolet14,)),
                                ],
                              ),
                              Text(user.userArtInfo!.vibes!.join(", "), softWrap: true, style: TextStyles.semiBoldViolet14,),

                              verticalMargin12,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Price per space per day: ", style: TextStyles.boldViolet14,),
                                  Expanded(child: Container()),
                                  Text(user.bookingSettings!.basePrice!+' £', style: TextStyles.boldViolet21,),
                                ],
                              ),
                              verticalMargin12,
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text("Min. spaces: ", style: TextStyles.boldViolet14,),
                                    Text(user.bookingSettings!.minSpaces!, style: TextStyles.semiBoldViolet14,),
                                    Expanded(child: Container()),
                                    Text("Min. days: ", style: TextStyles.boldViolet14,),
                                    Text(user.bookingSettings!.minLength!, style: TextStyles.semiBoldViolet14,),
                                  ]
                              ),
                            ]
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        });

  }
}

