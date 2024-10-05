import 'package:artb2b/photo/view/artwork_edit_page.dart';
import 'package:artb2b/widgets/custom_dialog.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storage_service/storage.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../photo/cubit/photo_cubit.dart';
import '../../photo/cubit/photo_state.dart';
import '../../utils/common.dart';

class ArtworkDetails extends StatelessWidget {
  ArtworkDetails({super.key, required this.artwork, this.isOwner = false, required this.collection});

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();
  final FirestoreStorageService storageService = locator<FirestoreStorageService>();


  final Artwork artwork;
  final Collection collection;
  final bool isOwner;


  void handleClick(int item, BuildContext context) {
    switch (item) {
      case 0:
        _showAlertDialog(context);
        break;
      case 1:
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => ArtworkEditPage(artwork: artwork,
        collection: collection)),
    );
    break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider<PhotoCubit>(
        create: (context) => PhotoCubit(
          databaseService: databaseService,
          storageService: storageService,
          userId: authService.getUser().id,
        ),

        child:  BlocBuilder<PhotoCubit, PhotoState>(
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    scrolledUnderElevation: 0,
                    title: Text("Artwork details", style: TextStyles.boldN90017,),
                    centerTitle: true,
                    iconTheme: const IconThemeData(
                      color: AppTheme.n900, //change your color here
                    ),
                    actions: isOwner == true ? [
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
                          PopupMenuItem<int>(
                            value: 1,
                            child: ListTile(
                              leading: Icon(Icons.edit, color: Colors.black),
                              title: Text('Edit'),
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
                            Text(artwork.name ?? 'n/a', style: TextStyles.boldN90020,),
                            verticalMargin8,
                            Text('Dimensions W:${artwork.width!}cm x H:${artwork.height!}cm', style: TextStyles.regularN90014,),
                            verticalMargin8,
                            Text(artwork.technique ?? 'n/a', style: TextStyles.regularN90014,),
                            verticalMargin12,
                            Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
                            verticalMargin12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Type:', style: TextStyles.boldN90017,),
                                Text(artwork.type ?? 'n/a', style: TextStyles.boldN90017,),
                              ],
                            ),
                            verticalMargin16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Technique:', style: TextStyles.boldN90017,),
                                Text(artwork.technique ?? 'n/a', style: TextStyles.boldN90017,),
                              ],
                            ),
                            verticalMargin16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Year:', style: TextStyles.boldN90017,),
                                Text(artwork.year ?? 'n/a', style: TextStyles.boldN90017,),
                              ],
                            ),
                            verticalMargin16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Price:', style: TextStyles.boldN90017,),
                                Text(artwork.price != null ? '${artwork.price} ${artwork.currencyCode}' : 'n/a', style: TextStyles.boldN90017,),
                              ],
                            )
                          ],
                        ),
                      )
                  )
              );
            }
        )
    );
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
                content: 'Tap OK to delete your artwork:\n\n${artwork.name}',
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
                            await context.read<PhotoCubit>().deleteArtwork(artwork, collection);
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
