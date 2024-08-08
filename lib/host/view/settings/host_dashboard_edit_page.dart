import 'package:artb2b/home/view/home_page.dart';
import 'package:artb2b/host/cubit/host_cubit.dart';
import 'package:artb2b/host/view/host_dashboard_page.dart';
import 'package:artb2b/utils/currency/currency_helper.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storage_service/storage.dart';

import '../../../app/resources/styles.dart';
import '../../../app/resources/theme.dart';
import '../../../injection.dart';
import '../../../utils/common.dart';
import '../../../widgets/input_text_widget.dart';
import '../../../widgets/loading_screen.dart';
import '../../cubit/host_state.dart';

class HostDashboardEditPage extends StatelessWidget {
  HostDashboardEditPage({super.key});

  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();
  final FirebaseAuthService authService = locator<FirebaseAuthService>();

  User? user;
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

              if (state is LoadedState) {
                user = state.user;
                Locale locale = Locale('en', user!.userInfo!.address!.country);
              }

              return Scaffold(
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  title: Text("Your booking settings", style: TextStyles.boldAccent24,),
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

                          InputTextWidget((nameValue) => context.read<HostCubit>().chooseBasePrice(nameValue),
                              user!.bookingSettings != null && user!.bookingSettings!.basePrice != null ?
                              '${user!.bookingSettings!.basePrice!} '
                                  '${CurrencyHelper.currency(user!.userInfo!.address!.country).currencySymbol} per day' :
                              'Base price per day ${CurrencyHelper.currency(user!.userInfo!.address!.country).currencyName}'),
                          // verticalMargin48,
                          //Year
                          verticalMargin48,

                          InputTextWidget((nameValue) => context.read<HostCubit>().chooseMinSpaces(nameValue),
                              user!.bookingSettings != null && user!.bookingSettings!.minSpaces != null ?
                              'Minimum ${user!.bookingSettings!.minSpaces!} spaces per booking' : 'Minimum number of spaces', TextInputType.number),
                          //Price

                          //Price
                          verticalMargin48,

                          InputTextWidget((nameValue) => context.read<HostCubit>().chhoseMinDays(nameValue),
                              user!.bookingSettings != null && user!.bookingSettings!.minLength != null ?
                              'Minimum ${user!.bookingSettings!.minLength!} days per booking' : 'Minimum number of days', TextInputType.number),
                          //Size
                          verticalMargin24,

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
                      child: Text("Continue", style: TextStyles.semiBoldPrimary14,),)
                )
              );
            }
        )
    );
  }
}
