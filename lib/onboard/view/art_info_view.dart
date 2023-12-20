import 'package:artb2b/host/view/host_dashboard_edit_page.dart';
import 'package:artb2b/onboard/cubit/art_info_cubit.dart';
import 'package:artb2b/widgets/app_text_field.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../home/view/home_page.dart';
import '../../utils/common.dart';
import '../../widgets/app_input_validators.dart';
import '../../widgets/loading_screen.dart';
import '../cubit/art_info_state.dart';

class ArtInfoView extends StatelessWidget {
  ArtInfoView({Key? key}) : super(key: key);


  String background = "";
  final List<String> _hostTags = ['Arty', 'Commercial', 'Live music', 'Coffee shop'];
  final List<String> _artistTags = ['Arty', 'Commercial', 'Indie', 'Abstract'];

  @override
  Widget build(BuildContext context) {
    User? user;

    return BlocBuilder<ArtInfoCubit, ArtInfoState>(
      builder: (context, state) {

        if( state is LoadingState) {
          return const LoadingScreen();
        }
        if(state is DataSaved) {
          if(state.user.userInfo!.userType == UserType.artist){
            return HomePage();
          }
          else {
            return HostDashboardEditPage();
          }
        }

        return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text("About you 2/2", style: TextStyles.boldAccent24,),
              centerTitle: true,
            ),
            body: BlocListener<ArtInfoCubit, ArtInfoState>(
              listener: (context, state) {
                if (state is ErrorState) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage, style: TextStyles.semiBoldAccent18),
                        ),
                      );
                }
              },
              child: _buildContent(context, state),
            ),
            bottomNavigationBar: Container(
                padding: buttonPadding,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ArtInfoCubit>().save(_hostTags);
                  },
                  child: Text("Continue", style: TextStyles.boldWhite16,),)
            )
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ArtInfoState state){
    User? user = state.props[0] as User;
    // if (state is LoadedState) {
    //   user = state.user;

      if(user.userInfo!.userType == UserType.artist) {
        return  SingleChildScrollView(
          child: Padding(
              padding: horizontalPadding24,
              child: Column(
                children: [
                  Text('About you ', style:TextStyles.semiBoldViolet18,),
                  Text('Tell us in a few words what makes your space unique. ', style:TextStyles.semiBoldViolet14,),
                  _AboutYouTextField((nameValue) => context.read<ArtInfoCubit>().choseAboutYou(nameValue),),
                  verticalMargin24,
                  ChipTags(
                    list: _hostTags,
                    chipColor: AppTheme.secondaryColourRed,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    separator: ',',
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.white,
                        hintText: 'Your vibes coma separated',
                        hintStyle: TextStyles.semiBoldViolet16,
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: AppTheme.accentColor, width: 1.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: AppTheme.primaryColourViolet, width: 1.0),
                        ),
                        border: const OutlineInputBorder()
                    ), //
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
          ),
        );
      }

      if(user.userInfo!.userType == UserType.gallery) {
        return SingleChildScrollView(
          child: Padding(
              padding: horizontalPadding24,
              child: Column(
                children: [
                  Text('About you ', style:TextStyles.semiBoldViolet18,),
                  Text('Tell us what makes your space unique. ', style:TextStyles.semiBoldViolet14,),
                  _AboutYouTextField((nameValue) => context.read<ArtInfoCubit>().choseAboutYou(nameValue),),
                  verticalMargin24,
                  Column(
                    children: [
                      Text('Available Spaces ', style:TextStyles.semiBoldViolet18,),
                      Text('Every space is counted as 1 meter per 1 meter.', style:TextStyles.semiBoldViolet14,),
                    ],
                  ),
                  _SpacesTextField((nameValue) => context.read<ArtInfoCubit>().chooseSpaces(nameValue),),
                  verticalMargin24,
                  Column(
                    children: [
                      Text('Audience ', style:TextStyles.semiBoldViolet18,),
                      Text('How many people do you think would visit your space per day?', style:TextStyles.semiBoldViolet14,),
                    ],
                  ),
                  _AudienceTextField((nameValue) => context.read<ArtInfoCubit>().chooseAudience(nameValue),),
                  verticalMargin24,
                  ChipTags(
                    list: _hostTags,
                    chipColor: AppTheme.secondaryColourRed,
                    iconColor: AppTheme.white,
                    textColor: AppTheme.white,
                    separator: ',',
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.white,
                        hintText: 'Your vibes coma separated',
                        hintStyle: TextStyles.semiBoldViolet16,
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: AppTheme.accentColor, width: 1.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: AppTheme.primaryColourViolet, width: 1.0),
                        ),
                        border: const OutlineInputBorder()
                    ), //
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
          ),
        );
      }
    // }
    return Container();
  }
}

class _SpacesTextField extends StatefulWidget {
  const _SpacesTextField(this.spacesChanged);
  final ValueChanged<String> spacesChanged;


  @override
  State<_SpacesTextField> createState() => _SpacesTextFieldState(spacesChanged);
}

class _SpacesTextFieldState extends State<_SpacesTextField> {

  late final TextEditingController _spacesController;
  final ValueChanged<String> _spaceChanged;

  _SpacesTextFieldState(this._spaceChanged);

  @override
  void initState() {
    super.initState();
    _spacesController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _spacesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  AppTextField(
      key: const Key('Spaces'),
      controller: _spacesController,
      labelText: '',
      validator: AppInputValidators.required(
          'Spaces required'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      autoCorrect: false,
      onChanged: _spaceChanged,
    );
  }
}

class _AudienceTextField extends StatefulWidget {
  const _AudienceTextField(this.audienceChanged);
  final ValueChanged<String> audienceChanged;


  @override
  State<_AudienceTextField> createState() => _AudienceTextFieldState(audienceChanged);
}

class _AudienceTextFieldState extends State<_AudienceTextField> {

  late final TextEditingController _audienceController;
  final ValueChanged<String> _audienceChanged;

  _AudienceTextFieldState(this._audienceChanged);

  @override
  void initState() {
    super.initState();
    _audienceController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _audienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  AppTextField(
      key: const Key('Spaces'),
      controller: _audienceController,
      labelText: '',
      validator: AppInputValidators.required(
          'Spaces required'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      autoCorrect: false,
      onChanged: _audienceChanged,
    );
  }
}


class _AboutYouTextField extends StatefulWidget {
  const _AboutYouTextField(this.aboutChanged);
  final ValueChanged<String> aboutChanged;


  @override
  State<_AboutYouTextField> createState() => _AboutYouTextFieldState(aboutChanged);
}

class _AboutYouTextFieldState extends State<_AboutYouTextField> {

  late final TextEditingController _aboutController;
  final ValueChanged<String> _aboutChanged;

  _AboutYouTextFieldState(this._aboutChanged);

  @override
  void initState() {
    super.initState();
    _aboutController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  AppTextField(
      key: const Key('Spaces'),
      maxLines: 8,
      maxLength: 200,
      controller: _aboutController,
      labelText: '',
      validator: AppInputValidators.required(
          'Spaces required'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.none,
      autoCorrect: false,
      onChanged: _aboutChanged,
      decoration:  const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none
        ),
        // border: const OutlineInputBorder()
      )
    );
  }
}
