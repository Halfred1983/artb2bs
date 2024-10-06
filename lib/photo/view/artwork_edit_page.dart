import 'dart:io';

import 'package:artb2b/artwork/view/artwork_details.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_service/storage.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../utils/currency/currency_helper.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/loading_screen.dart';
import '../cubit/photo_cubit.dart';
import '../cubit/photo_state.dart';

class ArtworkEditPage extends StatelessWidget {
  final Collection collection;
  final Artwork artwork;

  ArtworkEditPage({required this.collection, required this.artwork});

  static Route<void> route(Collection collection, Artwork artwork) {
    return MaterialPageRoute<void>(builder: (_) => ArtworkEditPage(collection: collection, artwork: artwork,));
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
      )..loadArtwork(artwork),
      child: ArtworkEditView(collection: collection, artwork: artwork),
    );
  }
}


class ArtworkEditView extends StatefulWidget {
  final Collection collection;
  final Artwork artwork;

  const ArtworkEditView({Key? key, required this.collection,
    required this.artwork}) : super(key: key);

  @override
  State<ArtworkEditView> createState() => _ArtworkEditViewState();
}
class _ArtworkEditViewState extends State<ArtworkEditView> {

  GlobalKey<FormState> key = GlobalKey();

  String imageUrl = '';
  User? user;

  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _artworkNameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  Artwork artwork = Artwork.empty();
  SharedPreferences prefs = locator.get<SharedPreferences>();

  static List<String> _techniques = [];
  static List<String> _artworkTypes = [];

  @override
  void initState() {
    super.initState();
    _techniques = prefs.getStringList('Techniques')!;
    _artworkTypes = prefs.getStringList('ArtworkTypes')!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoCubit, PhotoState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }

        if (state is LoadedState) {
          user = state.user;
          artwork = user!.artInfo!.collections.where((collection) => collection.name == widget.collection.name)
              .first.artworks.where((art) => art.url == widget.artwork.url).first;

        }

        if (state is ArtworkUpdatedState) {
          artwork = state.artwork;
        }

        // Pre-populate form fields
        _artworkNameController.text = artwork.name ?? '';
        _typeController.text = artwork.type ?? '';
        _typeAheadController.text = artwork.technique ?? '';
        _yearController.text = artwork.year ?? '';
        _priceController.text = artwork.price ?? '';
        _heightController.text = artwork.height ?? '';
        _widthController.text = artwork.width ?? '';

        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text(
              "Edit your artwork",
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
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                            artwork.url!,
                            fit: BoxFit.contain
                        ),
                      ),
                    ),
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


  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      padding: buttonPadding,
      child: ElevatedButton(
        onPressed: _canEdit() ? () async {

                  await context.read<PhotoCubit>().updateArtwork(user!,
                      artwork, widget.collection);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtworkDetails(
                        collection: widget.collection,
                        artwork: artwork,
                        isOwner: true,
                      ),
                    ),
                  );

        } : null,
        child: const Text(
          'Save',
        ),
      ),
    );
  }

  _canEdit() {
    return
        artwork.name != null && artwork.name!.isNotEmpty &&
        artwork.type != null && artwork.type!.isNotEmpty &&
          _artworkTypes.contains(artwork.type!) &&
        artwork.technique != null && artwork.technique!.isNotEmpty &&
          _techniques.contains(artwork.technique!) &&
        artwork.year != null && artwork.year!.isNotEmpty &&
        artwork.price != null && artwork.price!.isNotEmpty &&
        artwork.height != null && artwork.height!.isNotEmpty &&
        artwork.width != null && artwork.width!.isNotEmpty;
  }

  static List<String> _getTechniques(String query) {
    List<String> matches = List.empty(growable: true);
    matches.addAll(_techniques);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  static List<String> _getTypes(String query) {
    List<String> matches = List.empty(growable: true);
    matches.addAll(_artworkTypes);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
