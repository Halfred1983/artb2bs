import 'dart:convert';

import 'package:auth_service/src/models/models.dart';
import 'package:auth_service/src/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
  // UserEntity get currentUser {
  //     if(_cache!.getString(userCacheKey) != null) {
  //       return UserEntity.fromJson(json.decode(_cache!.getString(userCacheKey)!));
  //     }
  //     else {
  //       return UserEntity.empty();
  //     }
  // }

  UserEntity getUser() {
    if(_cache!.getString(userCacheKey) != null) {
      return UserEntity.fromJson(json.decode(_cache!.getString(userCacheKey)!));
    }
    else {
      return UserEntity.empty();
    }
  }


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

  UserEntity _mapFirebaseUserFromApple(Map<String, dynamic> user) {
    if (user.isEmpty) {
      return UserEntity.empty();
    }

    final map = <String, dynamic>{
      'id': user['userIdentifier'],
      'firstName': user['givenName'],
      'lastName': user['familyName'],
      'email': user['email'] ?? '',
      'emailVerified': true,
      'imageUrl': '',
      'isAnonymous': user['email'] != null ? true : false,
      'creationDate': DateTime.now().toString(),
      'lastSignIn': DateTime.now().toString(),
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

      //TODO Uncomment this when email verification is needed
      // if(userCredential.user!.emailVerified == false) {
      //   throw AuthError(
      //       code: AuthErrorEnum.emailNotVerified,
      //       message: 'Please verify your email'
      //   );
      // }

      UserEntity userEntity = _mapFirebaseUser(_firebaseAuth!.currentUser!);

      SharedPreferences.getInstance().then((cache) => cache.setString(userCacheKey, json.encode(userEntity.toJson())));

      return userEntity;
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      await _firebaseAuth!.sendPasswordResetEmail(email: email);
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

      _firebaseAuth!.currentUser!.sendEmailVerification();

      UserEntity userEntity = _mapFirebaseUser(_firebaseAuth!.currentUser!);
      //SharedPreferences.getInstance().then((cache) => cache.setString(userCacheKey, json.encode(userEntity.toJson())));

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
  }  /// Starts the Sign In with Google Flow.


  @override
  Future<UserEntity> signInWithApple() async {
    try {
      AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Obtain the user identity information
      final user = {
        'userIdentifier': credential.userIdentifier,
        'email': credential.email,
        'givenName': credential.givenName,
        'familyName': credential.familyName,
      };

      // Authenticate with Firebase using the OAuth credential
      final oAuthProvider = OAuthProvider('apple.com');
      final firebaseCredential = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final authResult = await _firebaseAuth!.signInWithCredential(firebaseCredential);

      // User is now signed in to Firebase and can write to the Firebase database
      final firebaseUser = authResult.user;

      UserEntity userEntity = _mapFirebaseUserFromApple(user);

      SharedPreferences.getInstance().then((cache) => cache.setString(userCacheKey, json.encode(userEntity.toJson())));
      return userEntity;
    } catch (e) {
      // Handle error
      print('Error during Sign in with Apple: $e');
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      _cache!.remove(userCacheKey);
      await Future.wait([
        _googleSignIn.signOut(),
        _firebaseAuth!.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  AuthError _determineError(auth.FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return AuthError(
            code: AuthErrorEnum.invalidEmail,
            message: 'Please enter a valid email'
        );
      case 'user-disabled':
        return AuthError(
            code: AuthErrorEnum.userDisabled,
            message: 'Your user is disabled. Please contact support.'
        );
      case 'user-not-found':
        return AuthError(
            code: AuthErrorEnum.userNotFound,
            message: 'The user was not found. Please register or use another email.'
        );
      case 'wrong-password':
        return AuthError(
            code: AuthErrorEnum.wrongPassword,
            message: 'Wrong password provided.'
        );
      case 'email-already-in-use':
      case 'account-exists-with-different-credential':
        return AuthError(
            code: AuthErrorEnum.emailAlreadyInUse,
            message: 'Email already in use. Please use another email.'
        );
      case 'invalid-credential':
        return AuthError(
            code: AuthErrorEnum.invalidCredential,
            message: 'Invalid credential. Please try again.'
        );
      case 'operation-not-allowed':
        return AuthError(
            code: AuthErrorEnum.operationNotAllowed,
            message: 'Operation not allowed. Please try again.'
        );
      case 'weak-password':
        return AuthError(
            code: AuthErrorEnum.weakPassword,
            message: 'Weak password. Please try again.'
        );
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
      default:
        return AuthError(
            code: AuthErrorEnum.error,
            message: 'An error occurred. Please try again.'
        );
    }
  }

}
class LogOutFailure implements Exception {}

