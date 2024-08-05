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
  ArtworkDetails({super.key, required this.artwork, this.isOwner = false});

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();
  final FirestoreStorageService storageService = locator<FirestoreStorageService>();


  final Artwork artwork;
  final bool isOwner;


  void handleClick(int item, BuildContext context) {
    switch (item) {
      case 0:
        _showAlertDialog(context);
        break;
      case 1:
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
                    title: Text("Artwork details", style: TextStyles.boldAccent24,),
                    centerTitle: true,
                    iconTheme: const IconThemeData(
                      color: AppTheme.primaryColor, //change your color here
                    ),
                    actions: isOwner == true ? [
                      PopupMenuButton<int>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (item) => handleClick(item, context),
                        itemBuilder: (context) => [
                          const PopupMenuItem<int>(value: 0, child: Text('Delete')),
                          const PopupMenuItem<int>(value: 1, child: Text('Edit')),
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
                            Text('Name:', style: TextStyles.semiBoldAccent14,),
                            verticalMargin8,
                            Text(artwork.name ?? 'n/a', style: TextStyles.semiBoldAccent14,),
                            Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
                            verticalMargin24,
                            Text('Year:', style: TextStyles.semiBoldAccent14,),
                            verticalMargin8,
                            Text(artwork.name ?? 'n/a', style: TextStyles.semiBoldAccent14,),
                            Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
                            verticalMargin24,
                            Text('Technique:', style: TextStyles.semiBoldAccent14,),
                            verticalMargin8,
                            Text(artwork.technique ?? 'n/a', style: TextStyles.semiBoldAccent14,),
                            Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
                            verticalMargin24,
                            Text('Price:', style: TextStyles.semiBoldAccent14,),
                            verticalMargin8,
                            Text(artwork.price != null ? '${artwork.price} ${artwork.currencyCode}' : 'n/a', style: TextStyles.semiBoldAccent14,),
                            Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
                            verticalMargin24,
                            Text('Size:', style: TextStyles.semiBoldAccent14,),
                            verticalMargin8,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(FontAwesomeIcons.arrowsLeftRight, color: AppTheme.primaryColor, size: 30,),
                                horizontalMargin8,
                                Text(artwork.width != null ? '${artwork.width} cm' : 'n/a', style: TextStyles.semiBoldAccent14,),
                                horizontalMargin24,
                                const Icon(FontAwesomeIcons.arrowsUpDown, color: AppTheme.primaryColor, size: 30,),
                                horizontalMargin8,
                                Text(artwork.height != null ? '${artwork.height} cm' : 'n/a', style: TextStyles.semiBoldAccent14,),
                              ],
                            ),
                            Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
                            verticalMargin24,
                            Text('Vibes:', style: TextStyles.semiBoldAccent14,),
                            verticalMargin8,
                            Text( (artwork.tags != null && artwork.tags!.isNotEmpty) ? artwork.tags!.join(", ") : 'n/a',
                              style: TextStyles.semiBoldAccent14,),
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
              child: AlertDialog( // <-- SEE HERE
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                title: const Center(child:Text('Confirm delete ?')),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'Tap OK to delete your artwork:\n\n',
                            style: TextStyles.semiBoldAccent14,
                            children: <TextSpan>[
                              TextSpan(text: artwork.name,
                                style:TextStyles.semiBoldAccent14,
                              ),
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  TextButton(
                    child: Text('OK', style: TextStyles.semiBoldAccent14.copyWith(
                        decoration: TextDecoration.underline
                    ),),
                    onPressed: () {
                      context.read<PhotoCubit>().deleteArtwork(artwork.url!);
                      Navigator.of(context)..pop()..pop();
                    },
                  ),
                  TextButton(
                    child: Text('Cancel', style: TextStyles.semiBoldAccent14.copyWith(
                        decoration: TextDecoration.underline
                    ),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
          );
        }
    );
  }

}
