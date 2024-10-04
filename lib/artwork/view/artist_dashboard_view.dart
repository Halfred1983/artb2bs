import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/artwork/cubit/artist_cubit.dart';
import 'package:artb2b/artwork/cubit/artist_state.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:artb2b/widgets/photo_grid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/resources/assets.dart';
import '../../app/resources/styles.dart';
import '../../injection.dart';
import '../../photo/view/collection_page.dart';
import '../../photo/view/new_collection_page.dart';
import '../../user_profile/view/user_profile_page.dart';
import '../../utils/common.dart';

class ArtistDashboardView extends StatefulWidget {
  ArtistDashboardView({super.key, required this.isViewer});

  bool isViewer;
  @override
  State<ArtistDashboardView> createState() => _ArtistDashboardViewState();
}

class _ArtistDashboardViewState extends State<ArtistDashboardView> {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();


  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<ArtistCubit, ArtistState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is LoadedState) {
              user = state.user;

              return Scaffold(
                backgroundColor: AppTheme.white,
                appBar: widget.isViewer ? AppBar(
                  scrolledUnderElevation: 0,
                  title: Text(user!.artInfo!.artistName!, style: TextStyles.boldN90017,),
                  centerTitle: true,
                  iconTheme: const IconThemeData(
                    color: AppTheme.n900, //change your color here
                  )) : null,
                body: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Container(
                          color: AppTheme.backgroundColor,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: horizontalPadding24 + verticalPadding24,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(30.0),
                                          child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              width: 60,
                                              height: 60,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                    Assets.logo,
                                                    fit: BoxFit.cover,
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                              imageUrl: user!.imageUrl.isNotEmpty ? user!.imageUrl : Assets.logoUrl
                                          )
                                      ),
                                      horizontalMargin8,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(user!.artInfo!.artistName!, style: TextStyles.boldN90024,),
                                          verticalMargin4,
                                          Text(user!.userInfo!.address!.city,
                                            style: TextStyles.boldN90014,),
                                        ],
                                      ),
                                      Expanded(child: Container()),
                                      !widget.isViewer ? InkWell(
                                          onTap: () {
                                            // Add your action here
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => UserProfilePage()),
                                            );
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.edit, size: 12,),
                                          )
                                      ) : Container(),
                                    ],
                                  ),
                                  verticalMargin24,
                                  Text(user!.artInfo!.biography!, style: TextStyles.regularN90014, textAlign: TextAlign.justify,),
                                  verticalMargin24,
                                  Text('Main technique: ${user!.artInfo!.artStyle!.name.capitalize()}', style: TextStyles.regularN90014, textAlign: TextAlign.justify,),
                                  verticalMargin24,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 160,
                                        padding: horizontalPadding16 + verticalPadding12,
                                        decoration: BoxDecoration(
                                          color: AppTheme.backgroundGrey,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(user!.artInfo!.collections.length.toString(), style: TextStyles.boldN90024,),
                                            verticalMargin4,
                                            Text('Collections', style: TextStyles.regularN90014.copyWith(color: AppTheme.n300),),
                                          ],
                                        ),
                                      ),


                                      Container(
                                        height: 80,
                                        width: 160,
                                        padding: horizontalPadding16 + verticalPadding12,
                                        decoration: BoxDecoration(
                                          color: AppTheme.backgroundGrey,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(user!.artInfo!.collections.length.toString(), style: TextStyles.boldN90024,),
                                            verticalMargin4,
                                            Text('Exhibitions', style: TextStyles.regularN90014.copyWith(color: AppTheme.n300),),
                                          ],
                                        ),
                                      ),
                                      // Text('Profile Views: ', style: TextStyles.semiBoldPrimary14, ),
                                      // FutureBuilder(
                                      //     future: firestoreDatabaseService.getViewCounter(user!.id),
                                      //     builder: (context, snapshot) {
                                      //       if (snapshot.connectionState == ConnectionState.waiting) {
                                      //         return const CircularProgressIndicator(color: AppTheme.primaryColor,);
                                      //       } else if (snapshot.connectionState == ConnectionState.active
                                      //           || snapshot.connectionState == ConnectionState.done) {
                                      //         if (snapshot.hasData && snapshot.data != null) {
                                      //           return Text(snapshot.data.toString(), style: TextStyles.semiBoldPrimary14, );
                                      //         }
                                      //         return Text('n/a', style: TextStyles.semiBoldPrimary14, );
                                      //       }
                                      //       return Text('n/a', style: TextStyles.semiBoldPrimary14, );
                                      //     }
                                      // ),
                                      // Expanded(child: Container()),
                                      // Expanded(child: Container()),
                                      // Text('Status: ', style: TextStyles.semiBoldAccent16, ),
                                      // Text('Active ✅', style: TextStyles.semiBoldViolet16, ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(
                          color: AppTheme.backgroundColor,
                          child: Padding(
                            padding: horizontalPadding24 + verticalPadding24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                verticalMargin32,
                                //ARTIST
                                StreamBuilder(
                                  stream: firestoreDatabaseService.findArtworkByUser(user: user!),
                                  builder: (context, snapshot){
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Text("Loading");
                                    }

                                    if(snapshot.hasData) {
                                      User user = User.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                                      if (user.artInfo!.collections.isEmpty) {
                                        return Text(
                                          'You have no art collection yet, start by adding a new one',
                                          style: TextStyles.regularN90014,
                                        );
                                      } else {
                                        user.artInfo!.collections.sort((a, b) => b.artworks.length.compareTo(a.artworks.length));

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            for (var collection in user.artInfo!.collections)
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => CollectionPage(collectionId: collection.name!, userId: user.id, isViewer: widget.isViewer),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(bottom: 24),
                                                  height: 250,
                                                  width: double.infinity,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      verticalMargin4,
                                                      collection.artworks.isEmpty ? Text('This collection is empty', style: TextStyles.semiBoldN90014,) :
                                                      PhotoGridWidget(
                                                        artworks: collection.artworks,
                                                        moreCount: collection.artworks.length > 4 ? collection.artworks.length - 4 : 0,
                                                      ),
                                                      verticalMargin8,
                                                      Text(collection.name!, style: TextStyles.boldN90017,),
                                                      Text(collection.collectionVibes!, style: TextStyles.semiBoldN90014,
                                                        maxLines: 1, // Set the maximum number of lines to display
                                                        overflow: TextOverflow.ellipsis,),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      }
                                    }
                                    return Container();
                                  },
                                )

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: !widget.isViewer ? Container(
                  padding: horizontalPadding32,
                  width: 200,
                  child: FloatingActionButton(
                      backgroundColor:  AppTheme.n900,
                      foregroundColor: AppTheme.primaryColor,
                      onPressed: () {

                        // context.read<OnboardingCubit>().save(user!, UserStatus.spaceInfo);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewCollectionPage()), // Replace NewPage with the actual class of your new page
                        );
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              width: 18,
                              child: const Icon(Icons.add, size: 13, color: AppTheme.black,)
                          ),
                          horizontalMargin4,
                          const Text('Add New',),
                        ],
                      )
                  ),
                ) : null,
                floatingActionButtonLocation: FloatingActionButtonLocation
                    .centerDocked,
              );
            }
            return Container();
          }
      );
  }
}