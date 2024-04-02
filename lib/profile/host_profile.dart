import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/artwork/view/artwork_details.dart';
import 'package:artb2b/booking/view/booking_page.dart';
import 'package:artb2b/host/view/photo_details.dart';
import 'package:artb2b/injection.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/booking_settings.dart';
import 'package:artb2b/widgets/fadingin_picture.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../app/resources/assets.dart';
import '../widgets/audience.dart';

class HostProfilePage extends StatefulWidget {
  final String userId;

  HostProfilePage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<HostProfilePage> createState() => _HostProfilePageState();
}

class _HostProfilePageState extends State<HostProfilePage> {
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();
  int _currentIndex = 0;
  final controller = PageController(viewportFraction: 1, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: databaseService.getUser(userId: widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.connectionState == ConnectionState.active
              || snapshot.connectionState == ConnectionState.done) {

            if (snapshot.hasData && snapshot.data != null) {
              bool isArtist = snapshot.data!.userInfo!.userType == UserType.artist;

              User user = snapshot.data!;
              List<Widget> photos = [];

              if (user.photos != null && user.photos!.isNotEmpty) {
                photos = List.generate(
                  user.photos!.length,
                      (index) => ShaderMask(
                        // blendMode: BlendMode.src,
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.black,
                              ],
                              begin: Alignment.center,
                              end: Alignment.bottomCenter
                          ).createShader(bounds);
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all( Radius.circular(24)),
                          child: FadeInImage(
                            width: double.infinity,
                            placeholder: const AssetImage(Assets.logo),
                            image: NetworkImage(user.photos![index].url!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                );
              }

              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Text( user.userInfo!.name!, style: TextStyles.boldN90017,),
                  centerTitle: true,
                  titleSpacing: 0,
                  iconTheme: const IconThemeData(
                    color: AppTheme.black, //change your color here
                  ),
                ),
                body: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                        padding: horizontalPadding8 + verticalPadding8,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 500,
                                    width: double.infinity,
                                    child: PageView.builder(
                                      onPageChanged: (pageId,) {
                                        setState(() {
                                          _currentIndex = pageId;
                                        });
                                      },
                                      padEnds: false,
                                      controller: controller,
                                      itemCount: user.photos!.length,
                                      itemBuilder: (_, index) {
                                        return photos[index % photos.length];
                                      },
                                    ), // Select photo dynamically using index
                                  ),
                                  Positioned(
                                    bottom: 24,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        AnimatedSmoothIndicator(
                                          activeIndex:_currentIndex,
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
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 48,
                                    left: 0,
                                    child: Padding(
                                      padding: horizontalPadding32,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(user.userInfo!.name!, style: TextStyles.boldWhite29,),
                                          Text(user.userInfo!.address!.formattedAddress, style: TextStyles.regularWhite17,),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              verticalMargin32,
                              Padding(
                                  padding: horizontalPadding24,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  AudienceWidget(audienceCount: snapshot.data!.userArtInfo!.audience != null ? int.parse(snapshot.data!.userArtInfo!.audience!) : 0,),
                                                  Text(user.userArtInfo!.audience ?? 0.toString(), style: TextStyles.boldAccent20,),
                                                ],
                                              ),
                                              verticalMargin8,
                                              Text('Audience/Day', style: TextStyles.semiBoldN20014,)
                                            ],
                                          ),

                                          horizontalMargin12,
                                          const SizedBox(height: 48, child: VerticalDivider(color: AppTheme.divider)),
                                          horizontalMargin12,

                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(user.userArtInfo!.spaces!, style: TextStyles.boldAccent20,),
                                                  const Icon(Icons.crop_free_sharp, size: 24, color: AppTheme.accentColor,),
                                                ],
                                              ),
                                              verticalMargin8,
                                              Text('Total Spaces', style: TextStyles.semiBoldN20014,)
                                            ],
                                          ),
                                        ],
                                      ),
                                      verticalMargin32,
                                      Text(user.userArtInfo!.aboutYou!, style: TextStyles.regularN200,),
                                      verticalMargin32,
                                      const SizedBox(width: 325, child: Divider(height: 1, color: AppTheme.divider)),
                                      verticalMargin32,
                                      Text('Opening hours', style: TextStyles.semiBoldN90014,),
                                      verticalMargin8,
                                      Row(
                                        children: [
                                          Text('Mon-Sun', style: TextStyles.regularN90014,),
                                          horizontalMargin32,
                                          Text('09:00 - 18:00', style: TextStyles.regularN90014,),
                                        ],
                                      ),
                                      verticalMargin32,
                                      Text('Booking requirements', style: TextStyles.semiBoldN90014,),
                                      verticalMargin8,
                                      Text('Min spaces: '+user.bookingSettings!.minSpaces.toString(), style: TextStyles.regularN90014,),
                                      verticalMargin8,
                                      Text('Min days: '+user.bookingSettings!.minLength.toString(), style: TextStyles.regularN90014,),
                                    ],
                                  )
                              ),



                              // Row(
                              //   children: [
                              //     Image.asset(isArtist ? "assets/images/artist.png" :  "assets/images/gallery.png", width: 60,),
                              //     horizontalMargin16,
                              //     Text(snapshot.data!.userInfo!.name!, style: TextStyles.semiBoldAccent14, ),
                              //     Expanded(child: Container()),
                              //     Image.asset('assets/images/marker.png', width: 20,),
                              //     horizontalMargin12,
                              //     Text(snapshot.data!.userInfo!.address!.city,
                              //       softWrap: true, style: TextStyles.semiBoldAccent14,),
                              //   ],
                              // ),
                              // const Divider(thickness: 0.6, color: Colors.black38,),
                              // verticalMargin12,
                              // Text('About the host: ', style: TextStyles.semiBoldAccent14, ),
                              // verticalMargin12,
                              // Text(snapshot.data!.userArtInfo!.aboutYou!, style: TextStyles.semiBoldAccent14, textAlign: TextAlign.left,),
                              //
                              // Row(
                              //   children: [
                              //     // Text('Profile Views: ', style: TextStyles.semiBoldAccent14, ),
                              //     FutureBuilder(
                              //         future: databaseService.updateViewCounter(widget.userId),
                              //         builder: (context, snapshot) {
                              //           if (snapshot.connectionState == ConnectionState.waiting) {
                              //             return Container(); CircularProgressIndicator(color: AppTheme.primaryColor,);
                              //           } else if (snapshot.connectionState == ConnectionState.active
                              //               || snapshot.connectionState == ConnectionState.done) {
                              //             if (snapshot.hasData && snapshot.data != null) {
                              //               return Container(); Text(snapshot.data.toString(), style: TextStyles.semiBoldAccent14, );
                              //             }
                              //             return Text('n/a', style: TextStyles.semiBoldAccent14, );
                              //           }
                              //           return Text('n/a', style: TextStyles.semiBoldAccent14, );
                              //         }
                              //     ),
                              //     Expanded(child: Container()),
                              //   ],
                              // ),
                              //
                              // verticalMargin12,
                              // if(!isArtist) ...[
                              //   BookingSettingsWidget(user: snapshot.data!,),
                              //   verticalMargin12,
                              //   Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     mainAxisSize: MainAxisSize.max,
                              //     children: [
                              //       Text("Address: ", style: TextStyles.semiBoldAccent14, ),
                              //       Flexible(child: Text(snapshot.data!.userInfo!.address!.formattedAddress,
                              //         softWrap: true, style: TextStyles.semiBoldAccent14, )),
                              //     ],
                              //   ),
                              // ] else ...[ Container() ],
                              // verticalMargin12,
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   mainAxisSize: MainAxisSize.max,
                              //   children: [
                              //     Flexible(flex: 1, child: Text("Vibes: ", softWrap: true, style: TextStyles.semiBoldAccent14,)),
                              //   ],
                              // ),
                              // Text(snapshot.data!.userArtInfo!.vibes!.join(", "), softWrap: true, style: TextStyles.semiBoldAccent14,),
                              // verticalMargin32,
                              //
                              // Text(isArtist ? 'Artworks' : 'Photos', style: TextStyles.semiBoldAccent14, ),
                              // const Divider(thickness: 0.6, color: Colors.black38,),
                              // verticalMargin12,
                              // //ARTIST
                              // isArtist ?
                              //
                              // snapshot.data!.artworks != null
                              //     && snapshot.data!.artworks!.isNotEmpty ?
                              // SingleChildScrollView(
                              //   physics: const ScrollPhysics(),
                              //   child: MasonryGridView.count(
                              //     physics: const BouncingScrollPhysics(),
                              //     itemCount: snapshot.data!.artworks!.length,
                              //     scrollDirection: Axis.vertical,
                              //     shrinkWrap: true,
                              //     mainAxisSpacing: 10,
                              //     crossAxisSpacing: 6,
                              //     crossAxisCount: 2,
                              //     itemBuilder: (context, index) {
                              //       return InkWell(
                              //         onTap: () => Navigator.push(
                              //           context,
                              //           MaterialPageRoute(builder: (context) => ArtworkDetails(artwork: snapshot.data!.artworks![index], isOwner: false,), ),
                              //         ),
                              //         child: Stack(
                              //           children: [
                              //             FadingInPicture(url: snapshot.data!.artworks![index].url!),
                              //             Positioned(
                              //               bottom: 15,
                              //               right: 25,
                              //               child: Text(snapshot.data!.artworks![index].name!,
                              //                 style: TextStyles.semiBoldAccent14,),
                              //             )
                              //           ],
                              //         ),
                              //       );
                              //
                              //     },
                              //   ),
                              // ) :   SizedBox(height: 90, child: Center(child: Text("Artist has no photos yet",  style: TextStyles.semiBoldAccent14)))
                              //     :
                              // snapshot.data!.photos != null
                              //     && snapshot.data!.photos!.isNotEmpty ?
                              // SingleChildScrollView(
                              //   physics: const ScrollPhysics(),
                              //   child: MasonryGridView.count(
                              //     physics: const BouncingScrollPhysics(),
                              //     itemCount: snapshot.data!.photos!.length,
                              //     scrollDirection: Axis.vertical,
                              //     shrinkWrap: true,
                              //     mainAxisSpacing: 10,
                              //     crossAxisSpacing: 6,
                              //     crossAxisCount: 2,
                              //     itemBuilder: (context, index) {
                              //
                              //       return InkWell(
                              //         onTap: () => Navigator.push(
                              //           context,
                              //           MaterialPageRoute(builder: (context) => PhotoDetails(photo: snapshot.data!.photos![index], isOwner: false,), ),
                              //         ),
                              //         child: Stack(
                              //           children: [
                              //             FadingInPicture(url: snapshot.data!.photos![index].url!,),
                              //             Positioned(
                              //               bottom: 15,
                              //               right: 25,
                              //               child: Text(snapshot.data!.photos![index].description ?? '',
                              //                 style: TextStyles.semiBoldAccent14,),
                              //             )
                              //           ],
                              //         ),
                              //       );
                              //
                              //     },
                              //   ),
                              // ) :
                              // SizedBox(height: 90, child: Center(child: Text("Host has no photos yet",  style: TextStyles.semiBoldAccent14))),
                              // // Flexible(child: Container()),
                            ]
                        )
                    )
                ),
                bottomNavigationBar: !isArtist ?
                Container(
                  padding: buttonPadding,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookingPage(host: snapshot.data!,)),
                      );
                    },
                    child: Text("Book", style: TextStyles.semiBoldAccent14,),),
                ) : null,
              );
            }
            else {
              return Container();
            }
          }
          else {
            return Container();
          }
        }
    );
  }
}