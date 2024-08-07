import 'package:artb2b/host/view/host_setting_page.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:artb2b/widgets/google_places.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/loading_screen.dart';
import '6_venue_price.dart';


class VenueSpacesPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => VenueSpacesPage());
  }
  bool isOnboarding;
  VenueSpacesPage({Key? key, this.isOnboarding = true}) : super(key: key);

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: SelectSpacesView(isOnboarding: isOnboarding),
    );
  }
}



class SelectSpacesView extends StatefulWidget {
  SelectSpacesView({Key? key, this.isOnboarding = true}) : super(key: key);

  final bool isOnboarding;

  @override
  State<SelectSpacesView> createState() => _SelectSpacesViewState();
}

class _SelectSpacesViewState extends State<SelectSpacesView> {
  int _spaceValue = 1;

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
          _spaceValue = int.parse(user!.userArtInfo!.spaces!);
        }
        return Scaffold(
          appBar: !widget.isOnboarding ? AppBar(
            scrolledUnderElevation: 0,
            title: Text(user!.userInfo!.name!, style: TextStyles.boldN90017,),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: AppTheme.n900, //change your color here
            ),
          ) : null,
          body: SingleChildScrollView(
            child: Padding(
              padding: horizontalPadding32 + (widget.isOnboarding ? verticalPadding48 : EdgeInsets.zero),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(widget.isOnboarding)... [
                      verticalMargin48,
                      Text('Spaces in your\nvenue',
                          style: TextStyles.boldN90029),
                      verticalMargin48,
                    ],
                    Text('How many spaces available?',
                        style: TextStyles.boldN90017),
                    verticalMargin12,
                    Text('Each space dimension must be 100cm x 100cm and have at least a 70cm gap between spaces.',
                        style: TextStyles.regularN90014),
                    verticalMargin48,
                    verticalMargin48,
                    Row(
                      children: [
                        Expanded(child: Container(),),
                        SizedBox(
                          width: 200,
                          child: InputQty.int(
                            onQtyChanged: (spaceValue) {
                              _spaceValue = spaceValue;
                              context.read<OnboardingCubit>().chooseSpaces(spaceValue.toString());
                            },
                            qtyFormProps: QtyFormProps(enableTyping: false, style: TextStyles.boldN90029),
                            steps: 1,
                            maxVal: 999 ,
                            minVal: 1,
                            initVal: _spaceValue,
                            decoration: AppTheme.quantityProps,
                          ),
                        ),
                        Expanded(child: Container(),),
                      ],
                    ),
                    verticalMargin48,
                    verticalMargin48,
                    if(widget.isOnboarding)Container(
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

                    if (widget.isOnboarding) {
                      context.read<OnboardingCubit>().save(user!, UserStatus.spaceInfo);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            VenuePricePage()), // Replace NewPage with the actual class of your new page
                      );
                    }
                    else {
                      context.read<OnboardingCubit>().save(user!);
                      Navigator.of(context)..pop()..pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HostSettingPage()),
                      );
                    }
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
    return true;
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
