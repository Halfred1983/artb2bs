import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:image_picker/image_picker.dart';

import '../app/resources/styles.dart';
import '../app/resources/theme.dart';
import '../onboard/cubit/art_info_cubit.dart';
import '../utils/common.dart';
import 'app_input_validators.dart';
import 'app_text_field.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {

  GlobalKey<FormState> key = GlobalKey();
  final List<String> _photoTags = ['Arty', 'Commercial', 'Portrait', 'Happy', 'Sad'];
  File? imageFile;

  CollectionReference _reference =
  FirebaseFirestore.instance.collection('shopping_list');

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add your artwork", style: TextStyles.boldAccent24,),
        centerTitle: true,
      ),
      body: Padding(
        padding: horizontalPadding24,
        child: Form(
          key: key,
          child: Column(
            children: [
              _NameTextField((nameValue) => context.read<ArtInfoCubit>().chooseCapacity(nameValue),
              'Name of the artwork'),
              // verticalMargin48,
              //Year
              _NameTextField((nameValue) => context.read<ArtInfoCubit>().chooseCapacity(nameValue),
              'Year'),
              //Price
              _NameTextField((nameValue) => context.read<ArtInfoCubit>().chooseCapacity(nameValue),
                  'Price'),
              //Size
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 1,
                    child: _NameTextField((nameValue) => context.read<ArtInfoCubit>().chooseCapacity(nameValue),
                        'Height'),
                  ),
                  horizontalMargin24,
                  Expanded(
                    flex: 1,
                    child: _NameTextField((nameValue) => context.read<ArtInfoCubit>().chooseCapacity(nameValue),
                        'Width'),
                  ),
                ],
              ),
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

              IconButton(
                  onPressed: () async {
                    /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */

                    /*Step 1:Pick image*/
                    //Install image_picker
                    //Import the corresponding library

                    XFile? file = await _getFromGallery();
                    print('${file?.path}');

                    if (file == null) return;
                    //Import dart:core

                    /*Step 2: Upload to Firebase storage*/
                    //Install firebase_storage
                    //Import the library

                    //Get a reference to storage root
                    // Reference referenceRoot = FirebaseStorage.instance.ref();
                    // Reference referenceDirImages =
                    // referenceRoot.child('images');
                    //
                    // //Create a reference for the image to be stored
                    // Reference referenceImageToUpload =
                    // referenceDirImages.child('name');
                    //
                    // //Handle errors/success
                    // try {
                    //   //Store the file
                    //   await referenceImageToUpload.putFile(File(file!.path));
                    //   //Success: get the download URL
                    //   imageUrl = await referenceImageToUpload.getDownloadURL();
                    // } catch (error) {
                    //   //Some error occurred
                    // }
                  },
                  icon: Icon(Icons.camera_alt)),
              ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Please upload an image')));

                      return;
                    }

                    // if (key.currentState!.validate()) {
                    //   String itemName = _controllerName.text;
                    //   String itemQuantity = _controllerQuantity.text;
                    //
                    //   //Create a Map of data
                    //   Map<String, String> dataToSend = {
                    //     'name': itemName,
                    //     'quantity': itemQuantity,
                    //     'image': imageUrl,
                    //   };
                    //
                    //   //Add a new item
                    //   _reference.add(dataToSend);
                    // }
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
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
        imageFile = File(pickedFile.path);
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
        imageFile = File(pickedFile.path);
      });
    }
  }
}



class _NameTextField extends StatefulWidget {
  const _NameTextField(this.nameChanged, this.hint);
  final ValueChanged<String> nameChanged;
  final String hint;


  @override
  State<_NameTextField> createState() => _NameTextFieldState(nameChanged, hint);
}

class _NameTextFieldState extends State<_NameTextField> {

  late final TextEditingController _nameController;
  final ValueChanged<String> _nameChanged;
  final String _hint;

  _NameTextFieldState(this._nameChanged, this._hint);

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
      labelText: '',
      hintText: _hint,
      validator: AppInputValidators.required(
          'Name required'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      autoCorrect: false,
      onChanged: _nameChanged,
    );
  }
}