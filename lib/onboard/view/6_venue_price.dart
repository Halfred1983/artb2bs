import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:artb2b/widgets/google_places.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../utils/currency/currency_helper.dart';
import '../../widgets/dot_indicator.dart';
import '../../widgets/loading_screen.dart';
import '7_venue_photo.dart';


class VenuePricePage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => VenuePricePage());
  }

  VenuePricePage({Key? key}) : super(key: key);
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: SelectPriceView(),
    );
  }
}



class SelectPriceView extends StatefulWidget {
  SelectPriceView({Key? key}) : super(key: key);

  @override
  State<SelectPriceView> createState() => _SelectPriceViewState();
}

class _SelectPriceViewState extends State<SelectPriceView> {
  final TextEditingController _priceController = TextEditingController();
  String _price = '0';


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }
        User? user;
        if(state is LoadedState) {
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
                      currentStep: 4,
                    ),
                    verticalMargin24,
                    Text('Now, set up your rate per space',
                        style: TextStyles.boldN90029),
                    verticalMargin48,
                    Text('This will be your rate per space per day.',
                        style: TextStyles.boldN90017),
                    verticalMargin48,
                    verticalMargin48,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        user != null ? Text('${CurrencyHelper.currency(user!.userInfo!.address!.country).currencySymbol}',
                          style: TextStyles.boldN90029, ) : const Text(''),
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
                              context.read<OnboardingCubit>().chooseBasePrice(_price);
                            },
                            autocorrect: false,
                            enableSuggestions: false,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: AppTheme.numericPriceStyle,
                          ),
                        ),
                      ],
                    ),
                    verticalMargin48,
                    Container(
                      padding: const EdgeInsets.fromLTRB(21, 15, 21, 15),
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppTheme.s50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'You can change this whenever you'
                            ' want from your listing settings.',
                        style: TextStyles.regularN90014,
                      ),
                    )
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
                  if(_canContinue()) {
                    context.read<OnboardingCubit>().save(user!, UserStatus.priceInfo);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VenuePhotoPage()), // Replace NewPage with the actual class of your new page
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

  bool _canContinue() {
    return  int.parse(_price) > 0;
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
