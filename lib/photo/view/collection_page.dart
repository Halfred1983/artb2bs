

import 'package:artb2b/artwork/view/artwork_details.dart';
import 'package:auth_service/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:storage_service/storage.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/add_photo_button.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/fadingin_picture.dart';
import '../../widgets/loading_screen.dart';
import '../cubit/photo_cubit.dart';
import 'artwork_upload_page.dart';

class CollectionPage extends StatelessWidget {
  CollectionPage({super.key, required this.collectionId, required this.userId, required this.isViewer});

  String userId;
  bool isViewer;

  final String collectionId;
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
          userId: userId,
        ),
        child: CollectionView(collectionId: collectionId, isViewer: isViewer),
      );
  }
}



class CollectionView extends StatefulWidget {
  CollectionView({Key? key, required this.collectionId, required this.isViewer}) : super(key: key);

  final bool isViewer;
  final String collectionId;
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  State<CollectionView> createState() => _CollectionViewState();
}


class _CollectionViewState extends State<CollectionView> {
  Collection? _collection;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<PhotoCubit>().userId;

    return StreamBuilder<DocumentSnapshot>(
      stream: widget.databaseService.getUserStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        User user = User.fromJson(snapshot.data!.data() as Map<String, dynamic>);

        _collection = user.artInfo?.collections.firstWhere(
              (collection) => collection.name == widget.collectionId,
          orElse: () => Collection(name: '', collectionVibes: ''),
        );

        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: AppTheme.white,
            title: Text(_collection!.name!, style: TextStyles.boldN90017),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: AppTheme.n900, //change your color here
            ),
            actions: !widget.isViewer == true ? [
              PopupMenuButton<int>(
                color: AppTheme.white,
                icon: const Icon(Icons.more_vert),
                onSelected: (item) => handleClick(item, context),
                itemBuilder: (context) => const [
                  PopupMenuItem<int>(
                    value: 0,
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.black),
                      title: Text('Delete'),
                    ),
                  ),
                ] ,
              ),
            ] : [],

          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: horizontalPadding24 + verticalPadding12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Collection Vibes:', style: TextStyles.boldN90016),
                  verticalMargin4,
                  Text(_collection!.collectionVibes != null ? _collection!.collectionVibes! : '', style: TextStyles.regularN90014),
                  verticalMargin24,
                  _collection!.artworks.isNotEmpty ? SizedBox(
                    // color: Colors.red,
                    height: 500,
                    child: MasonryGridView.count(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _collection!.artworks.length + 1,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 6,
                      crossAxisCount: 2,
                      itemBuilder: (context, index) {
                        if(index == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: !widget.isViewer ? AddPhotoButton(
                                action: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ArtworkUploadPage(collectionId: _collection!.name!)),
                                  );
                                  // context.read<OnboardingCubit>().getUser(_user!.id);
                                }
                            ) : Container(),
                          );
                        }
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ArtworkDetails(artwork: _collection!.artworks[index - 1], collection: _collection!,
                                isOwner: !widget.isViewer)),
                          ),
                          child: Stack(
                            children: [
                              FadingInPicture(radius: 12, url:  _collection!.artworks[index - 1].url!, applyBottomRadius: true),
                              Positioned(
                                bottom: 15,
                                right: 25,
                                child: Text(_collection!.artworks[index - 1].name ?? '',
                                  style: TextStyles.semiBoldPrimary14,),
                              )
                            ],
                          ),
                        );

                      },
                    ),
                  ) : AddPhotoButton(
                      action: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ArtworkUploadPage(collectionId: _collection!.name!)),
                        );
                        // context.read<OnboardingCubit>().getUser(_user!.id);
                      }
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void handleClick(int item, BuildContext context) {
    switch (item) {
      case 0:
        _showAlertDialog(context);
        break;
    }
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (_) {
          return BlocProvider.value(
              value: context.read<PhotoCubit>(),
              child: CustomAlertDialog( //
                type: AlertType.confirmation,// <-- SEE HERE
                title: 'Confirm delete ?',
                content: 'Tap OK to delete your collection:\n\n${_collection!.name}',
                actions: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: InkWell(
                          child: Text('Cancel', style: TextStyles.regularAccent14.copyWith(
                              decoration: TextDecoration.underline
                          ),),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      horizontalMargin24,
                      Flexible(
                        child: TextButton(
                          child: const Text('OK'),
                          onPressed: () async {
                            await context.read<PhotoCubit>().deleteCollection(_collection!);
                            Navigator.of(context)..pop()..pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )
          );
        }
    );
  }

}


