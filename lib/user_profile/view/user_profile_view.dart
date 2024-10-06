import 'dart:io';

import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/home/bloc/user_cubit.dart';
import 'package:artb2b/host/cubit/host_cubit.dart';
import 'package:artb2b/host/cubit/host_state.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/photo/view/photo_upload_page.dart';
import 'package:artb2b/user_profile/view/booking_history.dart';
import 'package:artb2b/user_profile/view/payout_history.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:database_service/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;


import '../../../login/cubit/login_cubit.dart';
import '../../../login/view/login_page.dart';
import '../../../utils/common.dart';
import '../../app/resources/assets.dart';
import '../../host/view/settings/host_venue_info_page.dart';
import '../../photo/cubit/photo_cubit.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/loading_screen.dart';


class UserProfileView extends StatefulWidget {

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  _UserProfileViewState() {
    getVersionInfo();
  }

  String _version = '';

  String _buildNumber = '';

  GlobalKey<FormState> key = GlobalKey();

  File? _imageFile;

  String? _downloadUrl;

  String imageUrl = '';

  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    User? user;

    return BlocBuilder<HostCubit, HostState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const LoadingScreen();
          }
          if (state is LoadedState) {
            user = state.user;

            return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppTheme.white,
                  scrolledUnderElevation: 0,
                  title: Text("Your Account", style: TextStyles.semiBoldN90017,),
                  centerTitle: true,
                  iconTheme: const IconThemeData(
                    color: AppTheme.n900, //change your color here
                  ),
                ),
                body: Container(
                  height: double.infinity,
                  color: AppTheme.backgroundGrey,
                  child: Column(
                    children: [
                      Padding(
                        padding: horizontalPadding24,
                        child: Column(
                          children: [
                            verticalMargin24,
                            InkWell(
                              onTap: () async {
                                await _getFromGallery();

                                final uploadTask = context.read<PhotoCubit>()
                                    .storePhoto(
                                    user!.id + '/photos/' + path.basename(_imageFile!.path),
                                    _imageFile);

                                // Listen for state changes, errors, and completion of the upload.
                                uploadTask.snapshotEvents.listen((
                                    TaskSnapshot taskSnapshot) async {
                                  switch (taskSnapshot.state) {
                                    case TaskState.running:
                                      _isUploading = true;
                                      if (context.mounted) {
                                        setState(() {

                                        });
                                      }
                                      break;
                                    case TaskState.paused:
                                      print("Upload is paused.");
                                      break;
                                    case TaskState.canceled:
                                      _isUploading = false;
                                      print("Upload was canceled");
                                      break;
                                    case TaskState.error:
                                    // Handle unsuccessful uploads
                                      break;
                                    case TaskState.success:
                                      _isUploading = false;
                                      _downloadUrl =
                                      await taskSnapshot.ref.getDownloadURL();
                                      if (context.mounted) {
                                        context.read<PhotoCubit>().saveProfilePhoto(
                                            _downloadUrl!, user!);
                                      }
                                      break;
                                  }
                                });
                              },
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child:  _imageFile != null ?
                                      CircleAvatar(
                                        radius: 33,
                                        backgroundImage: FileImage(_imageFile!) as ImageProvider,
                                      )
                                       : CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          width: 66,
                                          height: 66,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  Assets.logo),
                                          imageUrl: user!.imageUrl.isNotEmpty ? user!.imageUrl : Assets.logoUrl,
                                      )
                                  ),
                                  Container(
                                    width: 66,
                                    height: 66,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.4), // semi-transparent overlay
                                    ),
                                    child: Center(
                                      child: !_isUploading ? const Icon(Icons.camera_alt, color: Colors.white, size: 20,)
                                      :  const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            verticalMargin16,
                            if(user!.userInfo!.userType == UserType.artist) ...[
                              Text(user!.artInfo!.artistName!,
                                style: TextStyles.boldN90024,),
                            ]
                            else ...[
                              Text(user!.userInfo!.name!,
                                style: TextStyles.boldN90024,),
                            ],
                          ],
                        ),
                      ),
                      verticalMargin24,
                      Padding(
                        padding: horizontalPadding24,
                        child: Divider(
                          color: AppTheme.n900.withOpacity(0.2),
                          thickness: 0.2,
                        ),
                      ),
                      // verticalMargin24,
                      // if(user!.userInfo!.userType == UserType.gallery) ...[
                      //
                      //   // Container(
                      //   //   width: double.infinity,
                      //   //   height: 70,
                      //   //   color: Colors.white,
                      //   //   padding: horizontalPadding12,
                      //   //   child: SwitchListTile(
                      //   //     subtitle: Text('When Active artists can book you',
                      //   //       style: TextStyles.regularAccent14,),
                      //   //     activeColor: AppTheme.primaryColor,
                      //   //     inactiveTrackColor: AppTheme
                      //   //         .primaryColorOpacity,
                      //   //     onChanged: (value) =>
                      //   //         context.read<OnboardingCubit>().setActive(value),
                      //   //     value: user!.bookingSettings!.active!,
                      //   //     title: Text(
                      //   //       'Active', style: TextStyles.semiBoldAccent14,),
                      //   //   ),
                      //   // ),
                      //   verticalMargin24,
                      //   SettingItem(text: 'Payout history', onPressed: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => PayoutHistory(user: user!)),
                      //   ),lowerBorder: true),
                      // ],
                      // // verticalMargin24,
                      // SettingItem(text: 'Booking history', onPressed: () => Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => BookingHistory(user: user!)),
                      // ),lowerBorder: false),
                      // Expanded(child: Container()),
                      // SettingItem(text: 'Help', onPressed: () => logout(context)),
                      // SettingItem(
                      //     text: 'About Artb2b', onPressed: () => logout(context)),
                      // SettingItem(text: 'Terms and conditions',
                      //     onPressed: () => logout(context)),
                      // SettingItem(text: 'On the socials',
                      //   onPressed: () => logout(context),
                      //   lowerBorder: false,),
                      // verticalMargin12,
                      // SettingItem(text: 'Logout',
                      //   onPressed: () => logout(context),
                      //   lowerBorder: false,),
                      // verticalMargin12,
                      _buildUserSettings(user!),
                      Expanded(child: Container()),
                      Container(
                        width: double.infinity,
                        color: AppTheme.s50,
                        height: 50,
                        child: InkWell(
                          onTap: () => _logout(context),
                          child: Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: AppTheme.n900, size: 20,),
                              horizontalMargin4,
                              Text('Logout', style: TextStyles.semiBoldN90017,),
                            ],
                          )),
                        ),
                      ),
                      verticalMargin24,
                      Text('Version $_version', style: TextStyles.regularN90014,),
                      Text('Build Number $_buildNumber', style: TextStyles.regularN90014,),
                      verticalMargin48,
                      verticalMargin48,

                    ],
                  ),
                )
            );
          }
          return Container();
        }
    );
  }

  void getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
  }

  Widget _buildUserSettings(User user) {
    final List<Map<String, dynamic>> tileData = [
      // {'title': 'Personal Data', 'icon': Icons.person, 'targetPage': HostVenueInfoPage()},
      // {'title': 'Booking History', 'icon': Icons.history, 'targetPage': BookingHistory(user: user)},
      if (user.userInfo!.userType != UserType.artist)
        {'title': 'Payout History', 'icon': Icons.payment, 'targetPage': PayoutHistory(user: user)},
      {'title': 'Help', 'icon': Icons.help, 'targetPage': Container()},
      {'title': 'Terms and Conditions', 'icon': Icons.description, 'targetPage': Container()},
    ];

    return Padding(
      padding: verticalPadding24,
      child: ListView.separated(
        shrinkWrap: true,
        padding: horizontalPadding8,
        itemCount: tileData.length,
        itemBuilder: (context, index) {
          final data = tileData[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => data['targetPage']),
              );
            },
            child: Container(
              height: 60,
              padding: horizontalPadding32,
              child: Center(
                child: ListTile(
                  contentPadding: horizontalPadding8,
                  leading: Icon(data['icon'], color: AppTheme.n900),
                  title: Text(data['title'], style: TextStyles.regularN90014),
                  trailing: const Icon(Icons.play_arrow_sharp, color: AppTheme.n900, size: 20),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => verticalMargin8,
      ),
    );
  }

  void _logout(BuildContext context) {
    context.read<LoginCubit>().logout();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                  ),
                ],
                type: AlertType.error,
              );
            });
      }
    }
  }

}


class SettingItem extends StatelessWidget {
  const SettingItem({super.key, required this.text, required this.onPressed, this.lowerBorder = true});

  final String text;
  final VoidCallback onPressed;
  final bool lowerBorder;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppTheme.accentColor,
      onTap: () => onPressed(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          border: Border(
            bottom: BorderSide(
              color: lowerBorder ? AppTheme.accentColor : Colors.white, // Border color
              width: 1.0,
            ),
          ),
        ),
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text(text, style: TextStyles.semiBoldAccent14,),
        ),
      ),
    );
  }
}
