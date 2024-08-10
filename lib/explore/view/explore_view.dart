import 'dart:async';
import 'dart:ui';

import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../app/resources/assets.dart';
import '../../app/resources/styles.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../utils/currency/currency_helper.dart';
import '../../widgets/common_card_widget.dart';
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
  bool _listView = true;
  final controller = PageController(viewportFraction: 1, keepPage: true);
  List<int> currentIndices = [];

  final TextEditingController _searchController = TextEditingController();
  // final StreamController<List<User>> _filteredStreamController = StreamController<List<User>>();


  @override
  void initState() {
    super.initState();
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
                    title: Text('Explore', style: TextStyles.boldN90029,),
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
                                child: Stack(children: [MapView(user: user!), Padding(
                                  padding: _listView ? EdgeInsets.zero : horizontalPadding32,
                                  child: buildSearch(user!),
                                )])
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
                const Icon(Icons.tune, size: 20, color: AppTheme.primaryColor,),
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
        var user = snapshot[index];

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

        // Build your list item using the user data
        return Container(
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

                    if(photos.isNotEmpty) ...[
                      Stack(
                        children: [
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: PageView.builder(
                              onPageChanged: (pageId,) {
                                setState(() {
                                  currentIndices[
                                  index] = pageId;
                                });
                              },
                              padEnds: false,
                              controller: controller,
                              itemCount: photos.length,
                              itemBuilder: (_, index) {
                                return photos[index % photos.length];
                              },
                            ), // Select photo dynamically using index
                          ),
                          Positioned.fill(
                            bottom: 12,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: AnimatedSmoothIndicator(
                                activeIndex: currentIndices.isNotEmpty ? currentIndices[
                                index] : 0,
                                count: photos.length,
                                effect: const ExpandingDotsEffect(
                                  spacing: 5,
                                  dotHeight: 10,
                                  dotWidth: 10,
                                  dotColor: Colors.white,
                                  activeDotColor: Colors.white,
                                  // type: WormType.thin,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ]
                    else ... [
                      const SizedBox(
                        width: double.infinity,
                        height: 200,
                        child:FadeInImage(
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
                            Expanded(child: Container(),),
                            Text(user.venueInfo!.typeOfVenue != null ?
                            user.venueInfo!.typeOfVenue!.join(", ") :
                            '', softWrap: true, style: TextStyles.semiBoldP40010,),
                            verticalMargin24

                          ],
                        ),

                      ),
                    )


                  ]
              ),
            ),
          ),
        );
      },
    );
  }




  ///// FILTER MODAL
  List<String> _artistTags = [];
  RangeValues _rangeValues = const RangeValues(20, 80);

  Future<bool> _showModalBottomSheet(BuildContext context, User user) async {
    final exploreCubit = context.read<ExploreCubit>();

    bool? result = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              padding: horizontalPadding32,
              width: double.infinity,
              height:  MediaQuery.of(context).size.height * 0.8,
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
                  // Text(
                  //     'Date availability',
                  //     style: TextStyles.boldN90017
                  // ),
                  // verticalMargin24,
                  Text(
                      'Price range',
                      style: TextStyles.boldN90017
                  ),
                  Text(
                      'Price range space/day',
                      style: TextStyles.regularN90014
                  ),
                  verticalMargin24,
                  PriceSlider(user: user,  rangeValues: _rangeValues, onChanged: (RangeValues priceRangeValues) {
                    // Do something with the new range values
                    print('Start value: ${priceRangeValues.start}, End value: ${priceRangeValues.end}');
                    _rangeValues = priceRangeValues;
                    exploreCubit.updatePriceRange(priceRangeValues);

                  },
                  ),
                  verticalMargin32,
                  Text(
                      'Venue category',
                      style: TextStyles.boldN90017
                  ),
                  verticalMargin32,
                  Tags(const [
                    'Arty', 'Commercial', 'Coffee', 'Abstract'
                  ],
                    _artistTags,
                        (artistTags) {
                      setState(() {
                        _artistTags = artistTags;
                      });
                      exploreCubit.updateVenueCategory(artistTags);
                    },
                  ),
                  verticalMargin32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(onTap: () {
                        exploreCubit.restFilters();
                        _artistTags = [];
                        _rangeValues = const RangeValues(20, 80);
                        Navigator.pop(context, false);
                      },
                        child: Text('Reset Filters', style: TextStyles.semiBoldAccent14.copyWith(decoration: TextDecoration.underline),),),

                      ElevatedButton(
                        onPressed:
                            () {
                          exploreCubit.applyFilters();
                          Navigator.pop(context, true);
                        },
                        child: Text('Apply', style: TextStyles.semiBoldPrimary14,),),
                    ],
                  ),



                ],
              ),
            ),
          );
        });

    return result ?? false; // Return false if result is null

  }
}
