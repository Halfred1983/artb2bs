import 'package:artb2b/artwork/cubit/artist_cubit.dart';
import 'package:artb2b/artwork/cubit/artist_state.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../app/resources/styles.dart';
import '../../injection.dart';
import '../../photo/view/artwork_upload_page.dart';
import '../../utils/common.dart';
import '../../widgets/add_photo_button.dart';
import 'artwork_details.dart';

class ArtistDashboardView extends StatefulWidget {
  const ArtistDashboardView({super.key});

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
                  appBar: AppBar(
                    title: Text("Your Dashboard", style: TextStyles.boldAccent24,),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: horizontalPadding24,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/artist.png", width: 60,),
                              horizontalMargin16,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user!.userInfo!.name!, style: TextStyles.semiBoldViolet16, ),
                                  verticalMargin12,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Location: ', style: TextStyles.semiBoldAccent16, ),
                                      Text(user!.userInfo!.address!.city, style: TextStyles.semiBoldViolet16, ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(thickness: 0.6, color: Colors.black38,),
                          verticalMargin12,
                          Row(
                            children: [
                              Text('Profile Views: ', style: TextStyles.semiBoldAccent16, ),
                              Text('24', style: TextStyles.semiBoldViolet16, ),
                              Expanded(child: Container()),
                              Text('Status: ', style: TextStyles.semiBoldAccent16, ),
                              Text('Active ✅', style: TextStyles.semiBoldViolet16, ),
                            ],
                          ),
                          verticalMargin32,
                          Text('Your artworks: ', style: TextStyles.semiBoldAccent16, ),
                          const Divider(thickness: 0.6, color: Colors.black38,),
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

                                  return user.artworks != null && user.artworks!.isNotEmpty ?
                                  SingleChildScrollView(
                                    physics: const ScrollPhysics(),
                                    child: MasonryGridView.count(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: user.artworks!.length + 1,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 6,
                                      crossAxisCount: 2,
                                      itemBuilder: (context, index) {
                                        if(index == 0) {
                                          return AddPhotoButton(
                                              action: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ArtworkUploadPage()),
                                              ));
                                        }
                                        return InkWell(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ArtworkDetails(artwork: user.artworks![index - 1])),
                                          ),
                                          child: Stack(
                                            children: [
                                              ShaderMask(
                                                shaderCallback: (rect) {
                                                  return const LinearGradient(
                                                    begin: Alignment.center,
                                                    end: Alignment.bottomCenter,
                                                    colors: [Colors.transparent, Colors.black],
                                                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                                                },
                                                blendMode: BlendMode.darken,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.network(
                                                      user.artworks![index - 1].url!,
                                                      fit: BoxFit.contain
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 15,
                                                right: 25,
                                                child: Text(user.artworks![index - 1].name!,
                                                  style: TextStyles.boldWhite14,),
                                              )
                                            ],
                                          ),
                                        );

                                      },
                                    ),
                                  ) : AddPhotoButton(
                                      action: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ArtworkUploadPage()),
                                      ));
                                }
                                return Container();
                              })
                        ],
                      ),
                    ),
                  )
              );
            }
            return Container();
          }
      );
  }
}