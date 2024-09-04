import 'dart:async';
import 'dart:ui';

import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../app/resources/assets.dart';
import '../../app/resources/styles.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../utils/currency/currency_helper.dart';
import '../../widgets/common_card_widget.dart';
import '../../widgets/google_places.dart';
import '../../widgets/host_list_card_big.dart';
import '../../widgets/map_view.dart';
import '../../widgets/price_slider.dart';
import '../../widgets/tags.dart';
import '../cubit/explore_cubit.dart';
import '../cubit/explore_state.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();
  SharedPreferences prefs = locator.get<SharedPreferences>();
  bool _listView = true;

  final TextEditingController _searchController = TextEditingController();
  // final StreamController<List<User>> _filteredStreamController = StreamController<List<User>>();


  @override
  void initState() {
    super.initState();
    _venueCategories = prefs.getStringList('VenueCategory')!;
    _venueVibes = prefs.getStringList('Vibes')!;
    // firestoreDatabaseService.getHostsStream().listen((event) {
    //   _filteredStreamController.add(event);
    //   currentIndices = List<int>.generate(event.length, (index) => 0);
    // });
    // _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _filterUsers() {
  //
  //   String searchQuery = _searchController.text;
  //   firestoreDatabaseService.getHostsStream().listen((users) {
  //     List<User> filteredUsers = [];
  //     if (searchQuery.isEmpty) {
  //       filteredUsers = users;
  //     } else {
  //       filteredUsers = users.where((user) =>
  //           user.userInfo!.name
  //               .toString()
  //               .toLowerCase()
  //               .contains(searchQuery.toLowerCase())
  //       ).toList();
  //     }
  //
  //     // Add the filtered list to the StreamController
  //     _filteredStreamController.add(filteredUsers);
  //     currentIndices = List.filled(filteredUsers.length, 0);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    User? user;
    List<User> hosts;
    return
      BlocBuilder<ExploreCubit, ExploreState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is LoadedState) {
              user = state.user;
              hosts = state.hosts;

              return Padding(
                padding: _listView ? horizontalPadding32 : EdgeInsets.zero,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    scrolledUnderElevation: 0,
                    title: Padding(
                      padding: _listView ? EdgeInsets.zero : horizontalPadding32,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Explore in, ', style: TextStyles.boldN90029,),
                          verticalMargin4,
                          InkWell(
                            onTap: () {
                              _showCitySearchBottomSheet(context, user!);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(" ${user!.userInfo!.address!.city}", style: TextStyles.boldAccent17),
                                const Icon(Icons.arrow_drop_down_outlined, size: 20, color: AppTheme.accentColor,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    centerTitle: false,
                    titleSpacing: 0,
                  ),
                  body: SingleChildScrollView(
                    // physics: const ClampingScrollPhysics(),
                      child: Builder(
                          builder: (context){
                            return  _listView ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  verticalMargin24,
                                  buildSearch(user!),
                                  verticalMargin32,
                                  buildListView(hosts)
                                ]
                            ) : Container(
                                padding: verticalPadding24,
                                height: MediaQuery.of(context).size.height -
                                    kBottomNavigationBarHeight - Assets.marginApppBar,
                                child: Stack(
                                    children:
                                    [
                                      MapView(hosts: state.hosts, user: state.user,),
                                      Padding(
                                        padding: _listView ? EdgeInsets.zero : horizontalPadding32,
                                        child: buildSearch(user!),
                                      )
                                    ]
                                )
                            );
                            // }
                            // else { return Container(); }
                          }
                      )) ,
                  floatingActionButton: SizedBox(
                    width: 110,
                    height: 47,
                    child: FloatingActionButton(
                      onPressed: (){
                        setState(() {
                          _listView = !_listView;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(_listView) ...[
                            const Icon(Icons.map),
                            horizontalMargin4,
                            Text('Map', style: TextStyles.semiBoldPrimary14,)
                          ]
                          else ...[
                            const Icon(Icons.list),
                            horizontalMargin4,
                            Text('List', style: TextStyles.semiBoldPrimary14,)
                          ]
                        ],
                      ),
                    ),
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                ),
              );
            }
            return Container();
          });
  }

  bool isFiltering = false;
  Widget buildSearch(User user) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          AppTheme.boxShadow
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: false,
        style: TextStyles.semiBoldAccent14,
        onChanged: (String value) {
          context.read<ExploreCubit>().updateSearchQuery(value);
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.tune, size: 20, color: AppTheme.accentColor,),
                Positioned(
                    bottom: 5,
                    left: 7,
                    child: isFiltering ? const Icon(
                      Icons.check,
                      size: 20,
                      color: Colors.red, // Adjust the color of the checkmark
                    ) : Container()
                )
              ],
            ),
            onPressed: () async {
              isFiltering = await _showModalBottomSheet(context, user);
            },
          ),
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

  ListView buildListView(List<User> snapshot) {
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: snapshot.length,
      itemBuilder: (BuildContext context, int index) {
        return HostListCardBig(user: snapshot[index]);
      },
    );
  }

  /////CHANGE CITY
  void _showCitySearchBottomSheet(BuildContext contexto, User user) {

    final exploreCubit = context.read<ExploreCubit>();

    showModalBottomSheet(
        context: contexto,
        isScrollControlled: true,
        builder: (contexto) {
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
                      onAddressChosen: (address) async {
                        await exploreCubit.updateCity(user, address);
                        _searchController.text = '';

                        Navigator.pop(context);
                      },),
                    Expanded(child: Container()),
                  ],
                ),
              );
            },
          );

        }
    );
  }



  ///// FILTER MODAL
  List<String> _selectedVenueCategories = [];
  List<String> _venueCategories = [];
  List<String> _selectedVenueVibes = [];
  List<String> _venueVibes = [];
  RangeValues _rangeValues = const RangeValues(0, 300);

  Future<bool> _showModalBottomSheet(BuildContext context, User user) async {
    final exploreCubit = context.read<ExploreCubit>();

    bool? result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.9,
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    padding: horizontalPadding32,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      shadows: [
                        AppTheme.bottomBarShadow
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalMargin32,
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, false); // Close the modal bottom sheet
                                },
                                child: const Icon(Icons.clear, size: 20, color: AppTheme.n900,)
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                    'Filters',
                                    style: TextStyles.boldN90017
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalMargin32,
                        const Divider(height: 0.5, thickness: 0.5, color: AppTheme.n200,),
                        verticalMargin32,
                        Text(
                            'Price range',
                            style: TextStyles.boldN90017
                        ),
                        Text(
                            'Price range space/day',
                            style: TextStyles.regularN90014
                        ),
                        verticalMargin24,
                        PriceSlider(user: user, rangeValues: _rangeValues, onChanged: (RangeValues priceRangeValues) {
                          _rangeValues = priceRangeValues;
                          exploreCubit.updatePriceRange(priceRangeValues);
                        }),
                        verticalMargin32,
                        Text(
                            'Venue category',
                            style: TextStyles.boldN90017
                        ),
                        verticalMargin32,
                        Tags(_venueCategories, _selectedVenueCategories, (artistTags) {
                          setState(() {
                            _selectedVenueCategories = artistTags;
                          });
                          exploreCubit.updateVenueCategory(artistTags);
                        }),
                        verticalMargin32,
                        Text(
                            'Venue vibes',
                            style: TextStyles.boldN90017
                        ),
                        verticalMargin32,
                        Tags(_venueVibes, _selectedVenueVibes, (artistTags) {
                          setState(() {
                            _selectedVenueVibes = artistTags;
                          });
                          exploreCubit.updateVenueVibes(artistTags);
                        }),
                        verticalMargin32,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                exploreCubit.restFilters();
                                _selectedVenueCategories = [];
                                _rangeValues = const RangeValues(20, 80);
                                Navigator.pop(context, false);
                              },
                              child: Text('Reset Filters', style: TextStyles.semiBoldAccent14.copyWith(decoration: TextDecoration.underline)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                exploreCubit.applyFilters();
                                Navigator.pop(context, true);
                              },
                              child: Text('Apply', style: TextStyles.semiBoldPrimary14),
                            ),
                          ],
                        ),
                        verticalMargin48,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    return result ?? false; // Return false if result is null
  }}
