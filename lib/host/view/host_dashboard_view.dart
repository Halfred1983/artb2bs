import 'package:artb2b/host/cubit/host_cubit.dart';
import 'package:artb2b/host/cubit/host_state.dart';
import 'package:artb2b/host/view/photo_details.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../injection.dart';
import '../../../utils/common.dart';
import '../../../widgets/add_photo_button.dart';
import '../../app/resources/styles.dart';
import '../../photo/view/artwork_upload_page.dart';
import '../../photo/view/photo_upload_page.dart';
import 'host_dashboard_edit_page.dart';

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
                  title: Text(
                    "Your Dashboard", style: TextStyles.boldAccent24,),
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
                            Image.asset("assets/images/gallery.png", width: 60,),
                            horizontalMargin16,
                            Text(user!.userInfo!.name!, style: TextStyles.semiBoldViolet18, ),
                          ],
                        ),
                        verticalMargin24,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Capacity: ', style: TextStyles.semiBoldAccent16, ),
                            Text(user!.userArtInfo!.capacity!, style: TextStyles.semiBoldViolet16, ),
                            Text('Spaces: ', style: TextStyles.semiBoldAccent16, ),
                            Text(user!.userArtInfo!.spaces!, style: TextStyles.semiBoldViolet16, ),
                          ],
                        ),
                        verticalMargin24,
                        Text('Your booking settings', style: TextStyles.semiBoldAccent18, ),
                        const Divider(thickness: 0.6, color: Colors.black38,),
                        verticalMargin24,
                        _BookingSettings(user: user),
                        verticalMargin24,
                        TextButton(onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HostDashboardEditPage()),
                        ),
                          child: Text('Add/change your booking settings' ,style: TextStyles.semiBoldViolet16.copyWith(
                              decoration: TextDecoration.underline
                          ),),
                        ),

                        verticalMargin24,
                        Text('Your photos', style: TextStyles.semiBoldAccent18, ),
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
                                                      ArtworkUploadPage()),
                                            ));
                                      }
                                      return InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => PhotoDetails(photo: user.photos![index - 1], isOwner: true)),
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
                                                    user.photos![index - 1].url!,
                                                    fit: BoxFit.contain
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 15,
                                              right: 25,
                                              child: Text(user.photos![index - 1].description!,
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

class _BookingSettings extends StatelessWidget {
  const _BookingSettings({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Base price per space: ', style: TextStyles.semiBoldAccent16, ),
              Text('${user!.bookingSettings!.basePrice ?? 'n/a'} £', style: TextStyles.semiBoldViolet16, ),
            ]
        ),
        verticalMargin12,
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Minimum length: ', style: TextStyles.semiBoldAccent16, ),
              Text('${user!.bookingSettings!.minLength ?? 'n/a'} days', style: TextStyles.semiBoldViolet16, ),
            ]
        ),
        verticalMargin12,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Minimum spaces: ', style: TextStyles.semiBoldAccent16, ),
            Text(user!.bookingSettings!.minLength ?? 'n/a', style: TextStyles.semiBoldViolet16, ),
          ],
        ),
      ],
    );
  }
}
