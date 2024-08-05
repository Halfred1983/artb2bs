import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/host/cubit/host_state.dart';
import 'package:artb2b/profile/host_profile.dart';
import 'package:artb2b/utils/common.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../injection.dart';
import '../../app/resources/assets.dart';
import '../../app/resources/theme.dart';
import '../../profile/profile.dart';
import '../../widgets/audience.dart';
import '../../widgets/host_widget.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/venue_card.dart';
import '../cubit/host_cubit.dart';
import 'host_dashboard_view.dart';

class HostSettingPage extends StatelessWidget {

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => HostSettingPage());
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
  int _selectedIndex = 0;


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
                  scrolledUnderElevation: 0,
                  title: Text(user!.userInfo!.name!, style: TextStyles.boldN90017,),
                  centerTitle: true,
                  iconTheme: const IconThemeData(
                    color: AppTheme.n900, //change your color here
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48.0),
                    child: SegmentedButton(
                      segments: [
                        ButtonSegment(value: 0, label: Text('Listing preview', style: TextStyles.boldN90014,)),
                        ButtonSegment(value: 1, label: Text('Listing settings', style: TextStyles.boldN90014,)),
                      ],
                      selected: {_selectedIndex},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _selectedIndex = newSelection.first;
                        });
                      },
                    ),
                  ),
                ),
              body: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: horizontalPadding24 + verticalPadding24,
                  child: _selectedIndex == 0 ? _buildVenuePreview(user!) :
                    _buildVenueSettings(user!),
                ),
              ),
            );
          },
      );
  }

  Widget _buildVenuePreview(User user) {
   return HostProfileWidget(user: user);
  }

  _buildVenueSettings(User user) {
    return Container(width: 200, height: 100, color: Colors.yellow);
  }
}



