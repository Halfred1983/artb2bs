import 'package:artb2b/home/view/home_page.dart';
import 'package:artb2b/host/cubit/host_cubit.dart';
import 'package:artb2b/host/view/host_dashboard_page.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storage_service/storage.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/input_text_widget.dart';
import '../../widgets/loading_screen.dart';
import '../cubit/host_state.dart';

class HostPaypalEditPage extends StatelessWidget {
  HostPaypalEditPage({super.key});

  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();
  final FirebaseAuthService authService = locator<FirebaseAuthService>();

  User? user;
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HostCubit>(
        create: (context) => HostCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child:  BlocBuilder<HostCubit, HostState>(
            builder: (context, state) {
              if(state is DataSaved) {
                WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(index: 1)),
                ));
              }

              if (state is LoadingState) {
                return const LoadingScreen();
              }

              errorMessage = '';

              if (state is ErrorState) {
                user = state.user;
                errorMessage = state.message;
              }

              if (state is LoadedState) {
                user = state.user;
              }

              return Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    scrolledUnderElevation: 0,
                    title: Text("Your Paypal settings", style: TextStyles.boldAccent24,),
                  centerTitle: true,
                  iconTheme: const IconThemeData(
                    color: AppTheme.primaryColor, //change your color here
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: horizontalPadding24 + verticalPadding12,
                    child: Form(
                      key: key,
                      child: Column(
                        children: [

                          verticalMargin24,
                          Text('Your paypal account where to receive your payouts. ', style: TextStyles.semiBoldAccent14, ),

                          verticalMargin24,

                          InputTextWidget((nameValue) => context.read<HostCubit>().choosePaypalAccount(nameValue),
                              user!.bookingSettings != null && user!.bookingSettings!.paypalAccount != null ?
                              '${user!.bookingSettings!.paypalAccount}' : 'Add your Paypal Account', TextInputType.emailAddress),
                          verticalMargin12,
                          errorMessage != null ?
                          Text( errorMessage!, style: TextStyles.semiBoldAccent14, ) : Container()
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                    padding: buttonPadding,
                    child: ElevatedButton(
                      onPressed: () async {
                        await context.read<HostCubit>().saveBookingSettings();
                      },
                      child: Text("Continue", style: TextStyles.semiBoldAccent14,),)
                )
              );
            }
        )
    );
  }
}
