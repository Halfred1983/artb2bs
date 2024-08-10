import 'package:artb2b/host/cubit/host_state.dart';
import 'package:artb2b/host/view/photo_details.dart';
import 'package:artb2b/widgets/booking_settings.dart';
import 'package:artb2b/widgets/fadingin_picture.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../injection.dart';
import '../../../utils/common.dart';
import '../../../widgets/add_photo_button.dart';
import '../../app/resources/styles.dart';
import '../../photo/view/photo_upload_page.dart';
import '../cubit/host_cubit.dart';
import 'host_paypal_edit_page.dart';

class HostDashboardPage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => HostDashboardPage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<HostCubit>(
        create: (context) => HostCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child: const HostDashboardView(),
      );
  }
}



class HostDashboardView extends StatefulWidget {
  const HostDashboardView({super.key});

  @override
  State<HostDashboardView> createState() => _HostDashboardViewState();
}

class _HostDashboardViewState extends State<HostDashboardView> {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();


  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<HostCubit, HostState>(
          builder: (context, state) {
            if(state is BookingSettingsDetail) {
            }
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is LoadedState) {
              user = state.user;
            }
            return Scaffold(
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  title: Text(
                    "Your Dashboard", style: TextStyles.boldAccent24,),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: horizontalPadding24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/images/gallery.png", width: 60,),
                            horizontalMargin16,
                            Text(user!.userInfo!.name!, style: TextStyles.semiBoldAccent14, ),
                          ],
                        ),
                        verticalMargin12,
                        const Divider(thickness: 0.6, color: Colors.black38,),
                        verticalMargin12,
                        Text('About you: ', style: TextStyles.semiBoldAccent14, ),
                        verticalMargin12,
                        Text(user!.venueInfo!.aboutYou!, style: TextStyles.semiBoldAccent14, textAlign: TextAlign.left,),
                        verticalMargin24,
                        Row(
                          children: [
                            Text('Spaces: ', style: TextStyles.semiBoldAccent14, ),
                            Text(user!.venueInfo!.spaces!, style: TextStyles.semiBoldAccent14, ),
                            Expanded(child: Container()),
                            Text('Audience: ', style: TextStyles.semiBoldAccent14, ),
                            Text(user!.venueInfo!.audience ?? 'n/a', style: TextStyles.semiBoldAccent14, ),
                          ],
                        ),
                        verticalMargin32,
                        Text('Your booking settings', style: TextStyles.semiBoldAccent14, ),
                        const Divider(thickness: 0.6, color: Colors.black38,),
                        verticalMargin12,
                        BookingSettingsWidget(user: user),
                        verticalMargin12,
                        verticalMargin32,
                        Text('Your payout settings', style: TextStyles.semiBoldAccent14, ),
                        const Divider(thickness: 0.6, color: Colors.black38,),
                        Text('Your paypal account where to receive your payouts. ', style: TextStyles.regularAccent14, ),
                        verticalMargin24,
                        Row(
                          children: [
                            user!.bookingSettings!.paypalAccount != null ?
                            Text('Account: ${user!.bookingSettings!.paypalAccount}',
                                style: TextStyles.semiBoldAccent14) :
                            Text('‼️ Paypal account missing ‼️',
                                style: TextStyles.semiBoldAccent14) ,
                            Expanded(child: Container()),
                            Image.asset("assets/images/paypal_logo.png", width: 60,),
                          ],
                        ),
                        verticalMargin12,
                        Center(
                          child: TextButton(onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HostPaypalEditPage()),
                          ),
                            child: Text('Add/change your payout account' ,style: TextStyles.semiBoldAccent14.copyWith(
                                decoration: TextDecoration.underline
                            ),),
                          ),
                        ),

                        verticalMargin24,
                        Text('Photos of your space', style: TextStyles.semiBoldAccent14, ),
                        const Divider(thickness: 0.6, color: Colors.black38,),
                        //Photos
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

                                return user.photos != null && user.photos!.isNotEmpty ?
                                SingleChildScrollView(
                                  physics: const ScrollPhysics(),
                                  child: MasonryGridView.count(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: user.photos!.length + 1,
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
                                                      PhotoUploadPage()),
                                            ));
                                      }
                                      return InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => PhotoDetails(photo: user.photos![index - 1], isOwner: true)),
                                        ),
                                        child: Stack(
                                          children: [
                                            FadingInPicture(url:  user.photos![index - 1].url!),
                                            Positioned(
                                              bottom: 15,
                                              right: 25,
                                              child: Text(user.photos![index - 1].description ?? '',
                                                style: TextStyles.semiBoldAccent14,),
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
                                              PhotoUploadPage()),
                                    ));
                              }
                              return Container();
                            }),
                      ],
                    ),
                  ),
                )
            );
          }
      );
  }
}

