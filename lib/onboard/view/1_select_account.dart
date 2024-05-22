import 'package:artb2b/home/view/home_page.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:artb2b/widgets/app_dropdown.dart';
import 'package:artb2b/widgets/app_text_field.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/app_input_validators.dart';
import '../../widgets/google_places.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/scollable_chips.dart';
import '../../widgets/tags.dart';
import '2_info_account.dart';


class SelectAccountPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => SelectAccountPage());
  }

  SelectAccountPage({Key? key}) : super(key: key);
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



class SelectAccountView extends StatelessWidget {
  SelectAccountView({Key? key}) : super(key: key);


  UserType _userType = UserType.unknown;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        User? user;
        if( state is LoadingState) {
          return const LoadingScreen();
        }
        if(state is LoadedState) {
          user = state.user;
          _userType = user.userInfo != null ? user.userInfo!.userType! : UserType.unknown;
        }
        if(state is UserTypeChosen) {
          _userType = state.user.userInfo!.userType!;
        }

        return Scaffold(
          body: Padding(
            padding: horizontalPadding48,
            child: Center (
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Create account', style: TextStyles.boldN90029),
                  Text('Do you want to exhibit your art or host exhibitions?', textAlign: TextAlign.center,
                      style: TextStyles.regularN90014),
                  verticalMargin48,
                  SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.n900,
                            backgroundColor: _userType == UserType.artist ? AppTheme.primaryColor : Colors.white,
                            side: BorderSide(color: _userType == UserType.artist ? AppTheme.primaryColor : AppTheme.accentColor, width: 2), // Border color and width

                            // onSurface: Colors.grey,
                            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          onPressed: () => context.read<OnboardingCubit>().chooseUserType(UserType.artist),
                          child: Text('Sign up as artist',))
                  ),
                  verticalMargin24,
                  SizedBox(
                      width: double.infinity,
                      child : TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:  AppTheme.n900,
                            backgroundColor: _userType == UserType.gallery ? AppTheme.primaryColor : Colors.white,
                            side: BorderSide(color: _userType == UserType.gallery ? AppTheme.primaryColor : AppTheme.accentColor, width: 2), // Border color and width

                            // onSurface: Colors.grey,
                            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          onPressed: () => context.read<OnboardingCubit>().chooseUserType(UserType.gallery),
                          child: Text('Sign up as venue'))
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Container(
            padding: horizontalPadding32,
            width: double.infinity,
            child: FloatingActionButton(
              backgroundColor: _userType != UserType.unknown ? AppTheme.n900 : AppTheme.disabledButton,
              foregroundColor: _userType != UserType.unknown ? AppTheme.primaryColor : AppTheme.n900,
                onPressed: () {
                  _userType != UserType.unknown ? Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoAccountPage()), // Replace NewPage with the actual class of your new page
                  ) : null;
                },
                child: const Text('Continue',)
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}


