enum AuthErrorEnum {
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  invalidCredential,
  operationNotAllowed,
  weakPassword,
  emailNotVerified,
  error,
}

class AuthError {
  final AuthErrorEnum code;
  final String message;

  AuthError({required this.code, required this.message});
}