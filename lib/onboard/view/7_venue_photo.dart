import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:artb2b/onboard/view/8_venue_description.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../host/view/host_setting_page.dart';
import '../../host/view/photo_details.dart';
import '../../injection.dart';
import '../../photo/view/photo_upload_page.dart';
import '../../utils/common.dart';
import '../../widgets/add_photo_button.dart';
import '../../widgets/dot_indicator.dart';
import '../../widgets/fadingin_picture.dart';
import '../../widgets/loading_screen.dart';


class VenuePhotoPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => VenuePhotoPage());
  }

  VenuePhotoPage({Key? key, this.isOnboarding = true}) : super(key: key);

  bool isOnboarding;
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: SelectPhotoView(isOnboarding:isOnboarding),
    );
  }
}



class SelectPhotoView extends StatefulWidget {
  SelectPhotoView({Key? key, this.isOnboarding = true}) : super(key: key);

  final bool isOnboarding;
  @override
  State<SelectPhotoView> createState() => _SelectPhotoViewState();
}

class _SelectPhotoViewState extends State<SelectPhotoView> {
  User? _user;
  bool _reordered = false;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }
        if(state is LoadedState || state is DataSaved) {
          _user = state.user;
        }
        return Scaffold(
          appBar: !widget.isOnboarding ? AppBar(
            scrolledUnderElevation: 0,
            title: Text(_user!.userInfo!.name!, style: TextStyles.boldN90017,),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: AppTheme.n900, //change your color here
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Define your navigation action here
                Navigator.of(context).pop();
              },
            ),
          ) : null,
          body: Padding(
            padding: horizontalPadding32 + (widget.isOnboarding ? verticalPadding48 : EdgeInsets.zero),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(widget.isOnboarding)... [
                  verticalMargin48,
                  const LineIndicator(
                    totalSteps: 9,
                    currentStep: 5,
                  ),
                  verticalMargin24,
                  Text('Venue Photos.\nShow off your space!',
                      style: TextStyles.boldN90029),
                  verticalMargin48,
                ],
                Text('Upload high-quality photos of your venue to attract artists and event organisers.',
                    style: TextStyles.semiBoldN90014),
                verticalMargin24,
                if(_user != null) ... [
                  Expanded(
                    child: ReorderableGridView.count(
                      crossAxisCount: 2, // Set the number of columns
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      physics: const AlwaysScrollableScrollPhysics(),
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          _reordered = true;
                          final element = _user!.photos!.removeAt(oldIndex);
                          _user!.photos!.insert(newIndex, element);
                        });
                      },
                      dragEnabled: widget.isOnboarding ? false : true,
                      header: [Container(
                        height: 100,
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AddPhotoButton(
                            action: () async {
                              await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PhotoUploadPage(isOnboarding: widget.isOnboarding)),
                              );

                              context.read<OnboardingCubit>().getUser(_user!.id);
                            }
                        ),
                      )],
                      children: _user!.photos != null && _user!.photos!.isNotEmpty ?
                      _user!.photos!.map((photo) => _buildPhoto(photo)).toList() : [Container()],
                    ),
                  ),
                ],
                verticalMargin48,
                if( (_user == null || _user!.photos == null || _user!.photos!.isEmpty)
                    && widget.isOnboarding ) ... [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap:()  {
                        context.read<OnboardingCubit>().save(_user!, UserStatus.photoInfo);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VenueDescription()), // Replace NewPage with the actual class of your new page
                        );
                      },
                        child:Text('Skip this step and add photos later.', style: TextStyles.semiBoldN90014.copyWith(decoration: TextDecoration.underline),),
                      )
                    ],
                  ),
                ],
              ],
            ),
          ),
          floatingActionButton: widget.isOnboarding || _reordered ? Container(
            padding: horizontalPadding32,
            width: double.infinity,
            child: FloatingActionButton(
                backgroundColor:  _canContinue() ? AppTheme.n900 : AppTheme.disabledButton,
                foregroundColor: _canContinue() ? AppTheme.primaryColor : AppTheme.n900,
                onPressed: () {
                  if(_canContinue()) {
                    if(widget.isOnboarding) {
                      context.read<OnboardingCubit>().save(
                          _user!, UserStatus.photoInfo);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            VenueDescription()), // Replace NewPage with the actual class of your new page
                      );
                    }
                    else {
                      context.read<OnboardingCubit>().save(_user!);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HostSettingPage()),
                      );
                    }
                  }
                  else {
                    return;
                  }
                },
                child: Text(widget.isOnboarding ? 'Continue' : 'Save',)
            ),
          ) : null,
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
        );
      },
    );
  }

  bool _canContinue() {
    return  _user != null && _user!.photos != null && _user!.photos!.isNotEmpty;
  }

  Widget _buildPhoto(Photo photo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      key: ValueKey(photo.url),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotoDetails(photo: photo,
              isOwner: true, isOnboarding: widget.isOnboarding)),
        ),
        child:
        FadingInPicture(radius: 12, url: photo.url!, applyBottomRadius: true,),
      ),
    );
  }
}


