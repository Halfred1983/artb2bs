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
import '../../home/view/home_view.dart';
import '../../injection.dart';
import '../../utils/currency/currency_helper.dart';
import '../../widgets/common_card_widget.dart';
import '../../widgets/dot_indicator.dart';
import '../../widgets/loading_screen.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';

import '../../widgets/tags.dart';
import '../../widgets/venue_card.dart';

class ArtistOnboardEnd extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => ArtistOnboardEnd());
  }

  ArtistOnboardEnd({Key? key}) : super(key: key);
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: ArtistOnboardEndView(),
    );
  }
}

class ArtistOnboardEndView extends StatefulWidget {
  @override
  _ArtistOnboardEndViewState createState() => _ArtistOnboardEndViewState();
}

class _ArtistOnboardEndViewState extends State<ArtistOnboardEndView> {


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
                    verticalMargin24,
                    const Text('Congratulations\non completing\nyour profile setup!',
                        style: TextStyle(
                            fontSize: 29, fontWeight: FontWeight.bold)),
                    verticalMargin24,
                    Text('You’re now ready to discover and book\namazing venues for your art exhibitions.',
                        style: TextStyles.semiBoldN90014),
                    verticalMargin48,
                    Container(
                      padding: const EdgeInsets.fromLTRB(21, 15, 21, 15),
                      // margin: const EdgeInsets.fromLTRB(21, 15, 21, 15),
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppTheme.s50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: RichText(
                          softWrap: true,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Pro Tip:',
                                style: TextStyles.boldN90014,
                              ),
                              TextSpan(
                                text:  ' Enhance your chances of getting\n'
                                    'your booking requests accepted by uploading '
                                    'your artwork to your portfolio.\nVenues love to'
                                    'see the creativity and quality of your work '
                                    'before confirming a booking.',
                                style: TextStyles.regularN90014,
                              ),
                            ],
                          ),
                        ),
                      )

                    )
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

