import 'package:artb2b/ui/routing/app_router.dart';
import 'package:artb2b/widgets/dismiss_keyboard.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:notification_service/notifications.dart';

import '.env';
import 'app/resources/theme.dart';
import 'injection.dart';
import 'login/cubit/login_cubit.dart';
import 'notification/bloc/notification_bloc.dart';

void main() async {
  // debugPaintSizeEnabled=true;

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();

  await configureDependencies();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);


  runApp(Artb2b());
}

class Artb2b extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var theme = AppTheme.theme;

    return DismissKeyboard(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                LoginCubit(
                    locator.get<FirebaseAuthService>(),
                    locator.get<FirestoreDatabaseService>(),
                    locator.get<NotificationService>()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) =>
                NotificationBloc(
                  notificationRepository: locator.get<NotificationService>(),
                ),
          ),
        ],
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
        ),
    );
  }
}