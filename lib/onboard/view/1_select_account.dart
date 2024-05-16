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


  String background = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if( state is LoadingState) {
          return const LoadingScreen();
        }
        return Scaffold(
          body: Padding(
            padding: horizontalPadding48,
            child: Center (
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Create account', style: TextStyles.boldN90029),
                  Text('Do you want to exhibit your art or host exhibitions?', style: TextStyles.regularN90014),
                  verticalMargin48,
                  TextButton(onPressed: null, child: Text('Sign up as artist', style: TextStyles.semiBoldAccent14)),
                  verticalMargin24,
                  TextButton(onPressed: null, child: Text('Sign up as venue', style: TextStyles.semiBoldAccent14)),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            child: Text('Continue', style: TextStyles.boldN90029,)
          ),
        );
        // if (state is UserTypeChosen) {
        //   final userType = state.artb2bUserEntityInfo.userType;
        //   if (userType == UserType.artist) {
        //     background = 'assets/images/artist.png';
        //   }
        //   else if (userType == UserType.gallery) {
        //     background = 'assets/images/gallery.png';
        //   }
        // }
        // return BlocListener<PersonalInfoCubit, PersonalInfoState>(
        //   listener: (context, state) {
        //     if (state is ErrorState) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //           content: Text(state.errorMessage, style: TextStyles.semiBoldAccent14),
        //         ),
        //       );
        //     }
        //   },
        //   child: _buildContent(context, state),
        // );
      },
    );
  }


  // Widget _buildContent(BuildContext context, PersonalInfoState state) {
  //   if (state is DataSaved) {
  //     return HomePage();
  //   }
  //
  //   return Scaffold(
  //       resizeToAvoidBottomInset: true,
  //       appBar: AppBar(
  //         title: Text("About you 1/2", style: TextStyles.boldAccent24,),
  //         centerTitle: true,
  //       ),
  //       body: SingleChildScrollView(
  //         child: Padding(
  //             padding: horizontalPadding24,
  //             child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children:  [
  //                   SizedBox(height: 100, width: 100,
  //                       child: background.toString().length > 2 ? Container(
  //                         decoration: BoxDecoration(
  //                           image: DecorationImage(
  //                               image: AssetImage(background)
  //                           ),
  //                         ),
  //                       ) : Container()
  //                   ),
  //                   verticalMargin48,
  //                   Center(child: Text('Are you an artist or a host', style:TextStyles.semiBoldAccent14,),),
  //                   Text('', style: TextStyles.semiBoldAccent14),
  //                   verticalMargin8,
  //                   const _UserTypeDropdownButton(),
  //                   verticalMargin24,
  //                   Center(child: Text('Artist or Host name', style:TextStyles.semiBoldAccent14,),),
  //                   _UserNameTextField((nameValue) => {
  //                     context.read<PersonalInfoCubit>().chooseName(nameValue),
  //                   }),
  //                   verticalMargin24,
  //                   Center(child: Text('Your location', style:TextStyles.semiBoldAccent14,),),
  //                   const _LocationTextField(),
  //                 ]
  //             )
  //         ),
  //       ),
  //       bottomNavigationBar: Container(
  //           padding: buttonPadding,
  //           child: ElevatedButton(
  //             onPressed: () {
  //               context.read<PersonalInfoCubit>().save();
  //             },
  //             child: Text("Continue", style: TextStyles.semiBoldAccent14,),)
  //       )
  //   );
  // }
}


