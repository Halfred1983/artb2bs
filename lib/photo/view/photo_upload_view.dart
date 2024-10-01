import 'dart:io';

import 'package:artb2b/onboard/view/7_venue_photo.dart';
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
import '../../widgets/custom_dialog.dart';
import '../../widgets/loading_screen.dart';
import '../cubit/photo_cubit.dart';
import '../cubit/photo_state.dart';

class PhotoUploadView extends StatefulWidget {
  final bool isOnboarding;

  const PhotoUploadView({Key? key, this.isOnboarding = false}) : super(key: key);

  @override
  State<PhotoUploadView> createState() => _PhotoUploadViewState();
}

class _PhotoUploadViewState extends State<PhotoUploadView> {
  final TextEditingController _photoDescriptionController = TextEditingController();

  String _photoDescription = '';

  GlobalKey<FormState> key = GlobalKey();
  File? _imageFile;
  String? _downloadUrl;

  String imageUrl = '';
  User? user;
  double _progress = 0;


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
              scrolledUnderElevation: 0,
              title: Text("Add a photo", style: TextStyles.boldN90017,),
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: AppTheme.n900, //change your color here
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
                            color: AppTheme.divider,
                            strokeWidth: 2,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [
                              6,
                              6,
                            ],
                            child: SizedBox(
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Choose from gallery',
                                    style: TextStyles.semiBoldN20014,),
                                  horizontalMargin16,
                                  const Icon(FontAwesomeIcons.image,
                                      color: AppTheme.n200),
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
                                .circular(12))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, right: 15),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: AppTheme.n900,
                              child: Center(

                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _imageFile = null;
                                    });
                                  },
                                  child: const Icon(FontAwesomeIcons.trash,
                                    color: AppTheme.white, size: 20,),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ) : Container(),

                      verticalMargin24,
                      Text('Photo description', style: TextStyles.boldN90016),
                      verticalMargin8,
                      TextField(
                        controller: _photoDescriptionController,
                        autofocus: false,
                        style: TextStyles.semiBoldN90014,
                        onChanged: (String value) {
                          _photoDescription = value;
                        },
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: AppTheme.textInputDecoration.copyWith(hintText: 'What is the photo about?',),
                        keyboardType: TextInputType.text,
                      ),
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
                                color: AppTheme.primaryColor,
                                minHeight: 50,
                                value: _progress,
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Center(
                                  child: Text('${_progress.round()}%',
                                    style: TextStyles.semiBoldN90017,),
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
                    onPressed: _imageFile != null ? ()  {
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
                              Photo photo = Photo(
                                  url: _downloadUrl!,
                                  description: _photoDescription);
                              context.read<PhotoCubit>().savePhoto(photo,
                                  _downloadUrl!, user!);
                            }
                            break;
                        }
                      });
                    } : null,
                    child: const Text('Upload',)
                )
            )
        );
      },
    );
  }


  /// Get from gallery
  _getFromGallery() async {
    try {
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
    catch (e) {
      if (mounted) {
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return CustomAlertDialog( // <-- SEE HERE
                content: 'Chose a valid photo.',
                title: 'Upload Failed',
                actions: <Widget>[
                  TextButton(
                    child: Text('OK', style: TextStyles.semiBoldAccent14.copyWith(
                        decoration: TextDecoration.underline
                    ),),
                    onPressed: () {
                      Navigator.of(context)
                          .pop();
                    },
                  ),
                ],
                type: AlertType.error,
              );
            });
      }
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
        return CustomAlertDialog( // <-- SEE HERE
          content: 'Your photo:\n\n$name\n\nwas uploaded successfully!',
          title: 'Upload Successful',
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('OK', style: TextStyles.semiBoldAccent14.copyWith(
                    decoration: TextDecoration.underline
                ),),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VenuePhotoPage(isOnboarding: widget.isOnboarding,)), // Replace NewPage with the actual class of your new page
                  );
                },
              ),
            ),
          ], type: AlertType.success,
        );
      },
    );
  }
}
