import 'dart:convert';

import 'package:auth_service/src/models/models.dart';
import 'package:auth_service/src/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class FirebaseAuthService implements AuthService {
  FirebaseAuthService(this._firebaseAuth, this._cache);

  //
  // @factoryMethod
  // FirebaseAuthService.from(auth.FirebaseAuth auth, SharedPreferences sharedPreferences );


  // FirebaseAuthService({
  //   required auth.FirebaseAuth authService,
  //   // required Future<SharedPreferences> sharedPreferences
  // }) : _firebaseAuth = authService;
        // _cache = sharedPreferences;

  final auth.FirebaseAuth? _firebaseAuth;
  final SharedPreferences? _cache;


  // @PostConstruct()
  // void init() async {
  //   _cache = await SharedPreferences.getInstance();
  //   _firebaseAuth = FirebaseAuth.instance;
  // }

  final GoogleSignIn _googleSignIn = GoogleSignIn.standard();
  static const userCacheKey = '__user_cache_key__';


  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  UserEntity get currentUser {
      if(_cache!.getString(userCacheKey) != null) {
        return UserEntity.fromJson(json.decode(_cache!.getString(userCacheKey)!));
      }
      else {
        return UserEntity.empty();
      }

  }
  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => currentUser != UserEntity.empty();

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<UserEntity> get user {
    return _firebaseAuth!.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? UserEntity.empty() : _mapFirebaseUser(firebaseUser);
      SharedPreferences.getInstance().then((cache) => cache.setString(userCacheKey, json.encode(user.toJson())));
      return user;
    });
  }

  UserEntity _mapFirebaseUser(auth.User? user) {
    if (user == null) {
      return UserEntity.empty();
    }

    var splittedName = ['Name ', 'LastName'];
    if (user.displayName != null) {
      splittedName = user.displayName!.split(' ');
    }

    final map = <String, dynamic>{
      'id': user.uid,
      'firstName': splittedName.first,
      'lastName': splittedName.last,
      'email': user.email ?? '',
      'emailVerified': user.emailVerified,
      'imageUrl': user.photoURL ?? '',
      'isAnonymous': user.isAnonymous,
      'creationDate': user.metadata.creationTime.toString(),
      'lastSignIn': user.metadata.lastSignInTime.toString(),
    };
    return UserEntity.fromJson(map);
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _mapFirebaseUser(userCredential.user!);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserEntity userEntity = _mapFirebaseUser(_firebaseAuth!.currentUser!);
      SharedPreferences.getInstance().then((cache) => cache.setString(userCacheKey, json.encode(userEntity.toJson())));

      return userEntity;
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      late final AuthCredential credential;
      // if (isWeb) {
      //   final googleProvider = firebase_auth.GoogleAuthProvider();
      //   final userCredential = await _firebaseAuth.signInWithPopup(
      //     googleProvider,
      //   );
      //   credential = userCredential.credential!;
      // } else {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // }

      await _firebaseAuth!.signInWithCredential(credential);
      UserEntity userEntity = _mapFirebaseUser(_firebaseAuth!.currentUser!);

      SharedPreferences.getInstance().then((cache) => cache.setString(userCacheKey, json.encode(userEntity.toJson())));
      return userEntity;
    } on FirebaseAuthException catch (e) {
      throw throw _determineError(e);
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth!.signOut(),
        _googleSignIn.signOut(),
        _cache!.remove(userCacheKey)
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  AuthError _determineError(auth.FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return AuthError.invalidEmail;
      case 'user-disabled':
        return AuthError.userDisabled;
      case 'user-not-found':
        return AuthError.userNotFound;
      case 'wrong-password':
        return AuthError.wrongPassword;
      case 'email-already-in-use':
      case 'account-exists-with-different-credential':
        return AuthError.emailAlreadyInUse;
      case 'invalid-credential':
        return AuthError.invalidCredential;
      case 'operation-not-allowed':
        return AuthError.operationNotAllowed;
      case 'weak-password':
        return AuthError.weakPassword;
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
      default:
        return AuthError.error;
    }
  }
}
class LogOutFailure implements Exception {}

