import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:artb2b/onboard/view/8_venue_description.dart';
import 'package:artb2b/widgets/google_places.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../host/view/host_setting_page.dart';
import '../../host/view/photo_details.dart';
import '../../injection.dart';
import '../../login/view/2_signup_view.dart';
import '../../photo/view/photo_upload_page.dart';
import '../../utils/common.dart';
import '../../utils/currency/currency_helper.dart';
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
  final TextEditingController _priceController = TextEditingController();
  User? _user;

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
          ) : null,
          body: SingleChildScrollView(
            child: Padding(
              padding: horizontalPadding32 + (widget.isOnboarding ? verticalPadding48 : EdgeInsets.zero),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 200),
                  child: IntrinsicHeight(
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
                          _user!.photos != null && _user!.photos!.isNotEmpty ?
                          SizedBox(
                            // color: Colors.red,
                            height: 500,
                            child: MasonryGridView.count(
                              physics: const BouncingScrollPhysics(),
                              itemCount: _user!.photos!.length + 1,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 6,
                              crossAxisCount: 2,
                              itemBuilder: (context, index) {
                                if(index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AddPhotoButton(
                                        action: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PhotoUploadPage()),
                                          );
                                          context.read<OnboardingCubit>().getUser(_user!.id);
                                        }
                                    ),
                                  );
                                }
                                return InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PhotoDetails(photo: _user!.photos![index - 1], isOwner: true)),
                                  ),
                                  child: Stack(
                                    children: [
                                      FadingInPicture(radius: 12, url:  _user!.photos![index - 1].url!, applyBottomRadius: true,),
                                      Positioned(
                                        bottom: 15,
                                        right: 25,
                                        child: Text(_user!.photos![index - 1].description ?? '',
                                          style: TextStyles.semiBoldPrimary14,),
                                      )
                                    ],
                                  ),
                                );

                              },
                            ),
                          ) : AddPhotoButton(
                              action: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PhotoUploadPage()),
                                );
                                context.read<OnboardingCubit>().getUser(_user!.id);
                              }
                          ),
                        ],
                        verticalMargin24,
                        Flexible(child: Container(),),

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
                                child:Text('Skip this step', style: TextStyles.semiBoldN90014,),
                              )
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: Container(
            padding: horizontalPadding32,
            width: double.infinity,
            child: FloatingActionButton(
                backgroundColor:  _canContinue() ? AppTheme.n900 : AppTheme.disabledButton,
                foregroundColor: _canContinue() ? AppTheme.primaryColor : AppTheme.n900,
                onPressed: () {
                  if(_canContinue()) {
                    if (widget.isOnboarding) {
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
                      Navigator.of(context)..pop();
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
                child: const Text('Continue',)
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
        );
      },
    );
  }

  bool _canContinue() {
    return  _user != null && _user!.photos != null && _user!.photos!.isNotEmpty;
  }
}

class PlusMinusButton extends StatelessWidget {
  const PlusMinusButton({
    super.key, required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: Colors.transparent, // Circle color
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.accentColor, width: 3),
      ),
      child: Align(
          alignment: Alignment.center,
          child: Icon(
            text == '+' ? Icons.add : Icons.remove,
            color: AppTheme.accentColor,
            size: 30,
          )
      ),
    );
  }
}

class InactiveTextField extends StatelessWidget {
  const InactiveTextField({
    super.key, required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      enabled: false,
      style: TextStyles.semiBoldN90014,
      autocorrect: false,
      enableSuggestions: false,
      decoration: AppTheme.textInputDecoration.copyWith(hintText: label,
          fillColor: AppTheme.disabledButton),
      keyboardType: TextInputType.text,
    );
  }
}
