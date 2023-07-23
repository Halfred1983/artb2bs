import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:database_service/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../onboard/cubit/art_info_cubit.dart';
import '../../utils/common.dart';
import '../../widgets/app_input_validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/loading_screen.dart';
import '../cubit/photo_cubit.dart';
import '../cubit/photo_state.dart';

class PhotoView extends StatefulWidget {
  const PhotoView({Key? key}) : super(key: key);

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {

  GlobalKey<FormState> key = GlobalKey();
  final List<String> _photoTags = ['Arty', 'Commercial', 'Portrait', 'Happy', 'Sad'];
  File? _imageFile;

  CollectionReference _reference =
  FirebaseFirestore.instance.collection('shopping_list');

  String imageUrl = '';
  User? user;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoCubit, PhotoState>(
      builder: (context, state) {

        if( state is LoadingState) {
          return const LoadingScreen();
        }
        // if(state is DataSaved) {
        //   return HomePage();
        // }
        if (state is LoadedState) {
          user = state.user;
        }

        return Scaffold(
            appBar: AppBar(
              title: Text("Add your artwork", style: TextStyles.boldAccent24,),
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
                                  Text('Choose from gallery', style: TextStyles.semiBoldViolet16,),
                                  horizontalMargin16,
                                  const Icon(FontAwesomeIcons.image, color: AppTheme.primaryColourViolet),
                                ],
                              ),

                            )
                        ),
                      ) : Container(),
                      // IconButton(
                      //     onPressed: () async {
                      //       /*
                      // * Step 1. Pick/Capture an image   (image_picker)
                      // * Step 2. Upload the image to Firebase storage
                      // * Step 3. Get the URL of the uploaded image
                      // * Step 4. Store the image URL inside the corresponding
                      // *         document of the database.
                      // * Step 5. Display the image on the list
                      // *
                      // * */
                      //
                      //       /*Step 1:Pick image*/
                      //       //Install image_picker
                      //       //Import the corresponding library
                      //
                      //       _getFromGallery();
                      //       //Import dart:core
                      //
                      //       /*Step 2: Upload to Firebase storage*/
                      //       //Install firebase_storage
                      //       //Import the library
                      //
                      //       //Get a reference to storage root
                      //       // Reference referenceRoot = FirebaseStorage.instance.ref();
                      //       // Reference referenceDirImages =
                      //       // referenceRoot.child('images');
                      //       //
                      //       // //Create a reference for the image to be stored
                      //       // Reference referenceImageToUpload =
                      //       // referenceDirImages.child('name');
                      //       //
                      //       // //Handle errors/success
                      //       // try {
                      //       //   //Store the file
                      //       //   await referenceImageToUpload.putFile(File(file!.path));
                      //       //   //Success: get the download URL
                      //       //   imageUrl = await referenceImageToUpload.getDownloadURL();
                      //       // } catch (error) {
                      //       //   //Some error occurred
                      //       // }
                      //     },
                      //     icon: Icon(Icons.camera_alt)),
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
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Align (
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: AppTheme.white,
                            child: IconButton (
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

                      _NameTextField((nameValue) => context.read<ArtInfoCubit>().chooseCapacity(nameValue),
                          'Name of the artwork'),
                      // verticalMargin48,
                      //Year
                      verticalMargin24,

                      _NameTextField((nameValue) => context.read<ArtInfoCubit>().chooseCapacity(nameValue),
                          'Year', TextInputType.number),
                      //Price
                      verticalMargin24,

                      _NameTextField((nameValue) => context.read<ArtInfoCubit>().chooseCapacity(nameValue),
                          'Price', TextInputType.number),
                      //Size
                      verticalMargin24,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(FontAwesomeIcons.rulerVertical, color: AppTheme.primaryColourViolet),
                          Expanded(
                            flex: 1,
                            child: _NameTextField((nameValue) => context.read<ArtInfoCubit>().chooseCapacity(nameValue),
                                'Height (cm)', TextInputType.number),
                          ),
                          horizontalMargin24,
                          const Icon(FontAwesomeIcons.rulerHorizontal, color: AppTheme.primaryColourViolet),
                          horizontalMargin12,
                          Expanded(
                            flex: 1,
                            child: _NameTextField((nameValue) => context.read<ArtInfoCubit>().chooseCapacity(nameValue),
                                'Width (cm)', TextInputType.number),
                          ),
                        ],
                      ),
                      verticalMargin24,
                      ChipTags(
                        list: _photoTags,
                        chipColor: AppTheme.secondaryColourRed,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        separator: ',',
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppTheme.white,
                            hintText: 'Vibes (coma separated)',
                            hintStyle: TextStyles.semiBolViolet16,
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

                      LinearProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                        color: Colors.red,
                        minHeight: 15,
                        value: _progress,
                      ),

                      // ElevatedButton(
                      //     onPressed: () async {
                      //       if (imageUrl.isEmpty) {
                      //         ScaffoldMessenger.of(context)
                      //             .showSnackBar(SnackBar(content: Text('Please upload an image')));
                      //
                      //         return;
                      //       }
                      //
                      //       // if (key.currentState!.validate()) {
                      //       //   String itemName = _controllerName.text;
                      //       //   String itemQuantity = _controllerQuantity.text;
                      //       //
                      //       //   //Create a Map of data
                      //       //   Map<String, String> dataToSend = {
                      //       //     'name': itemName,
                      //       //     'quantity': itemQuantity,
                      //       //     'image': imageUrl,
                      //       //   };
                      //       //
                      //       //   //Add a new item
                      //       //   _reference.add(dataToSend);
                      //       // }
                      //     },
                      //     child: Text('Submit'))
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar:  Container(
                padding: buttonPadding,
                child: ElevatedButton(
                  onPressed: () {
                    final uploadTask = context.read<PhotoCubit>().storePhoto(user!.id+'/artworks/', _imageFile);

                    // Listen for state changes, errors, and completion of the upload.
                    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
                      switch (taskSnapshot.state) {
                        case TaskState.running:
                          _progress =
                              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
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
                          await taskSnapshot.ref.getDownloadURL();

                        // Handle successful uploads on complete
                        // ...
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
}



class _NameTextField extends StatefulWidget {
  const _NameTextField(this.nameChanged, this.hint, [this.textInputType]);
  final ValueChanged<String> nameChanged;
  final String hint;
  final TextInputType? textInputType;


  @override
  State<_NameTextField> createState() =>
      _NameTextFieldState(nameChanged, hint, textInputType);
}

class _NameTextFieldState extends State<_NameTextField> {

  late final TextEditingController _nameController;
  final ValueChanged<String> _nameChanged;
  final String _hint;
  final TextInputType? _textInputType;

  _NameTextFieldState(this._nameChanged, this._hint, this._textInputType);

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