import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/artwork/cubit/artwork_cubit.dart';
import 'package:artb2b/artwork/cubit/artwork_state.dart';
import 'package:artb2b/artwork/view/photo_details.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../app/resources/styles.dart';
import '../../injection.dart';
import '../../photo/view/photo_page.dart';
import '../../utils/common.dart';

class ArtworkView extends StatefulWidget {
  const ArtworkView({super.key});

  @override
  State<ArtworkView> createState() => _ArtworkViewState();
}

class _ArtworkViewState extends State<ArtworkView> {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();


  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<ArtworkCubit, ArtworkState>(
          builder: (context, state) {
            Widget widget = Container();
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is LoadedState) {
              user = state.user;

              return Scaffold(
                  appBar: AppBar(
                    title: Text(user!.userInfo!.userType == UserType.artist ?
                    "Your Artwork" : "Your Dashboard", style: TextStyles.boldAccent24,),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: horizontalPadding24,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              user!.userInfo!.userType == UserType.artist ? Image.asset("assets/images/artist.png", width: 60,)
                                  :Image.asset("assets/images/gallery.png", width: 60,),
                              horizontalMargin16,
                              Text(user!.userInfo!.name!, style: TextStyles.semiBoldViolet16, ),
                            ],
                          ),
                          verticalMargin24,
                          const Divider(thickness: 0.6, color: Colors.black38,),
                          user!.userInfo!.userType == UserType.artist ? Container()
                              :  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Capacity: ', style: TextStyles.semiBoldAccent16, ),
                              Text(user!.userArtInfo!.capacity!, style: TextStyles.semiBoldViolet16, ),
                              Text('Spaces: ', style: TextStyles.semiBoldAccent16, ),
                              Text(user!.userArtInfo!.spaces!, style: TextStyles.semiBoldViolet16, ),
                            ],
                          ),
                          verticalMargin24,
                          const Divider(thickness: 0.6, color: Colors.black38,),



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

                                  return SingleChildScrollView(
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
                                        if(index == 0) return const AddPhotoButton();
                                        return InkWell(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => PhotoDetails(artwork: user.artworks![index - 1])),
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
                                  );
                                }
                                return Container();
                              }),

                          // ImagePick()

                        ],
                      ),
                    ),
                  )
              );
            }
            return Scaffold(
                body: Stack(
                    children: [
                      widget,

                      user != null ? Padding(
                        padding: horizontalPadding12 + verticalPadding48,
                        child: InkWell(
                          onTap: () => print("test"),
                          child: Material(
                            elevation: 10,
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            child: ClipOval(
                                child: Image.network(user!.imageUrl, width: 70,)
                            ),
                          ),
                        ),
                      ) : Container(),

                    ]
                )
            );
          }
      );
  }
}

class AddPhotoButton extends StatelessWidget {
  const AddPhotoButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PhotoPage()),
      ),

      child: DottedBorder(
        color: AppTheme.primaryColourViolet,
        strokeWidth: 4,
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [
          8,
          10,
        ],
        child: SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  "+",
                  style: TextStyles.boldViolet16.copyWith(fontSize: 20),
                ),
                Text(
                  "Add Photo",
                  style: TextStyles.boldViolet16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
