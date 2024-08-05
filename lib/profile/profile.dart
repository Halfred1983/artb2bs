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
import 'package:lottie/lottie.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  ProfilePage({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: databaseService.getUser(userId: userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.connectionState == ConnectionState.active
              || snapshot.connectionState == ConnectionState.done) {

            if (snapshot.hasData && snapshot.data != null) {
              bool isArtist = snapshot.data!.userInfo!.userType == UserType.artist;

              return Scaffold(
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  title: Text(isArtist ? "Artist Profile" : "Host Profile", style: TextStyles.boldAccent24,),
                  centerTitle: true,
                  iconTheme: const IconThemeData(
                    color: AppTheme.primaryColor, //change your color here
                  ),
                ),
                body: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                        padding: horizontalPadding24,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(isArtist ? "assets/images/artist.png" :  "assets/images/gallery.png", width: 60,),
                                  horizontalMargin16,
                                  Text(snapshot.data!.userInfo!.name!, style: TextStyles.semiBoldAccent14, ),
                                  Expanded(child: Container()),
                                  Image.asset('assets/images/marker.png', width: 20,),
                                  horizontalMargin12,
                                  Text(snapshot.data!.userInfo!.address!.city,
                                    softWrap: true, style: TextStyles.semiBoldAccent14,),
                                ],
                              ),
                              const Divider(thickness: 0.6, color: Colors.black38,),
                              verticalMargin12,
                              Text('About the host: ', style: TextStyles.semiBoldAccent14, ),
                              verticalMargin12,
                              Text(snapshot.data!.userArtInfo!.aboutYou!, style: TextStyles.semiBoldAccent14, textAlign: TextAlign.left,),

                              Row(
                                children: [
                                  // Text('Profile Views: ', style: TextStyles.semiBoldAccent14, ),
                                  FutureBuilder(
                                      future: databaseService.updateViewCounter(userId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Container(); CircularProgressIndicator(color: AppTheme.primaryColor,);
                                        } else if (snapshot.connectionState == ConnectionState.active
                                            || snapshot.connectionState == ConnectionState.done) {
                                          if (snapshot.hasData && snapshot.data != null) {
                                            return Container(); Text(snapshot.data.toString(), style: TextStyles.semiBoldAccent14, );
                                          }
                                          return Text('n/a', style: TextStyles.semiBoldAccent14, );
                                        }
                                        return Text('n/a', style: TextStyles.semiBoldAccent14, );
                                      }
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),

                              verticalMargin12,
                              if(!isArtist) ...[
                                BookingSettingsWidget(user: snapshot.data!,),
                                verticalMargin12,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text("Address: ", style: TextStyles.semiBoldAccent14, ),
                                    Flexible(child: Text(snapshot.data!.userInfo!.address!.formattedAddress,
                                      softWrap: true, style: TextStyles.semiBoldAccent14, )),
                                  ],
                                ),
                              ] else ...[ Container() ],
                              verticalMargin12,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(flex: 1, child: Text("Vibes: ", softWrap: true, style: TextStyles.semiBoldAccent14,)),
                                ],
                              ),
                              Text(snapshot.data!.userArtInfo!.vibes!.join(", "), softWrap: true, style: TextStyles.semiBoldAccent14,),
                              verticalMargin32,

                              Text(isArtist ? 'Artworks' : 'Photos', style: TextStyles.semiBoldAccent14, ),
                              const Divider(thickness: 0.6, color: Colors.black38,),
                              verticalMargin12,
                              //ARTIST
                              isArtist ?

                              snapshot.data!.artworks != null
                                  && snapshot.data!.artworks!.isNotEmpty ?
                              SingleChildScrollView(
                                physics: const ScrollPhysics(),
                                child: MasonryGridView.count(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.artworks!.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 6,
                                  crossAxisCount: 2,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ArtworkDetails(artwork: snapshot.data!.artworks![index], isOwner: false,), ),
                                      ),
                                      child: Stack(
                                        children: [
                                          FadingInPicture(url: snapshot.data!.artworks![index].url!),
                                          Positioned(
                                            bottom: 15,
                                            right: 25,
                                            child: Text(snapshot.data!.artworks![index].name!,
                                              style: TextStyles.semiBoldAccent14,),
                                          )
                                        ],
                                      ),
                                    );

                                  },
                                ),
                              ) :   SizedBox(height: 90, child: Center(child: Text("Artist has no photos yet",  style: TextStyles.semiBoldAccent14)))
                                  :
                              snapshot.data!.photos != null
                                  && snapshot.data!.photos!.isNotEmpty ?
                              SingleChildScrollView(
                                physics: const ScrollPhysics(),
                                child: MasonryGridView.count(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.photos!.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 6,
                                  crossAxisCount: 2,
                                  itemBuilder: (context, index) {

                                    return InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => PhotoDetails(photo: snapshot.data!.photos![index], isOwner: false,), ),
                                      ),
                                      child: Stack(
                                        children: [
                                          FadingInPicture(url: snapshot.data!.photos![index].url!,),
                                          Positioned(
                                            bottom: 15,
                                            right: 25,
                                            child: Text(snapshot.data!.photos![index].description ?? '',
                                              style: TextStyles.semiBoldAccent14,),
                                          )
                                        ],
                                      ),
                                    );

                                  },
                                ),
                              ) :
                              SizedBox(height: 90, child: Center(child: Text("Host has no photos yet",  style: TextStyles.semiBoldAccent14))),
                              // Flexible(child: Container()),
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