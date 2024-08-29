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
import 'package:shared_preferences/shared_preferences.dart';

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

class Artb2b extends StatefulWidget {
  @override
  _Artb2bState createState() => _Artb2bState();
}

class _Artb2bState extends State<Artb2b> {
  late Future<void> _configLoadFuture;

  @override
  void initState() {
    super.initState();
    _configLoadFuture = _fetchAndStoreConfig();
  }

  Future<void> _fetchAndStoreConfig() async {
    try {
      final databaseService = locator.get<FirestoreDatabaseService>();
      final prefs = locator.get<SharedPreferences>();

      // Fetch the config data from Firebase through the service
      Map<String, dynamic> configData = await databaseService.fetchConfigData();

      // Store the config data in SharedPreferences
      configData.forEach((key, value) async {
        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is List<dynamic>) {
          await prefs.setStringList(key, value.map((e) => e.toString()).toList());
        }
      });

      print('Config data stored locally.');
    } catch (e) {
      print('Error fetching config: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = AppTheme.theme;

    return DismissKeyboard(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginCubit(
              locator.get<FirebaseAuthService>(),
              locator.get<FirestoreDatabaseService>(),
              locator.get<NotificationService>(),
            ),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => NotificationBloc(
              notificationRepository: locator.get<NotificationService>(),
            ),
          ),
        ],
        child: FutureBuilder<void>(
          future: _configLoadFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator while config is being loaded
              return MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              // Handle any errors that occurred during the config fetch
              return MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: Text('Error loading configuration.'),
                  ),
                ),
              );
            } else {
              // Once the config is loaded, proceed to load the main app
              return MaterialApp.router(
                theme: theme,
                routerConfig: AppRouter(context.read<LoginCubit>()).router,
                title: 'ArtB2B',
                debugShowCheckedModeBanner: false,
              );
            }
          },
        ),
      ),
    );
  }
}
