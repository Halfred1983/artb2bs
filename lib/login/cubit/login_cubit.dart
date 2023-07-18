import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authService, this._databaseService) : super( _authService.getUser() != UserEntity.empty() ?
  const LoginState.authenticated() : const LoginState.unauthenticated());

  final FirebaseAuthService _authService;
  final DatabaseService _databaseService;

  void login() async {
    try {
      UserEntity userEntity = await _authService.signInWithGoogle();

      User? artb2bUserEntity = await _databaseService.getUser(
          userId: userEntity.id);
      if (artb2bUserEntity == null) {
        await _databaseService.addUser(
            userEntity: User.fromJson(userEntity.toJson()));
      }

      else {
        //TODO update login time
        // await _databaseService.updateUser(artb2bUserEntity: artb2bUserEntity)
      }
      emit(const LoginState.authenticated());

    }
    catch (e) {
      print('error in the login of the user');
    }
  }

  void logout() async {
    try {
      await _authService.logOut();
      emit(const LoginState.unauthenticated());
    } catch (e) {
      // emit(state.copyWith(message: e.toString(), status: LoginStatus.failure));
    }
  }
}
