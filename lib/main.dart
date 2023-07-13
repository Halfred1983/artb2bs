import 'package:artb2b/ui/routing/app_router.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/resources/theme.dart';
import 'injection.dart';
import 'login/cubit/login_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  runApp(Artb2b());
}

class Artb2b extends StatelessWidget {

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {

    var theme = AppTheme.theme;
    var isInitialised = false;
    var isLoggedIn = false;
    return BlocProvider(
      create: (context) => LoginCubit(locator.get<FirebaseAuthService>(),
          locator.get<FirestoreDatabaseService>() ),
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            // debugShowMaterialGrid: true,
            theme: theme,
            routerConfig: AppRouter(context.read<LoginCubit>()).router,
            title: 'ArtB2B',
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
    //   BlocBuilder<AppBloc, AppState>(
    //   builder: (context, state) {
    //     if(state is AppLoading) {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //     if(state is AppStateAuthenticated) {
    //       isLoggedIn = true;
    //
    //       if(state.artb2bUserEntity.artb2bUserEntityInfo != null &&
    //           state.artb2bUserEntity.artb2bUserEntityInfo!.userType != null) {
    //
    //         theme = state.artb2bUserEntity.artb2bUserEntityInfo!.userType == UserType.gallery ?
    //         AppTheme.themeArtist : AppTheme.themeGallery;
    //
    //         isInitialised = state.artb2bUserEntity.userStatus != UserStatus.initialised;
    //       }
    //     }
    //     return MaterialApp.router(
    //       debugShowCheckedModeBanner: false,
    //       theme: theme,
    //       title: 'Art2b2',
    //       routeInformationParser: _appRouter.defaultRouteParser(),
    //       routerDelegate: AutoRouterDelegate.declarative(
    //         _appRouter,
    //         routes: (_) => [
    //           if (isInitialised)
    //             HomaRoute()
    //           else if(isLoggedIn)
    //             PersonalInfoRoute()
    //           else
    //             LoginRoute(),
    //         ],
    //       ),
    //       color: theme.backgroundColor,
    //     );
    //   },
    // );
  }
}