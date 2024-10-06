import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storage_service/storage.dart';

import '../../../injection.dart';
import '../../../photo/cubit/photo_cubit.dart';
import '../../../photo/cubit/photo_state.dart';
import '../../../utils/common.dart';
import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../onboard/view/7_venue_photo.dart';
import '../../widgets/custom_dialog.dart';

class PhotoDetails extends StatelessWidget {
  PhotoDetails({super.key, required this.photo, this.isOwner = false, this.isOnboarding = false});

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<
      FirestoreDatabaseService>();
  final FirestoreStorageService storageService = locator<
      FirestoreStorageService>();


  final Photo photo;
  final bool isOwner;
  final bool isOnboarding;


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
        create: (context) =>
            PhotoCubit(
              databaseService: databaseService,
              storageService: storageService,
              userId: authService
                  .getUser()
                  .id,
            ),

        child: BlocBuilder<PhotoCubit, PhotoState>(
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    scrolledUnderElevation: 0,
                    title: Text("Photo details", style: TextStyles.boldN90017,),
                    centerTitle: true,
                    iconTheme: const IconThemeData(
                      color: AppTheme.n900, //change your color here
                    ),
                    actions: isOwner ? [
                      PopupMenuButton<int>(
                        color: AppTheme.white,
                        icon: const Icon(Icons.more_vert),
                        onSelected: (item) => handleClick(item, context),
                        itemBuilder: (context) =>
                        [
                          const PopupMenuItem<int>(
                            value: 0,
                            child: ListTile(
                              leading: Icon(Icons.delete, color: Colors.black),
                              title: Text('Delete'),
                            ),
                          ),
                        ],
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
                                    photo.url!,
                                    fit: BoxFit.contain
                                ),
                              ),
                            ),
                            verticalMargin24,
                            Text('Description:',
                              style: TextStyles.semiBoldN90017,),
                            verticalMargin8,
                            Text(photo.description ?? 'n/a',
                              style: TextStyles.boldN90014,),
                            // Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
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
                type: AlertType.confirmation, // <-- SEE HERE
                title: 'Confirm delete ?',
                content: 'Tap OK to delete your photo: \n\n${photo
                    .description}',
                actions: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: InkWell(
                          child: Text('Cancel',
                            style: TextStyles.regularAccent14.copyWith(
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
                            await context.read<PhotoCubit>().deletePhoto(photo
                                .url!);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => VenuePhotoPage(isOnboarding: isOnboarding,)), // Replace NewPage with the actual class of your new page
                            );
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
