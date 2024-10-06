import 'package:artb2b/home/view/home_page.dart';
import 'package:artb2b/home/view/home_view.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../host/view/host_setting_page.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/dot_indicator.dart';
import '../../widgets/dropdown_box.dart';
import '../../widgets/loading_screen.dart';
import '4_a_artist_address.dart';


class ArtistInfoPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => ArtistInfoPage());
  }
  bool isOnboarding;

  ArtistInfoPage({Key? key, this.isOnboarding = true}) : super(key: key);
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: ArtistInfoView(isOnboarding: isOnboarding),
    );
  }
}



class ArtistInfoView extends StatefulWidget {
  ArtistInfoView({Key? key, this.isOnboarding = true}) : super(key: key);

  final bool isOnboarding;

  @override
  State<ArtistInfoView> createState() => _ArtistInfoViewState();
}

class _ArtistInfoViewState extends State<ArtistInfoView> {
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _biotController = TextEditingController();
  String _artStyle = 'Art Style';
  String _bio = '';
  String _artistName = '';
  SharedPreferences prefs = locator.get<SharedPreferences>();

  final List<String> _artStyles = ['Art Style'] + ArtStyle.values.map((style) => style.toString().split('.').last.capitalize()).toList();

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

          if(!widget.isOnboarding) {
            _artistName = user!.artInfo!.artistName!;
            _artistController.text = _artistName;
            _artStyle = user.artInfo!.artStyle.toString().split('.').last.capitalize();
            _biotController.text = user.artInfo!.biography!;
            _bio = _biotController.text;
          }
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: !widget.isOnboarding ? AppBar(
            scrolledUnderElevation: 0,
            title: Text(user!.artInfo!.artistName!, style: TextStyles.boldN90017,),
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
                      const LineIndicator(
                        totalSteps: 3,
                        currentStep: 1,
                      ),
                      verticalMargin24,
                      Text('Create your artist profile',
                          style: TextStyles.boldN90029),
                      verticalMargin48,
                    ],
                    Text('Artist Name', style: TextStyles.boldN90016),
                    verticalMargin8,
                    TextField(
                      controller: _artistController,
                      autofocus: false,
                      style: TextStyles.semiBoldN90014,
                      onChanged: (String value) {
                        _artistName = value;
                        context.read<OnboardingCubit>().chooseArtistName(value);
                      },
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: AppTheme.textInputDecoration.copyWith(hintText: 'Artist name'),
                      keyboardType: TextInputType.text,
                    ),
                    verticalMargin48,
                    Text('Primary art style', style: TextStyles.boldN90016),
                    verticalMargin4,
                    DropdownBox(
                      items:  _artStyles,
                      selectedItem: _artStyle ?? 'Art Style',
                      onChanged: (value) {
                        if(value != null) {
                          _artStyle = value;
                          context.read<OnboardingCubit>().choseArtStyle(_artStyle);
                        }
                      },
                      hintText: 'Select an option',
                    ),
                    verticalMargin48,
                    Text('Biography', style: TextStyles.boldN90016),
                    verticalMargin4,
                    Text('Write a short biography about your artistic\njourney and style.',
                        style: TextStyles.regularN90014),
                    verticalMargin24,
                    TextFormField(
                      controller: _biotController,
                      autofocus: false,
                      style: TextStyles.semiBoldN90014,
                      onChanged: (String value) {
                        _bio = value;
                        context.read<OnboardingCubit>().choseBio(value);
                      },
                      maxLines: 10, // Adjust the number of lines as needed
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: AppTheme.textAreaInputDecoration
                          .copyWith(hintText: 'Tell us about your space. Min 50 characters.',),
                      keyboardType: TextInputType.text,
                    ),
                    verticalMargin24,
                    verticalMargin24
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
                onPressed: () async {
                  if(_canContinue()) {

                    if(widget.isOnboarding) {
                      context.read<OnboardingCubit>().save(user!, UserStatus.artInfo);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ArtistAddressPage()), // Replace NewPage with the actual class of your new page
                      );
                    }
                    else {
                      await context.read<OnboardingCubit>().save(user!);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(index: 2,)), // Replace NewPage with the actual class of your new page
                      );
                    }

                  }
                  else {
                    return;
                  }
                },
                child: Text(widget.isOnboarding ? 'Continue' : 'Save',)
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
        );
      },
    );
  }

  bool _canContinue() {
    return _artistName.isNotEmpty
        && _bio.isNotEmpty
        && _artStyle.isNotEmpty && _artStyle != 'Art Style';
  }
}
