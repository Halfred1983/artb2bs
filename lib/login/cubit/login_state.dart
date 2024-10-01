part of 'login_cubit.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

abstract class LoginState extends Equatable {}


class LoginResult extends LoginState {
  final AuthStatus status;

  LoginResult({this.status = AuthStatus.unknown});

  @override
  List<Object?> get props => [status];
}

class RegistrationResult extends LoginResult {
  final AuthStatus status;

  RegistrationResult({this.status = AuthStatus.unknown});

  @override
  List<Object?> get props => [status];
}

class LoginError extends LoginResult {
  final AuthError error;

  LoginError(this.error);

  @override
  List<Object?> get props => [error];
}