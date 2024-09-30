import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../cubit/artist_cubit.dart';
import 'artist_dashboard_view.dart';

class ArtistDashboardPage extends StatelessWidget {
  final String? userId;

  ArtistDashboardPage({this.userId});

  static Route<void> route({String? userId}) {
    return MaterialPageRoute<void>(builder: (_) => ArtistDashboardPage(userId: userId));
  }

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    final String effectiveUserId = userId ?? authService.getUser().id;
    bool isViewer = false;
    if(userId != null && authService.getUser().id != userId) {
      isViewer = true;
    }

    return BlocProvider<ArtistCubit>(
      create: (context) => ArtistCubit(
        databaseService: databaseService,
        userId: effectiveUserId,
      ),
      child: ArtistDashboardView(isViewer: isViewer),
    );
  }
}