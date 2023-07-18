import 'package:artb2b/personal_info/cubit/art_info_cubit.dart';
import 'package:artb2b/widgets/app_text_field.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';

import '../../app/resources/styles.dart';
import '../../utils/common.dart';
import '../../widgets/app_input_validators.dart';
import '../../widgets/loading_screen.dart';
import '../cubit/art_info_state.dart';

class ArtInfoView extends StatelessWidget {
  ArtInfoView({Key? key}) : super(key: key);


  String background = "";
  List<String> _myListCustom = ['Arty', 'Commercial', 'Live music', 'Coffee shop'];
  @override
  Widget build(BuildContext context) {
    User? user;

    return BlocBuilder<ArtInfoCubit, ArtInfoState>(
      builder: (context, state) {

        if( state is LoadingState) {
          return const LoadingScreen();
        }
        if (state is LoadedState) {
          user = state.user;

          if(user!.userInfo!.userType == UserType.artist) {
            return Scaffold(
              appBar: AppBar(
                title: Text("About you 2/2", style: TextStyles.boldAccent24,),
                centerTitle: true,
              ),
              body: Container()
            );
          }
          if(user!.userInfo!.userType == UserType.gallery) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("About you 2/2", style: TextStyles.boldAccent24,),
                  centerTitle: true,
                ),
                body: Column(
                  children: [

                    verticalMargin48, Center(child: Text('Capacity of your venue', style:TextStyles.semiBoldViolet21,),),
                    _CapacityTextField((nameValue) => context.read<ArtInfoCubit>().chooseCapacity(nameValue),),
                    verticalMargin48,
                    Center(child: Text('Spaces to host (1 square meter each)', style:TextStyles.semiBoldViolet21,),),
                    _SpacesTextField((nameValue) => context.read<ArtInfoCubit>().chooseSpaces(nameValue),),
                    verticalMargin48,
                    Center(child: Text('Vibes', style:TextStyles.semiBoldViolet21,),),
                    ChipTags(
                      list: _myListCustom,
                      chipColor: Colors.black,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      decoration: InputDecoration(hintText: "Your Custom Hint"),
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
                bottomNavigationBar: Container(
                padding: buttonPadding,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ArtInfoCubit>().save();
                  },
                  child: Text("Continue", style: TextStyles.regularWhite16,),)
            )
            );
          }
        }
        return Container();
      },
    );
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
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      autoCorrect: false,
      onChanged: _spaceChanged,
    );
  }
}
class _CapacityTextField extends StatefulWidget {
  const _CapacityTextField(this.capacityChanged);
  final ValueChanged<String> capacityChanged;


  @override
  State<_SpacesTextField> createState() => _SpacesTextFieldState(capacityChanged);
}

class _CapacityTextFieldState extends State<_CapacityTextField> {

  late final TextEditingController _capacityController;
  final ValueChanged<String> _capacityChanged;

  _CapacityTextFieldState(this._capacityChanged);

  @override
  void initState() {
    super.initState();
    _capacityController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  AppTextField(
      key: const Key('Spaces'),
      controller: _capacityController,
      labelText: '',
      validator: AppInputValidators.required(
          'Spaces required'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      autoCorrect: false,
      onChanged: _capacityChanged,
    );
  }
}
