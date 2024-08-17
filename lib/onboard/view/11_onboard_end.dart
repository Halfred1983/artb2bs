import 'package:artb2b/utils/common.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/resources/assets.dart';
import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../home/view/home_page.dart';
import '../../injection.dart';
import '../../utils/currency/currency_helper.dart';
import '../../widgets/common_card_widget.dart';
import '../../widgets/dot_indicator.dart';
import '../../widgets/loading_screen.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';

import '../../widgets/tags.dart';
import '../../widgets/venue_card.dart';

class VenueOnboardEnd extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => VenueOnboardEnd());
  }

  VenueOnboardEnd({Key? key}) : super(key: key);
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: VenueOnboardEndView(),
    );
  }
}

class VenueOnboardEndView extends StatefulWidget {
  @override
  _VenueOnboardEndViewState createState() => _VenueOnboardEndViewState();
}

class _VenueOnboardEndViewState extends State<VenueOnboardEndView> {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }
        User? user;
        if (state is LoadedState) {
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
                    const LineIndicator(
                      totalSteps: 9,
                      currentStep: 8,
                    ),
                    verticalMargin24,
                    const Text('Great! your first listing is ready to go!',
                        style: TextStyle(
                            fontSize: 29, fontWeight: FontWeight.bold)),
                    verticalMargin24,
                    Text('Your listing won’t be visible to others until you set the availability as open in your listing settings.',
                        style: TextStyles.semiBoldN90014),
                    verticalMargin24,
                  VenueCard(user: user!)
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            width: double.infinity,
            child: FloatingActionButton(
              backgroundColor: AppTheme.n900,
              foregroundColor: AppTheme.primaryColor,
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage()),
                  );
              },
              child: const Text('Continue'),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
        );
      },
    );
  }

}

