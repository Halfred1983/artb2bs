import 'dart:io';

import 'package:artb2b/home/view/home_page.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../utils/common.dart';
import '../../utils/currency/currency_helper.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/input_text_widget.dart';
import '../../widgets/loading_screen.dart';
import '../cubit/photo_cubit.dart';
import '../cubit/photo_state.dart';

class ArtworkUploadPage extends StatelessWidget {
  final String collectionId;

  ArtworkUploadPage({required this.collectionId});

  static Route<void> route(String collectionId) {
    return MaterialPageRoute<void>(builder: (_) => ArtworkUploadPage(collectionId: collectionId));
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();
  final FirestoreStorageService storageService = locator<FirestoreStorageService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhotoCubit>(
      create: (context) => PhotoCubit(
        databaseService: databaseService,
        storageService: storageService,
        userId: authService.getUser().id,
      ),
      child: ArtworkUploadView(collectionId: collectionId),
    );
  }
}


class ArtworkUploadView extends StatefulWidget {
  final String collectionId;

  const ArtworkUploadView({Key? key, required this.collectionId}) : super(key: key);

  @override
  State<ArtworkUploadView> createState() => _ArtworkUploadViewState();
}
class _ArtworkUploadViewState extends State<ArtworkUploadView> {

  GlobalKey<FormState> key = GlobalKey();
  final List<String> _photoTags = [];
  File? _imageFile;
  String? _downloadUrl;

  String imageUrl = '';
  User? user;
  double _progress = 0;

  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _artworkNameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  Artwork artwork = Artwork.empty();


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoCubit, PhotoState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }

        if (state is ArtworkUploadedState) {
          WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _showAlertDialog(state.artwork.name!));
        }

        if (state is LoadedState) {
          user = state.user;
        }

        if (state is ArtworkUpdatedState) {
          artwork = state.artwork;
        }

        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text(
              "Add your artwork",
              style: TextStyles.boldN90017,
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: AppTheme.n900, //change your color here
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: horizontalPadding24 + verticalPadding24,
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _imageFile == null
                        ? InkWell(
                      onTap: () async {
                        _getFromGallery();
                      },
                      child: DottedBorder(
                        color: AppTheme.n900,
                        strokeWidth: 4,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [8, 10],
                        child: SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Choose from gallery',
                                style: TextStyles.semiBoldN90014,
                              ),
                              horizontalMargin16,
                              const Icon(FontAwesomeIcons.image,
                                  color: AppTheme.n900),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Container(),
                    verticalMargin12,
                    _imageFile != null
                        ? Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(20)),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: AppTheme.white,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _imageFile = null;
                                });
                              },
                              child: const Icon(
                                FontAwesomeIcons.xmark,
                                color: AppTheme.n900,
                                size: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        : Container(),
                    verticalMargin24,
                    _buildTextInputField(
                        label: 'Artwork Name',
                        controller: _artworkNameController,
                        onChanged: (value) => context
                            .read<PhotoCubit>()
                            .chooseName(value)),
                    verticalMargin24,
                    _buildTypeAheadField(
                      label: 'Type',
                      controller: _typeController,
                      onSelected: (value) {
                        _typeController.text = value;
                        context.read<PhotoCubit>().chooseType(value);
                      },
                    ),
                    verticalMargin24,
                    _buildTextInputField(
                        label: 'Year',
                        controller: _yearController,
                        onChanged: (value) => context
                            .read<PhotoCubit>()
                            .chooseYear(value),
                        keyboardType: TextInputType.number),
                    verticalMargin24,
                    _buildTypeAheadField(
                        label: 'Technique',
                        controller: _typeAheadController,
                        onSelected: (value) {
                          _typeAheadController.text = value;
                          context
                              .read<PhotoCubit>()
                              .chooseTechnique(value);
                        }
                    ),
                    verticalMargin24,
                    _buildTextInputField(
                        label: 'Artwork Price (${CurrencyHelper.currency(user!.userInfo!.address!.country).currencyName!})',
                        controller: _priceController,
                        onChanged: (value) => context
                            .read<PhotoCubit>()
                            .choosePrice(value),
                        keyboardType: TextInputType.number),
                    verticalMargin24,
                    Text('Dimensions', style: TextStyles.boldN90012),
                    verticalMargin4,
                    _buildDimensionFields(),
                    verticalMargin16,
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(context),
        );
      },
    );
  }

  Widget _buildTextInputField({
    String? label,
    String? hint,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label != null)Text(label, style: TextStyles.boldN90012),
        verticalMargin8,
        TextField(
          controller: controller,
          autofocus: false,
          style: TextStyles.semiBoldN90014,
          onChanged: onChanged,
          autocorrect: false,
          enableSuggestions: false,
          decoration:
          AppTheme.textInputDecoration.copyWith(hintText: label ?? hint),
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
        ),
      ],
    );
  }

  Widget _buildTypeAheadField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onSelected,
  }) {

      final FocusNode focusNode = FocusNode();
      final List<String> suggestions = label == 'Technique' ? _getTechniques('') : _getTypes('');

      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          if (!suggestions.contains(controller.text)) {
            controller.clear();
          }
        }
      });


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyles.boldN90012),
        verticalMargin8,
        TypeAheadField(
          hideOnSelect: true,
          builder: (context, _, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: false,
              decoration:
              AppTheme.textInputDecoration.copyWith(hintText: label),
            );
          },
          onSelected: (pattern) {
            controller.text = pattern;
            onSelected(pattern);
          },
          suggestionsCallback: (pattern) {
            return label == 'Technique'
                ? _getTechniques(pattern)
                : _getTypes(pattern);
          },
          itemBuilder: (context, suggestion) {
            return Container(
                padding: const EdgeInsets.all(10),
                color: AppTheme.white,
                child: Text(suggestion, style: TextStyles.semiBoldN90014));
          },
        ),
      ],
    );
  }

  Widget _buildDimensionFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: _buildTextInputField(
            hint: 'Height (cm)',
            controller: _heightController,
            onChanged: (value) => context
                .read<PhotoCubit>()
                .chooseHeight(value),
            keyboardType: TextInputType.number,
          ),
        ),
        horizontalMargin12,
        const Icon(
          FontAwesomeIcons.x,
          color: AppTheme.n900,
          size: 10,
        ),
        horizontalMargin12,
        Expanded(
          flex: 1,
          child: _buildTextInputField(
            hint: 'Width (cm)',
            controller: _widthController,
            onChanged: (value) => context
                .read<PhotoCubit>()
                .chooseWidth(value),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
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
              child: Text(
                '$_progress%',
                style: TextStyles.semiBoldAccent14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      padding: buttonPadding,
      child: ElevatedButton(

        onPressed: _canUpload() ? () {
          _showProgressDialog(context);
          final uploadTask = context.read<PhotoCubit>().storePhoto(
              user!.id + '/artworks/' + path.basename(_imageFile!.path),
              _imageFile);

          uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
            switch (taskSnapshot.state) {
              case TaskState.running:
                _progress = 100.0 *
                    (taskSnapshot.bytesTransferred /
                        taskSnapshot.totalBytes);
                if (context.mounted) {
                  setState(() {});
                }
                break;
              case TaskState.paused:
                break;
              case TaskState.canceled:
                break;
              case TaskState.error:
                break;
              case TaskState.success:
                _downloadUrl =
                await taskSnapshot.ref.getDownloadURL();
                if (context.mounted) {
                  context.read<PhotoCubit>().saveArtwork(
                      _photoTags, _downloadUrl!, user!, widget.collectionId);
                  Navigator.of(context).pop(); // Close the progress dialog
                }
                break;
            }
          });
        } : null,
        child: const Text(
          'Upload',
        ),
      ),
    );
  }

  _canUpload() {
    return _imageFile != null &&
        artwork != null &&
        artwork.name != null && artwork.name!.isNotEmpty &&
        artwork.type != null && artwork.type!.isNotEmpty &&
          _types.contains(artwork.type!) &&
        artwork.technique != null && artwork.technique!.isNotEmpty &&
          _techniques.contains(artwork.technique!) &&
        artwork.year != null && artwork.year!.isNotEmpty &&
        artwork.price != null && artwork.price!.isNotEmpty &&
        artwork.height != null && artwork.height!.isNotEmpty &&
        artwork.width != null && artwork.width!.isNotEmpty;
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 70
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


  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Uploading...', style: TextStyles.semiBoldN90014),
              verticalMargin16,
              LinearProgressIndicator(
                backgroundColor: AppTheme.accentColor,
                color: AppTheme.primaryColor,
                minHeight: 50,
                value: _progress,
              ),
              verticalMargin8,
              Text('${_progress.toStringAsFixed(0)}%', style: TextStyles.semiBoldAccent14),
            ],
          ),
        );
      },
    );
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
            TextButton(
              child: Text('OK', style: TextStyles.semiBoldAccent14.copyWith(
                  decoration: TextDecoration.underline
              ),),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      HomePage(index: 2,)), // Replace NewPage with the actual class of your new page
                );
              },
            ),
          ],
          type: AlertType.success,
          );
      },
    );
  }


  static final List<String> _techniques = [
    'acrylic painting',
    'action painting',
    'aerial perspective',
    'anamorphosis',
    'camaieu',
    'casein painting',
    'chiaroscuro',
    'divisionism',
    'easel painting',
    'encaustic painting',
    'foreshortening',
    'fresco painting',
    'gouache',
    'graffiti',
    'grisaille',
    'impasto',
    'miniature painting',
    'mural',
    'oil painting',
    'panel painting',
    'panorama',
    'perspective',
    'plein-air painting',
    'sand painting',
    'scroll painting',
    'sfumato',
    'sgraffito',
    'sotto in su',
    'tachism',
    'tempera painting',
    'tenebrism',
    'tromp l’oeil',
  ];

  static List<String> _getTechniques(String query) {
    List<String> matches = List.empty(growable: true);
    matches.addAll(_techniques);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  static final List<String> _types = [
    'Portrait',
    'Landscape',
    'Still life',
    'Abstract',
    'Surrealism',
    'Impressionism',
    'Expressionism',
    'Realism',
    'History painting',
    'Genre painting',
  ];

  static List<String> _getTypes(String query) {
    List<String> matches = List.empty(growable: true);
    matches.addAll(_types);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

}
