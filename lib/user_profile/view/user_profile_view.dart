import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/home/bloc/user_cubit.dart';
import 'package:artb2b/host/cubit/host_cubit.dart';
import 'package:artb2b/host/cubit/host_state.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/user_profile/view/booking_history.dart';
import 'package:artb2b/user_profile/view/payout_history.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../login/cubit/login_cubit.dart';
import '../../../login/view/login_page.dart';
import '../../../utils/common.dart';
import '../../app/resources/assets.dart';
import '../../widgets/loading_screen.dart';


class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

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
                  scrolledUnderElevation: 0,
                  title: Text("Your Profile", style: TextStyles.boldAccent24,),
                  centerTitle: true,
                  iconTheme: const IconThemeData(
                    color: AppTheme.primaryColor, //change your color here
                  ),
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: horizontalPadding24,
                      child: CommonCard(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                                user!.userInfo!.userType! ==
                                                    UserType.gallery
                                                    ?
                                                'assets/images/gallery.png'
                                                    : 'assets/images/artist.png'),
                                        imageUrl: user!.imageUrl.isNotEmpty ? user!.imageUrl : Assets.logoUrl,
                                    )
                                ),
                                horizontalMargin24,
                                Text('Hello, ',
                                  style: TextStyles.semiBoldAccent14,),
                                Text(user!.firstName,
                                  style: TextStyles.semiBoldAccent14,),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalMargin24,
                    if(user!.userInfo!.userType == UserType.gallery) ...[

                      Container(
                        width: double.infinity,
                        height: 70,
                        color: Colors.white,
                        padding: horizontalPadding12,
                        child: SwitchListTile(
                          subtitle: Text('When Active artists can book you',
                            style: TextStyles.regularAccent14,),
                          activeColor: AppTheme.primaryColor,
                          inactiveTrackColor: AppTheme
                              .primaryColorOpacity,
                          onChanged: (value) =>
                              context.read<OnboardingCubit>().setActive(value),
                          value: user!.bookingSettings!.active!,
                          title: Text(
                            'Active', style: TextStyles.semiBoldAccent14,),
                        ),
                      ),
                      verticalMargin24,
                      SettingItem(text: 'Payout history', onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PayoutHistory(user: user!)),
                      ),lowerBorder: true),
                    ],
                    // verticalMargin24,
                    SettingItem(text: 'Booking history', onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingHistory(user: user!)),
                    ),lowerBorder: false),
                    Expanded(child: Container()),
                    SettingItem(text: 'Help', onPressed: () => logout(context)),
                    SettingItem(
                        text: 'About Artb2b', onPressed: () => logout(context)),
                    SettingItem(text: 'Terms and conditions',
                        onPressed: () => logout(context)),
                    SettingItem(text: 'On the socials',
                      onPressed: () => logout(context),
                      lowerBorder: false,),
                    verticalMargin12,
                    SettingItem(text: 'Logout',
                      onPressed: () => logout(context),
                      lowerBorder: false,),
                    verticalMargin12,
                  ],
                )
            );
          }
          return Container();
        }
    );
  }

  void logout(BuildContext context) {
    context.read<LoginCubit>().logout();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
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
