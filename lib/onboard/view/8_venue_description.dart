import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:artb2b/onboard/view/4_venue_address.dart';
import 'package:artb2b/widgets/dot_indicator.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../host/view/host_setting_page.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/tags.dart';
import '9_venue_audience.dart';


class VenueDescription extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => VenueDescription());
  }

  VenueDescription({Key? key, this.isOnboarding = true}) : super(key: key);

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
      child: VenueDescriptionView(isOnboarding: isOnboarding),
    );
  }
}



class VenueDescriptionView extends StatefulWidget {
  VenueDescriptionView({Key? key, this.isOnboarding = true}) : super(key: key);

  final bool isOnboarding;

  @override
  State<VenueDescriptionView> createState() => _VenueDescriptionViewState();
}

class _VenueDescriptionViewState extends State<VenueDescriptionView> {
  final TextEditingController _venueDescriptionController = TextEditingController();

  String _venueDescription = '';


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }
        User? user;
        if(state is LoadedState || state is DataSaved) {
          user = state.user;

          if(!widget.isOnboarding) {
            _venueDescription = user!.venueInfo!.aboutYou!;
            _venueDescriptionController.text =_venueDescription;
          }
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: !widget.isOnboarding ? AppBar(
            scrolledUnderElevation: 0,
            title: Text(user!.userInfo!.name!, style: TextStyles.boldN90017,),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: AppTheme.n900, //change your color here
            ),
          ) : null,
          body: SingleChildScrollView(
            child: Padding(
              padding: horizontalPadding32 + (widget.isOnboarding ? verticalPadding48 : EdgeInsets.zero),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(widget.isOnboarding)... [
                      verticalMargin48,
                      const LineIndicator(
                        totalSteps: 9,
                        currentStep: 6,
                      ),
                      verticalMargin24,
                      Text('Now, let\'s describe your space',
                          style: TextStyles.boldN90029),
                      verticalMargin48,
                    ],
                    Text('Share the magic of your space with a captivating description that will inspire artists and event planners alike!',
                        style: TextStyles.semiBoldN90014),
                    verticalMargin24,
                    TextFormField(
                      buildCounter: (
                          BuildContext context, {
                            required int currentLength,
                            required bool isFocused,
                            required int? maxLength,
                          })
                      {
                        return Text(
                          '$currentLength characters',
                          style: currentLength < 50 ?
                          TextStyles.regularN90014 : TextStyles.boldN90014,
                        );
                      },
                      controller: _venueDescriptionController,
                      autofocus: false,
                      style: TextStyles.semiBoldN90014,
                      onChanged: (String value) {
                        _venueDescription = value;
                        context.read<OnboardingCubit>().choseAboutYou(value);
                      },
                      maxLines: 10, // Adjust the number of lines as needed
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: AppTheme.textAreaInputDecoration
                          .copyWith(hintText: 'Tell us about your space. Min 50 characters.',),
                      keyboardType: TextInputType.text,
                    ),
                    verticalMargin24,
                    if(widget.isOnboarding)
                      Container(
                      padding: const EdgeInsets.fromLTRB(21, 15, 21, 15),
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppTheme.s50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'You can change this whenever you'
                            ' want from your listing settings.',
                        style: TextStyles.regularN90014, textAlign: TextAlign.center,
                      ),
                    )
                  ],
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
                      context.read<OnboardingCubit>().save(user!, UserStatus.descriptionInfo);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VenueAudience()), // Replace NewPage with the actual class of your new page
                      );
                    }
                    else {
                      context.read<OnboardingCubit>().save(user!);
                      Navigator.of(context)..pop()..pop();
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
    return _venueDescription.isNotEmpty && _venueDescription.length>=50;
  }
}
