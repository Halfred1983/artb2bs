import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:artb2b/onboard/view/10_venue_opening_time.dart';
import 'package:artb2b/onboard/view/4_venue_address.dart';
import 'package:artb2b/widgets/number_slider.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/tags.dart';


class VenueAudience extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => VenueAudience());
  }

  VenueAudience({Key? key}) : super(key: key);
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: VenueDescriptionView(),
    );
  }
}



class VenueDescriptionView extends StatefulWidget {
  VenueDescriptionView({Key? key}) : super(key: key);

  @override
  State<VenueDescriptionView> createState() => _VenueDescriptionViewState();
}

class _VenueDescriptionViewState extends State<VenueDescriptionView> {

  int _venueAudience = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }
        User? user;
        if(state is LoadedState) {
          user = state.user;
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: horizontalPadding32 + verticalPadding48,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    verticalMargin48,
                    Text('Venue capacity',
                        style: TextStyles.boldN90029),
                    verticalMargin48,
                    Text('Set your venue\'s capacity by choosing the amount of people that fits into your venue.',
                        style: TextStyles.semiBoldN90014),
                    verticalMargin24,
                    NumberSlider(value: user != null &&
                      user.userArtInfo!.audience != null ? int.parse(user.userArtInfo!.audience!)
                        : 0, onChanged: (int value) {
                      // Do something with the new range values
                      _venueAudience = value;
                      context.read<OnboardingCubit>().chooseAudience(value.toString());
                    },
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
                    context.read<OnboardingCubit>().save(user!, UserStatus.capacityInfo);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VenueOpeningTimeView()), // Replace NewPage with the actual class of your new page
                    );
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
    return _venueAudience > 0;
  }
}
