import 'dart:io';

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

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../utils/common.dart';
import '../../widgets/app_input_validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/loading_screen.dart';
import '../cubit/photo_cubit.dart';
import '../cubit/photo_state.dart';

class PhotoUploadView extends StatefulWidget {
  const PhotoUploadView({Key? key}) : super(key: key);

  @override
  State<PhotoUploadView> createState() => _PhotoUploadViewState();
}

class _PhotoUploadViewState extends State<PhotoUploadView> {

  GlobalKey<FormState> key = GlobalKey();
  File? _imageFile;
  String? _downloadUrl;

  String imageUrl = '';
  User? user;
  double _progress = 0;

  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoCubit, PhotoState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }
        if (state is PhotoUploadedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) =>
              _showAlertDialog(state.photo.description!));
        }
        if (state is LoadedState) {
          user = state.user;
        }

        return Scaffold(
            appBar: AppBar(
              title: Text("Add a photo", style: TextStyles.boldAccent24,),
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: AppTheme.primaryColourViolet, //change your color here
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: horizontalPadding24 + verticalPadding12,
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      _imageFile == null ? InkWell(
                        onTap: () async {
                          _getFromGallery();
                        },
                        child: DottedBorder(
                            color: AppTheme.primaryColourViolet,
                            strokeWidth: 4,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [
                              8,
                              10,
                            ],
                            child: SizedBox(
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Choose from gallery',
                                    style: TextStyles.semiBoldViolet16,),
                                  horizontalMargin16,
                                  const Icon(FontAwesomeIcons.image,
                                      color: AppTheme.primaryColourViolet),
                                ],
                              ),

                            )
                        ),
                      ) : Container(),
                      verticalMargin12,
                      _imageFile != null ?

                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(
                                  _imageFile!,),
                                fit: BoxFit.cover
                            ),
                            borderRadius: const BorderRadius.all(Radius
                                .circular(20))
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: AppTheme.white,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _imageFile = null;
                                });
                              },
                              icon: const Icon(FontAwesomeIcons.xmark,
                                  color: AppTheme.primaryColourViolet),
                            ),
                          ),
                        ),
                      ) : Container(),

                      verticalMargin24,

                      _InputTextField((description) =>
                          context.read<PhotoCubit>().chooseDescription(description),
                          'What is the photo of?'),
                      // verticalMargin48,
                      //Year
                      verticalMargin24,

                      verticalMargin16,
                      _progress > 0 ?
                      Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10)),
                              child: LinearProgressIndicator(
                                backgroundColor: AppTheme.accentColor,
                                color: AppTheme.primaryColourViolet,
                                minHeight: 50,
                                value: _progress,
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Center(
                                  child: Text('$_progress%',
                                    style: TextStyles.boldWhite16,),
                                ),
                              ),
                            ),
                          ])
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
                padding: buttonPadding,
                child: ElevatedButton(
                  onPressed: () {
                    final uploadTask = context.read<PhotoCubit>()
                        .storePhoto(
                        user!.id + '/photos/' + path.basename(_imageFile!.path),
                        _imageFile);

                    // Listen for state changes, errors, and completion of the upload.
                    uploadTask.snapshotEvents.listen((
                        TaskSnapshot taskSnapshot) async {
                      switch (taskSnapshot.state) {
                        case TaskState.running:
                          _progress =
                              100.0 * (taskSnapshot.bytesTransferred /
                                  taskSnapshot.totalBytes);
                          if (context.mounted) {
                            setState(() {

                            });
                          }
                          print("Upload is $_progress% complete.");
                          break;
                        case TaskState.paused:
                          print("Upload is paused.");
                          break;
                        case TaskState.canceled:
                          print("Upload was canceled");
                          break;
                        case TaskState.error:
                        // Handle unsuccessful uploads
                          break;
                        case TaskState.success:
                          _downloadUrl =
                          await taskSnapshot.ref.getDownloadURL();
                          if (context.mounted) {
                            context.read<PhotoCubit>().savePhoto(
                                _downloadUrl!, user!);
                          }
                          break;
                      }
                    });
                  },
                  child: Text("Upload", style: TextStyles.boldWhite16,),)
            )
        );
      },
    );
  }


  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }


  Future<void> _showAlertDialog(String name) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog( // <-- SEE HERE
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: const Center(child: Text('Upload Successful')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Your photo:\n\n',
                      style: TextStyles.regularAccent16,
                      children: <TextSpan>[
                        TextSpan(text: name,
                          style: TextStyles.boldViolet16,
                        ),
                        TextSpan(text: '\n\nwas uploaded successfully!',
                          style: TextStyles.regularAccent16,
                        )
                      ]
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyles.semiBoldViolet21.copyWith(
                  decoration: TextDecoration.underline
              ),),
              onPressed: () {
                Navigator.of(context)
                  ..pop()..pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _InputTextField extends StatefulWidget {
  const _InputTextField(this.nameChanged, this.hint, [this.textInputType]);
  final ValueChanged<String> nameChanged;
  final String hint;
  final TextInputType? textInputType;


  @override
  State<_InputTextField> createState() =>
      _InputTextFieldState(nameChanged, hint, textInputType);
}

class _InputTextFieldState extends State<_InputTextField> {

  late final TextEditingController _nameController;
  final ValueChanged<String> _nameChanged;
  final String _hint;
  final TextInputType? _textInputType;

  _InputTextFieldState(this._nameChanged, this._hint, this._textInputType);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  AppTextField(
      key: const Key('Spaces'),
      controller: _nameController,
      hintText: _hint,
      validator: AppInputValidators.required(
          'Name required'),
      textInputAction: TextInputAction.next,
      keyboardType: _textInputType ?? TextInputType.text,
      textCapitalization: TextCapitalization.words,
      autoCorrect: false,
      onChanged: _nameChanged,
    );
  }
}