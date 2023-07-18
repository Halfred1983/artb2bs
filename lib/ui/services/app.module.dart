

import 'package:artb2b/ui/services/firebase.service.dart';
import 'package:auth_service/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
// import 'package:artb2b/ui/services/notification.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';


@module
abstract class AppModule {

  @preResolve
  Future<FirebaseService> get fireService => FirebaseService.init();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @injectable
  FirebaseFirestore get store => FirebaseFirestore.instance;

  @injectable
  FirebaseAuth get auth => FirebaseAuth.instance;

  @injectable
  AuthService get authService;

  @injectable
  FirestoreDatabaseService get databaseService => FirestoreDatabaseService(database: store);




// @preResolve
  // Future<NotificationService> get notificationService async => await NotificationService.init();
}