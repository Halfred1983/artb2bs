import 'dart:async';

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
import '../../widgets/common_card_widget.dart';
import '../../widgets/map_view.dart';
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
  final StreamController<List<User>> _filteredStreamController = StreamController<List<User>>();


  @override
  void initState() {
    super.initState();
    firestoreDatabaseService.getHostsStream().listen((event) {
      _filteredStreamController.add(event);
      currentIndices = List<int>.generate(event.length, (index) => 0);
    });
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _filterUsers() {

    String searchQuery = _searchController.text;
    firestoreDatabaseService.getHostsStream().listen((users) {
      List<User> filteredUsers = [];
      if (searchQuery.isEmpty) {
        filteredUsers = users;
      } else {
        filteredUsers = users.where((user) =>
            user.userInfo!.name
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase())
        ).toList();
      }

      // Add the filtered list to the StreamController
      _filteredStreamController.add(filteredUsers);
      currentIndices = List.filled(filteredUsers.length, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<ExploreCubit, ExploreState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is LoadedState) {
              user = state.user;

              return Padding(
                padding: horizontalPadding32,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Text('Explore', style: TextStyles.boldN90029,),
                    centerTitle: false,
                    titleSpacing: 0,
                  ),
                  body:
                  _listView ? SingleChildScrollView(
                    // physics: const ClampingScrollPhysics(),
                      child: StreamBuilder<List<User>>(
                          stream: _filteredStreamController.stream,
                          builder: (context, snapshot){
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text("Loading");
                            }
                            if(snapshot.hasData) {

                              return  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    verticalMargin24,
                                    Container(
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
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: const Icon(Icons.filter_list, color: AppTheme.primaryColor,),
                                            onPressed: () {
                                              // Add your filter action here
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
                                    ),
                                    verticalMargin32,
                                    ListView.builder(
                                      physics: const ScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        var user = snapshot.data![index];

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
                                                          placeholder: AssetImage(Assets.logoUrl),
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
                                                            Text(user.userArtInfo!.typeOfVenue != null ?
                                                            user.userArtInfo!.typeOfVenue!.join(", ") :
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
                                    ),
                                  ]);
                            }
                            else { return Container(); } })) : MapView(user: user!),
                  floatingActionButton: FloatingActionButton(
                    onPressed: (){
                      setState(() {
                        _listView = !_listView;
                      });
                    },
                    child: Icon(_listView ? Icons.map : Icons.list),
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                ),
              );
            }
            return Container();
          });
  }
}
