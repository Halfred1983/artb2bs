import 'dart:async';

import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/injection.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/fadingin_picture.dart';
import 'package:auth_service/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../app/resources/assets.dart';
import '../../onboard/cubit/onboarding_cubit.dart';
import '../../onboard/cubit/onboarding_state.dart';
import '../../user_profile/view/user_profile_page.dart';
import '../../utils/currency/currency_helper.dart';
import '../../widgets/google_places.dart';
import '../../widgets/loading_screen.dart';

import 'dart:async';

import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/injection.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/fadingin_picture.dart';
import 'package:auth_service/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/resources/assets.dart';
import '../../onboard/cubit/onboarding_cubit.dart';
import '../../widgets/google_places.dart';
import '../../widgets/loading_screen.dart';

class HomeList extends StatefulWidget {
  HomeList({super.key, required this.user});
  final User user;

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  final FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();
  final TextEditingController _searchController = TextEditingController();
  final StreamController<List<User>> _filteredStreamController = StreamController<List<User>>();
  final StreamController<User> _userStreamController = StreamController<User>();
  StreamSubscription<List<User>>? _userSubscription;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _searchController.addListener(_filterUsers);
    _fetchUsersNearby(_currentUser);

    if(!_userStreamController.isClosed) {
      // Listen to changes in the user document and update the stream
      firestoreDatabaseService.getUserStream(_currentUser.id).listen((
          docSnapshot) {
        final updatedUser = User.fromJson(
            docSnapshot.data() as Map<String, dynamic>);
        _currentUser = updatedUser;
        if (!_userStreamController.isClosed) {
          _userStreamController.add(_currentUser);
        }
        _fetchUsersNearby(_currentUser);
      });
    }
  }

  void _fetchUsersNearby(User user) {
    _userSubscription?.cancel();  // Cancel any existing subscription before starting a new one

    _userSubscription = firestoreDatabaseService.getHostsStream(nextToUser: user).listen(
          (users) {
        if (!_filteredStreamController.isClosed) {
          _filteredStreamController.add(users);
        }
      },
      onError: (error) {
        if (!_filteredStreamController.isClosed) {
          _filteredStreamController.addError(error);
        }
      },
    );
  }

  void _filterUsers() {
    String searchQuery = _searchController.text.toLowerCase();

    _userSubscription?.cancel();  // Cancel any existing subscription

    _userSubscription = firestoreDatabaseService.getHostsStream(nextToUser: _currentUser).listen(
          (users) {
        if (!_filteredStreamController.isClosed) {
          List<User> filteredUsers = users.where((user) {
            return user.userInfo?.name?.toLowerCase().contains(searchQuery) ?? false;
          }).toList();
          _filteredStreamController.add(filteredUsers);
        }
      },
      onError: (error) {
        if (!_filteredStreamController.isClosed) {
          _filteredStreamController.addError(error);
        }
      },
    );
  }

  @override
  void dispose() {
    _userSubscription?.cancel(); // Cancel the subscription when disposing the widget
    _filteredStreamController.close(); // Close the stream controller
    _userStreamController.close(); // Close the user stream controller
    _searchController.dispose(); // Dispose the search controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: _userStreamController.stream,
      initialData: _currentUser,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        if (snapshot.hasData) {
          _currentUser = snapshot.data!;

          return StreamBuilder<List<User>>(
            stream: _filteredStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              if (snapshot.hasData) {
                List<User> users = snapshot.data!;
                return Padding(
                  padding: horizontalPadding32,
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      scrolledUnderElevation: 0,
                      title: InkWell(
                        onTap: () {
                          _showCitySearchBottomSheet(context);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.pin_drop_sharp, size: 16, color: AppTheme.n900,),
                            Text(" ${_currentUser.userInfo!.address!.city}", style: TextStyles.semiBoldN90014),
                            const Icon(Icons.arrow_drop_down_outlined, size: 16, color: AppTheme.n900,),
                          ],
                        ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserProfilePage()),
                            );
                          },
                        ),
                      ],
                    ),
                    body: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hello, ${_currentUser.artInfo!.artistName!}", style: TextStyles.semiBoldAccent14,),
                          verticalMargin12,
                          RichText(
                            softWrap: true,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Ready for your new exhibition?',
                                  style: TextStyles.boldN90029,
                                ),
                              ],
                            ),
                          ),
                          verticalMargin24,
                          _buildSearchBar(),
                          verticalMargin24,
                          _buildNewVenuesList(users),
                          verticalMargin24,
                          _buildWhatsNewSection(),
                          verticalMargin24,
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          );
        }

        return Container();
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [AppTheme.boxShadow],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: false,
        style: TextStyles.semiBoldAccent14,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyles.regularN90014,
          prefixIcon: const Icon(Icons.search, color: AppTheme.n900),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildNewVenuesList(List<User> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Venues', style: TextStyles.semiBoldN90014,),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeList(user: _currentUser)),
                );
              },
              child: Text('See All', style: TextStyles.semiBoldS40012,),
            ),
          ],
        ),
        verticalMargin16,
        SizedBox(
          width:  MediaQuery.of(context).size.width,
          height: 185,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              var user = users[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => context.pushNamed(
                    'profile',
                    pathParameters: {'userId': user.id},
                  ),
                  child: CommonCard(
                    margin: const EdgeInsets.only(right: 16),
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppTheme.boxShadow,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            user.photos != null && user.photos!.isNotEmpty
                                ? Container(
                              constraints: const BoxConstraints(minWidth: 190, maxHeight: 100),
                              child: FadingInPicture(url: user.photos![0].url!, radius: 24,),
                            )
                                : SizedBox(
                              width: 190,
                              child: Container(
                                constraints: const BoxConstraints(minWidth: 190, maxHeight: 100),
                                child: FadingInPicture(url: Assets.logoUrl, radius: 24,),
                              ),
                            ),
                            Padding(
                              padding: horizontalPadding16 + verticalPadding4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.userInfo!.name!, style: TextStyles.boldN90017,),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_pin, size: 10,),
                                      Text(user.userInfo!.address!.city,
                                        softWrap: true, style: TextStyles.regularN90010,),
                                    ],
                                  ),
                                  verticalMargin8,
                                  Text(user.venueInfo!.typeOfVenue != null
                                      ? user.venueInfo!.typeOfVenue!.join(", ")
                                      : '',
                                    softWrap: true, style: TextStyles.semiBoldP40010,),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 53,
                            height: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: AppTheme.n900,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('From', style: TextStyles.regularPrimary10,),
                                  Text(' ${user.bookingSettings!.basePrice!} '
                                      '${CurrencyHelper.currency(user.userInfo!.address!.country).currencySymbol}',
                                    style: TextStyles.semiBoldPrimary12,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsNewSection() {
    return FutureBuilder<User?>(
      future: firestoreDatabaseService.getMostRecentHost(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No recent host found');
        } else {
          var user = snapshot.data!;

          List<Widget> photos = [];

          if (user.photos != null && user.photos!.isNotEmpty) {
            photos = List.generate(
              user.photos!.length,
                  (index) => ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: FadeInImage(
                  width: double.infinity,
                  placeholder: const AssetImage(Assets.logo),
                  image: NetworkImage(user.photos![index].url!),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }

          return InkWell(
            onTap: () => context.pushNamed(
              'profile',
              pathParameters: {'userId': user.id},
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: verticalPadding8,
                  child: InkWell(
                    onTap: () => context.pushNamed(
                      'profile',
                      pathParameters: {'userId': user.id},
                    ),
                    child: CommonCard(
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (photos.isNotEmpty) ...[
                            Stack(
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: PageView.builder(
                                    padEnds: false,
                                    itemCount: photos.length,
                                    itemBuilder: (_, index) {
                                      return photos[index % photos.length];
                                    },
                                  ), // Select photo dynamically using index
                                ),
                              ],
                            ),
                          ] else ... [
                            const SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: FadeInImage(
                                placeholder: AssetImage(Assets.logo),
                                image: NetworkImage(Assets.logoUrl),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ],
                          SizedBox(
                            height: 100,
                            child: Padding(
                              padding: horizontalPadding24 + verticalPadding12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user.userInfo!.name!, style: TextStyles.boldN90017,),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_pin, size: 10,),
                                          Text(user.userInfo!.address!.city,
                                            softWrap: true, style: TextStyles.regularN90010,),
                                        ],
                                      ),
                                      Expanded(child: Container(),),
                                      Text(user.venueInfo!.typeOfVenue != null
                                          ? user.venueInfo!.typeOfVenue!.join(", ")
                                          : '',
                                        softWrap: true, style: TextStyles.semiBoldP40010,),
                                      verticalMargin24,
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('From', style: TextStyles.regularAccent12,),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          color: AppTheme.primaryColor,
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(' ${user.bookingSettings!.basePrice!} '
                                                  '${CurrencyHelper.currency(user.userInfo!.address!.country).currencySymbol}',
                                                style: TextStyles.semiBoldN90017,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: horizontalPadding24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New Venues alert!',
                            style: TextStyles.boldN90024.copyWith(color: AppTheme.white),
                          ),
                          verticalMargin16,
                          Text(
                            'We\'ve just expanded our venue list to include fantastic new spots.',
                            style: TextStyles.semiBoldN90014.copyWith(color: AppTheme.white,), textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _showCitySearchBottomSheet(BuildContext contexto) {
    showModalBottomSheet(
        context: contexto,
        isScrollControlled: true,
        builder: (contexto) {
          return BlocProvider<OnboardingCubit>(
            create: (context) => OnboardingCubit(
              databaseService: locator<FirestoreDatabaseService>(),
              userId: locator<FirebaseAuthService>().getUser().id,
            ),
            child:  BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const LoadingScreen();
                  }
                  if(state is AddressChosen || state is LoadedState) {
                    User user = state.user!;
                    return DraggableScrollableSheet(
                      initialChildSize: 0.6, // The initial height is 50% of the parent container's height
                      minChildSize: 0.25,    // The minimum height is 25% of the parent container's height
                      maxChildSize: 0.7,    // The maximum height is 85% of the parent container's height
                      expand: false,
                      builder: (context, scrollController) {
                        return Padding(
                          padding: horizontalPadding24,
                          child: Column(
                            children: [
                              verticalMargin24,
                              Text('When you chose a city you will see all the venues in it.',
                                style: TextStyles.boldN90017,),
                              verticalMargin12,
                              GoogleAddressLookup(hint: 'Which city?',
                                onAddressChosen: (address) {
                                  context.read<OnboardingCubit>().chooseAddress(address);
                                },),
                              Expanded(child: Container()),
                              Container(
                                  padding: horizontalPadding32,
                                  width: double.infinity,
                                  child: FloatingActionButton(
                                      backgroundColor:  _canContinue(user) ? AppTheme.n900 : AppTheme.disabledButton,
                                      foregroundColor: _canContinue(user) ? AppTheme.primaryColor : AppTheme.n900,
                                      onPressed: () async {
                                        if(_canContinue(user))  {
                                          await context.read<OnboardingCubit>().save(user);
                                          Navigator.of(contexto).pop();
                                          // Update _currentUser with new data and refresh venues
                                          _userStreamController.add(user);
                                          _fetchUsersNearby(user);
                                          _searchController.text = '';
                                        }
                                      },
                                      child: const Text('Save',)
                                  )
                              ),
                              verticalMargin48,
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                }
            ),
          );
        }
    );
  }

  bool _canContinue(User user) {
    return user.userInfo!.address != null;
  }
}
