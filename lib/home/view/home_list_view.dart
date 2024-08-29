import 'dart:async';

import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/injection.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/fadingin_picture.dart';
import 'package:artb2b/widgets/map_view.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/resources/assets.dart';
import '../../user_profile/view/user_profile_page.dart';
import '../../utils/currency/currency_helper.dart';

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


  @override
  void initState() {
    super.initState();
    firestoreDatabaseService.getHostsStream().listen((event) {_filteredStreamController.add(event); });
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
        stream: _filteredStreamController.stream,
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          if(snapshot.hasData) {
            return Padding(
                padding: horizontalPadding32,
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      scrolledUnderElevation: 0,
                      title: Text("Hello, ${widget.user.artInfo!.artistName!}", style: TextStyles.semiBoldAccent14,),
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
                            // Add your action here
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserProfilePage()),
                            );
                          },
                        ),
                      ],
                    ),

                    body: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalMargin24,
                          RichText(
                            softWrap: true,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Ready for your new exhibition ',
                                  style: TextStyles.boldN90029,
                                ),

                              ],
                            ),
                          ),
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
                          verticalMargin24,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('New Venues', style: TextStyles.semiBoldN90014,),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to the AllVenues page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeList(user: widget.user)),
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
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                var user = snapshot.data![index];
                                // Build your list item using the user data
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
                                                user.photos != null && user.photos!.isNotEmpty ?

                                                Container(constraints: const BoxConstraints(minWidth: 190,  maxHeight: 100),
                                                    // decoration:  BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                                                    child: FadingInPicture(url: user.photos![0].url!, radius: 24,)
                                                )
                                                    : SizedBox(width: 190, child: Container(
                                                  // decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                                                    constraints: const BoxConstraints(minWidth: 190,  maxHeight: 100),
                                                    child:FadingInPicture(url: Assets.logoUrl, radius: 24,))),
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
                                                      Text(user.venueInfo!.typeOfVenue != null ?
                                                      user.venueInfo!.typeOfVenue!.join(", ") :
                                                      '', softWrap: true, style: TextStyles.semiBoldP40010,),

                                                    ],
                                                  ),

                                                )

                                              ]
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
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          verticalMargin24,
                          Text('What\'s new?', style: TextStyles.semiBoldN90014,),
                          verticalMargin12,
                          FutureBuilder<User?>(
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

                                                    if(photos.isNotEmpty) ...[
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
                                                                Text(user.venueInfo!.typeOfVenue != null ?
                                                                user.venueInfo!.typeOfVenue!.join(", ") :
                                                                '', softWrap: true, style: TextStyles.semiBoldP40010,),
                                                                verticalMargin24

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
                                                            )],
                                                        ),

                                                      ),
                                                    )


                                                  ]
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
                                            )
                                        ),
                                      ],
                                    ),
                                  );

                                }
                              }
                          ),
                          verticalMargin24,
                        ],
                      ),
                    )
                )
            );
          }
          return Container();
        });
  }
}
