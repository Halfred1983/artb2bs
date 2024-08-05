import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/host/cubit/host_state.dart';
import 'package:artb2b/utils/common.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/venue_card.dart';
import '../cubit/host_cubit.dart';
import 'host_dashboard_view.dart';
import 'host_setting_page.dart';

class HostListingPage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => HostListingPage());
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<HostCubit>(
        create: (context) => HostCubit(
          databaseService: databaseService,
          userId: authService.getUser().id,
        ),
        child: const HostSettingView(),
      );
  }
}


class HostSettingView extends StatefulWidget {
  const HostSettingView({super.key});

  @override
  State<HostSettingView> createState() => _HostSettingViewState();
}

class _HostSettingViewState extends State<HostSettingView> {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();


  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<HostCubit, HostState>(
          builder: (context, state) {
            if(state is BookingSettingsDetail) {
            }
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is LoadedState) {
              user = state.user;
            }
            return Scaffold(
                appBar: AppBar(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalMargin32,
                      Text("Your listings", style: TextStyles.boldN90029,),
                      verticalMargin48,
                    ],
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
                            child: VenueCard(user: user!, showActive: true,),
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

