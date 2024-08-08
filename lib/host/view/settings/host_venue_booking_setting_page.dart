import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/resources/styles.dart';
import '../../../app/resources/theme.dart';
import '../../../injection.dart';
import '../../../utils/common.dart';
import '../../../utils/currency/currency_helper.dart';
import '../../../widgets/loading_screen.dart';
import '../host_setting_page.dart';



class HostBookingSettingsPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => HostBookingSettingsPage());
  }

  HostBookingSettingsPage({Key? key}) : super(key: key);
  final authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: HostBookingSettingsView(),
    );
  }
}



class HostBookingSettingsView extends StatefulWidget {
  HostBookingSettingsView({Key? key}) : super(key: key);

  @override
  State<HostBookingSettingsView> createState() => _HostBookingSettingsViewState();
}

class _HostBookingSettingsViewState extends State<HostBookingSettingsView> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _spacesController = TextEditingController();
  String _price = '0';
  String _minDays = '0';
  String _minSpaces = '0';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }
        User? user;
        if(state is LoadedState || state is DataSaved) {
          user = state.user;

          _price = user!.bookingSettings!.basePrice ?? '0';
          _minDays = user.bookingSettings!.minLength ?? '0';
          _minDays = user.bookingSettings!.minSpaces ?? '0';

          _priceController.text = _price;
          _daysController.text = _minDays;
          _spacesController.text = _minDays;
        }
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text(user!.userInfo!.name!, style: TextStyles.boldN90017,),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: AppTheme.n900, //change your color here
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: horizontalPadding32,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    verticalMargin48,
                    Text('What is your rate per space per day.',
                        style: TextStyles.boldN90017),
                    verticalMargin24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(CurrencyHelper.currency(user!.userInfo!.address!.country).currencySymbol,
                          style: TextStyles.boldN90020, ),
                        horizontalMargin12,
                        SizedBox(
                          height: 50,
                          width: 108,
                          child: TextField(
                            controller: _priceController,
                            autofocus: false,
                            style: TextStyles.boldN90029,
                            onChanged: (String value) {
                              if(value.isEmpty) {
                                _price = '0';
                              }
                              else {
                                _price = value;
                              }
                              context.read<OnboardingCubit>().chooseBasePrice(value);
                            },
                            autocorrect: false,
                            enableSuggestions: false,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: AppTheme.numericPriceStyle,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    verticalMargin48,
                    Text('How many spaces minimum per booking?',
                        style: TextStyles.boldN90017),
                    verticalMargin24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(' spaces',
                          style: TextStyles.boldN90020, ),
                        horizontalMargin12,
                        SizedBox(
                          height: 50,
                          width: 108,
                          child: TextField(
                            controller: _spacesController,
                            autofocus: false,
                            style: TextStyles.boldN90029,
                            onChanged: (String value) {
                              if(value.isEmpty) {
                                _minSpaces = '0';
                              }
                              else {
                                _minSpaces = value;
                              }
                              context.read<OnboardingCubit>().chooseMinSpaces(value);
                            },
                            autocorrect: false,
                            enableSuggestions: false,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: AppTheme.numericPriceStyle,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    verticalMargin48,
                    Text('How many days minimum per booking?',
                        style: TextStyles.boldN90017),
                    verticalMargin24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(' days',
                          style: TextStyles.boldN90020, ),
                        horizontalMargin12,
                        SizedBox(
                          height: 50,
                          width: 108,
                          child: TextField(
                            controller: _daysController,
                            autofocus: false,
                            style: TextStyles.boldN90029,
                            onChanged: (String value) {
                              if(value.isEmpty) {
                                _minDays = '0';
                              }
                              else {
                                _minDays = value;
                              }
                              context.read<OnboardingCubit>().chooseMinDays(value);
                            },
                            autocorrect: false,
                            enableSuggestions: false,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: AppTheme.numericPriceStyle,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
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
                backgroundColor:  _canContinue(user.userArtInfo!.spaces) ? AppTheme.n900 : AppTheme.disabledButton,
                foregroundColor: _canContinue(user.userArtInfo!.spaces) ? AppTheme.primaryColor : AppTheme.n900,
                onPressed: () {
                  if(_canContinue(user!.userArtInfo!.spaces)) {
                    context.read<OnboardingCubit>().save(user!);
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HostSettingPage()),
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

  bool _canContinue(String? hostMaxSpaces) {
    hostMaxSpaces = hostMaxSpaces ?? '0';
    return  int.parse(_price) > 0 && int.parse(_minDays) > 0
        && int.parse(_minSpaces) > 0 && int.parse(_minSpaces) < int.parse(hostMaxSpaces);
  }
}

class PlusMinusButton extends StatelessWidget {
  const PlusMinusButton({
    super.key, required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: Colors.transparent, // Circle color
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.accentColor, width: 3),
      ),
      child: Align(
          alignment: Alignment.center,
          child: Icon(
            text == '+' ? Icons.add : Icons.remove,
            color: AppTheme.accentColor,
            size: 30,
          )
      ),
    );
  }
}

class InactiveTextField extends StatelessWidget {
  const InactiveTextField({
    super.key, required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      enabled: false,
      style: TextStyles.semiBoldN90014,
      autocorrect: false,
      enableSuggestions: false,
      decoration: AppTheme.textInputDecoration.copyWith(hintText: label,
          fillColor: AppTheme.disabledButton),
      keyboardType: TextInputType.text,
    );
  }
}
