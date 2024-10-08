import '../models/models.dart';

abstract class AuthService {
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> forgotPassword({
    required String email,
  });


  Future<UserEntity> signInWithGoogle();

  Future<UserEntity> signInWithApple();

  Future<void> logOut();

  UserEntity getUser();

}
