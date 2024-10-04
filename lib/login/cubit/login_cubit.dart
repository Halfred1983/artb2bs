import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_service/src/service/notification_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginResult> {
  LoginCubit(this._authService, this._databaseService, this._notificationService) : super( _authService.getUser() != UserEntity.empty() ?
   LoginResult(status: AuthStatus.authenticated) : LoginResult(status: AuthStatus.unauthenticated));

  final FirebaseAuthService _authService;
  final DatabaseService _databaseService;
  final NotificationService _notificationService;

  Future<void> loginWithGoogle() async {
    try {
      UserEntity userEntity = await _authService.signInWithGoogle();

     await fetchAndCreateUser(userEntity);

      emit(LoginResult(status: AuthStatus.authenticated));

    }
    catch (e) {
      print('error in the login of the user');
    }
  }

  Future<void> loginWithApple() async {
    try {
      UserEntity userEntity = await _authService.signInWithApple();

     await fetchAndCreateUser(userEntity);

      emit(LoginResult(status: AuthStatus.authenticated));

    }
    catch (e) {
      print('error in the login of the user');
    }
  }

  Future<void> loginUsernamePassword(String email, String password) async {
    try {
      UserEntity userEntity = await _authService.signInWithEmailAndPassword(email: email, password: password);

      await fetchAndCreateUser(userEntity);

      emit(LoginResult(status: AuthStatus.authenticated));

    } on AuthError catch(e) {
      emit(LoginError(e));
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _authService.forgotPassword(email: email);

      emit(LoginResult(status: AuthStatus.unauthenticated));

    } on AuthError catch(e) {
      emit(LoginError(e));
    }
  }


  registerWithUsernameAndPassword(String email, String password) async {
    try {
      UserEntity userEntity = await _authService.createUserWithEmailAndPassword(email: email, password: password);

      await fetchAndCreateUser(userEntity, UserStatus.notVerified);

      emit(RegistrationResult(status: AuthStatus.unauthenticated));

    } on AuthError catch(e) {
      emit(LoginError(e));
    }
  }


  Future<void> fetchAndCreateUser(UserEntity userEntity, [UserStatus? userStatus]) async {
    User? artb2bUserEntity = await _databaseService.getUser(
        userId: userEntity.id);

    _notificationService.sendTokenToServer(userEntity.id);
    if (artb2bUserEntity == null) {
      User user = User.fromJson(userEntity.toJson())
          .copyWith(userStatus: userStatus ?? UserStatus.initialised)
          .copyWith(createdAt: DateTime.now())
          .copyWith(bookingSettings: BookingSettings(active: false));

      await _databaseService.addUser(userEntity: user);
    }

    else {
      //TODO update login time
      // await _databaseService.updateUser(artb2bUserEntity: artb2bUserEntity)
    }
  }




  Future<void> logout() async {
    try {
      await _authService.logOut();
      emit(LoginResult(status: AuthStatus.unauthenticated));
    } catch (e) {
      // emit(state.copyWith(message: e.toString(), status: LoginStatus.failure));
    }
  }


}
