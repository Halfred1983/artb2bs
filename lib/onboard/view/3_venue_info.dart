import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:artb2b/onboard/view/4_venue_address.dart';
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


class VenueInfoPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => VenueInfoPage());
  }

  VenueInfoPage({Key? key}) : super(key: key);
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: SelectAccountView(),
    );
  }
}



class SelectAccountView extends StatefulWidget {
  SelectAccountView({Key? key}) : super(key: key);

  @override
  State<SelectAccountView> createState() => _SelectAccountViewState();
}

class _SelectAccountViewState extends State<SelectAccountView> {
  final TextEditingController _venueController = TextEditingController();
  List<String> _venueType = [];
  List<String> _vibes = [];
  String _venueName = '';



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
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
                    Text('Let\'s get started with few easy steps',
                        style: TextStyles.boldN90029),
                    verticalMargin48,
                    Text('Venue Name', style: TextStyles.boldN90016),
                    verticalMargin8,
                    TextField(
                      controller: _venueController,
                      autofocus: false,
                      style: TextStyles.semiBoldN90014,
                      onChanged: (String value) {
                        _venueName = value;
                        context.read<OnboardingCubit>().chooseName(value);
                      },
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: AppTheme.textInputDecoration,
                      keyboardType: TextInputType.text,
                    ),
                    verticalMargin48,
                    Text('Type of venue', style: TextStyles.boldN90016),
                    verticalMargin4,
                    Tags(const [
                      'Restaurant', 'Bar', 'Coffee', 'Live music', 'Library',
                      'Hotel', 'Lounge', 'Art centre', 'Gallery',
                    ],
                      _venueType,
                          (venueType) {
                        setState(() {
                          _venueType = venueType;
                        });
                        context.read<OnboardingCubit>().choseVenueType(venueType);
                      },
                    ),
                    verticalMargin48,
                    Text('Vibes', style: TextStyles.boldN90016),
                    verticalMargin4,
                    Tags(const [
                      'Arty', 'Indie', 'Party', 'Quiet',
                      'Busy', 'Loud', 'Quirky', 'Chill',
                    ],
                      _vibes,
                          (vibes) {
                        setState(() {
                          _vibes = vibes;
                        });
                        context.read<OnboardingCubit>().choseVibes(_vibes);
                      },
                    ),
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
                  _canContinue() ?
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VenueAddressPage()), // Replace NewPage with the actual class of your new page
                  ) : null;
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
    return _venueName.isNotEmpty && _venueType.isNotEmpty && _vibes.isNotEmpty;
  }
}
