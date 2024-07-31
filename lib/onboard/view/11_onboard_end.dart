import 'package:artb2b/utils/common.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/resources/assets.dart';
import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/currency/currency_helper.dart';
import '../../widgets/common_card_widget.dart';
import '../../widgets/loading_screen.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';

import '../../widgets/tags.dart';

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
              padding: const EdgeInsets.symmetric(
                  horizontal: 32.0, vertical: 48.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    verticalMargin48,
                    const Text('Great! your first listing is ready to go!',
                        style: TextStyle(
                            fontSize: 29, fontWeight: FontWeight.bold)),
                    verticalMargin24,
                    Text('Your listing won’t be visible to others until you set the availability as open in your listing settings.',
                        style: TextStyles.semiBoldN90014),
                    verticalMargin24,
                  Container(
                    width: double.infinity,
                    padding: verticalPadding8,
                    child: CommonCard(
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(24),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            if(user!.photos == null && user.photos!.isEmpty) ...[
                              const Stack(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: double.infinity,
                                    child: FadeInImage(
                                      placeholder: AssetImage(Assets.logo),
                                      image:NetworkImage(Assets.logoUrl),
                                      fit: BoxFit.fitWidth,
                                    ), // Select photo dynamically using index
                                  ),
                                ],
                              ),
                            ]
                            else ... [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 200,
                                    child:FadeInImage(
                                      placeholder: const AssetImage(Assets.logo),
                                      image: NetworkImage(user.photos![0].url!),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      width: 53,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color: AppTheme.n900,
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('From', style: TextStyles.regularPrimary10,),
                                            Text(' ${user.bookingSettings!.basePrice!} '
                                                '${CurrencyHelper.currency(user.userInfo!.address!.country).currencySymbol}',
                                              style: TextStyles.semiBoldPrimary12,),

                                          ],
                                        ),
                                      ),
                                    ),
                                  )

                                ],
                              ),
                            ],
                            SizedBox(
                              height: 100,
                              child: Padding(
                                padding: horizontalPadding24 + verticalPadding12,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.userInfo!.name!, style: TextStyles.boldN90017,),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_pin, size: 10,),
                                        Text(user.userInfo!.address!.city,
                                          softWrap: true, style: TextStyles.regularN90010,),
                                      ],
                                    ),
                                    Expanded(child: Container(),),
                                    Text(user.userArtInfo!.typeOfVenue != null ?
                                    user.userArtInfo!.typeOfVenue!.join(", ") :
                                    '', softWrap: true, style: TextStyles.semiBoldP40010,),
                                    verticalMargin24

                                  ],
                                ),

                              ),
                            )


                          ]
                      ),
                    ),
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
                        builder: (context) => VenueOnboardEndView()),
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