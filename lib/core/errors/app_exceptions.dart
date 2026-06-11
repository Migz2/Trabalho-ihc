/// App-specific exceptions for Honey
abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Thrown when a Hive operation fails
class HiveException extends AppException {
  HiveException(String message) : super('Hive Error: $message');
}

/// Thrown when user data is not found
class UserNotFoundException extends AppException {
  UserNotFoundException()
      : super('User not found. Please complete onboarding.');
}

/// Thrown when pet data is not found
class PetNotFoundException extends AppException {
  PetNotFoundException() : super('Pet not found. Please create a pet.');
}

/// Thrown when a session operation fails
class SessionException extends AppException {
  SessionException(String message) : super('Session Error: $message');
}

/// Thrown when a shop operation fails
class ShopException extends AppException {
  ShopException(String message) : super('Shop Error: $message');
}

/// Thrown when an invalid operation is attempted
class InvalidOperationException extends AppException {
  InvalidOperationException(String message)
      : super('Invalid Operation: $message');
}

/// Thrown when a permission is denied
class PermissionDeniedException extends AppException {
  PermissionDeniedException(String permission)
      : super('Permission denied: $permission');
}

/// Thrown for unknown errors
class UnknownException extends AppException {
  UnknownException(String message) : super('Unknown Error: $message');
}
