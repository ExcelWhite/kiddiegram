class UsernameAlreadyExistsException implements Exception {
  final String message;

  UsernameAlreadyExistsException(this.message);
}

class EmailAlreadyExistsException implements Exception {
  final String message;

  EmailAlreadyExistsException(this.message);
}

class ForgotPasswordException implements Exception {
  final String message;

  ForgotPasswordException(this.message);
}

class ResetPasswordException implements Exception {
  final String message;

  ResetPasswordException(this.message);
}