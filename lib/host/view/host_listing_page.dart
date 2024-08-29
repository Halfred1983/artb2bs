import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/utils/common.dart';
import 'package:auth_service/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/venue_card.dart';
import 'host_setting_page.dart';

class HostListingPage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => HostListingPage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: databaseService.getUserStream(authService.getUser().id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No user data available'));
          }
          final user = User.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          return Scaffold(
              appBar: AppBar(
                title: Padding(
                  padding: horizontalPadding12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalMargin48,
                      Text("Your listings", style: TextStyles.boldN90029,),
                      verticalMargin48,
                    ],
                  ),
                ),
                centerTitle: false,
              ),
              body: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: horizontalPadding24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          child: VenueCard(user: user, showActive: true,),
                          onTap:()  {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HostSettingPage()), // Replace NewPage with the actual class of your new page
                            );
                          }
                      ),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }
}