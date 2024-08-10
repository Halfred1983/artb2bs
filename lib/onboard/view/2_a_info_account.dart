import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:artb2b/onboard/view/3_venue_info.dart';
import 'package:artb2b/widgets/dot_indicator.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/loading_screen.dart';
import '3_a_artist_info.dart';


class InfoArtistAccountPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => InfoArtistAccountPage());
  }

  InfoArtistAccountPage({Key? key}) : super(key: key);
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: InfoArtistAccountView(),
    );
  }
}



class InfoArtistAccountView extends StatelessWidget {
  InfoArtistAccountView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }
        return Scaffold(
          body: Padding(
            padding: horizontalPadding48,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LineIndicator(
                    totalSteps: 3,
                    currentStep: 0,
                  ),
                  verticalMargin24,
                  Text('Let\'s get started in a few easy steps',
                      style: TextStyles.boldN90029),
                  verticalMargin48,
                  OnboardingList(
                      number: '1',
                      richText: RichText(
                        softWrap: true,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Create your profile ',
                              style: TextStyles.boldN90014,
                            ),
                            TextSpan(
                              text: 'and showcase \n your portfolio.',
                              style: TextStyles.regularN90014,
                            ),
                          ],
                        ),
                      )
                  ),
                  verticalMargin48,
                  Flexible(
                    child: OnboardingList(
                        number: '2',
                        richText: RichText(
                          softWrap: true,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Explore venues. ',
                                style: TextStyles.boldN90014,
                              ),
                              TextSpan(
                                text: 'Browse suggested\nvenues tailored to your preferences.',
                                style: TextStyles.regularN90014,
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  verticalMargin48,
                  Flexible(
                    child: OnboardingList(
                        number: '3',
                        richText: RichText(
                          softWrap: true,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Book your space.',
                                style: TextStyles.boldN90014,
                              ),
                              TextSpan(
                                text: ' Select a venue\nand check its availability.  ',
                                style: TextStyles.regularN90014,
                              ),

                            ],
                          ),
                        )
                    ),
                  ),
                  verticalMargin48,
                  Flexible(
                    child: OnboardingList(
                        number: '4',
                        richText: RichText(
                          softWrap: true,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Manage your bookings. ',
                                style: TextStyles.regularN90014,
                              ),
                              TextSpan(
                                text: 'Track\nyour booking requests and get\nnotifications once they are\nconfirmed.',
                                style: TextStyles.boldN90014,
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Container(
            padding: horizontalPadding32,
            width: double.infinity,
            child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ArtistInfoPage()), // Replace NewPage with the actual class of your new page
                  );
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
}

class OnboardingList extends StatelessWidget {
  OnboardingList({
    super.key,
    required this.richText,
    required this.number
  });

  RichText richText;
  String number;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 28, // Adjust the size as needed
          height: 28, // Adjust the size as needed
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor, // Set the background color
            shape: BoxShape.circle, // Make it round
          ),
          child: Center(
            child: Text(number, style: TextStyles.boldN90014,),
          ),
        ),
        horizontalMargin16,
        richText
      ],
    );
  }
}