import 'dart:io';

import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:storage_service/storage.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../onboard/view/9_venue_audience.dart';
import '../../utils/common.dart';
import '../../utils/currency/currency_helper.dart';
import '../../widgets/loading_screen.dart';
import '../cubit/photo_cubit.dart';
import '../cubit/photo_state.dart';
import 'artwork_upload_page.dart';

class NewCollectionPage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => NewCollectionPage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();
  final FirestoreStorageService storageService = locator<FirestoreStorageService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<PhotoCubit>(
        create: (context) => PhotoCubit(
          databaseService: databaseService,
          storageService: storageService,
          userId: authService.getUser().id,
        ),
        child: const NewCollectionView(),
      );
  }
}



class NewCollectionView extends StatefulWidget {
  const NewCollectionView({Key? key}) : super(key: key);

  @override
  State<NewCollectionView> createState() => _NewCollectionViewState();
}

class _NewCollectionViewState extends State<NewCollectionView> {

  String _collectionName = '';
  String _collectionDescription = '';
  String _errorMessage = '';
  final TextEditingController _collectionNameController = TextEditingController();
  final TextEditingController _projectVibesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoCubit, PhotoState>(
      builder: (context, state) {

        if( state is LoadingState) {
          return const LoadingScreen();
        }

        User? user;
        if (state is LoadedState || state is ErrorState || state is DataSaved) {
          user = state.props[0] as User;
          if(state is ErrorState) {
            _errorMessage = state.errorMessage;
          }
        }

        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text("Create new collection", style: TextStyles.boldN90017,),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: AppTheme.n900, //change your color here
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: horizontalPadding24 + verticalPadding12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Collection Name', style: TextStyles.boldN90016),
                    verticalMargin8,
                    TextField(
                      controller: _collectionNameController,
                      autofocus: false,
                      style: TextStyles.semiBoldN90014,
                      onChanged: (String value) {
                        _collectionName = value;
                        _errorMessage = '';
                        context.read<PhotoCubit>().choseCollectionName(_collectionName);
                      },
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: AppTheme.textInputDecoration.copyWith(hintText: 'Collection name'),
                      keyboardType: TextInputType.text,
                    ),
                    verticalMargin8,
                    Text(_errorMessage, style: TextStyles.semiBoldN90012.copyWith(color: AppTheme.d200)),
                    verticalMargin24,
                    Text('Project Vibes', style: TextStyles.boldN90016),
                    verticalMargin12,
                    Text('We\'d love to get a glimpse into your art project vibes or style. '
                        'Share a brief description with us to let your creativity shine!',
                        style: TextStyles.semiBoldN90014),
                    verticalMargin12,
                    TextFormField(
                      controller: _projectVibesController,
                      autofocus: false,
                      style: TextStyles.semiBoldN90014,
                      onChanged: (String value) {
                        setState(() {
                          _collectionDescription = value;
                        });
                        // context.read<PhotoCubit>().choseCollectionDescription(_collectionDescription);
                      },
                      maxLines: 10, // Adjust the number of lines as needed
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: AppTheme.textAreaInputDecoration
                          .copyWith(hintText: 'Collection description',),
                      keyboardType: TextInputType.text,
                    ),
                  ],
                )
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
                    // if (widget.isOnboarding) {
                    Collection collection = Collection(name: _collectionName,
                        collectionVibes: _collectionDescription);
                    user = user!.copyWith(
                      artInfo: user!.artInfo!.copyWith(
                        collections: List.from(user!.artInfo!.collections)..add(collection),
                      ),
                    );
                    context.read<PhotoCubit>().save(user!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtworkUploadPage(collectionId: _collectionName),
                      ),
                    );
                    // }
                    // else {
                    //   context.read<OnboardingCubit>().save(user!);
                    //   Navigator.of(context)..pop()..pop();
                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => HostSettingPage()),
                    //   );
                    // }
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
    return _collectionName.isNotEmpty && _collectionDescription.isNotEmpty;
  }
}
