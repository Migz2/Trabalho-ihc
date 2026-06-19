/// Custom exception types for the Honey App
/// Used for precise error handling across the app

class AppException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' ($code)' : ''}';
}

/// Thrown when a Hive storage operation fails
class StorageException extends AppException {
  StorageException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
    message: 'Storage Error: $message',
    code: code ?? 'STORAGE_ERROR',
    stackTrace: stackTrace,
  );
}

/// Thrown when invalid data is provided
class ValidationException extends AppException {
  ValidationException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
    message: 'Validation Error: $message',
    code: code ?? 'VALIDATION_ERROR',
    stackTrace: stackTrace,
  );
}

/// Thrown when a resource is not found
class NotFoundException extends AppException {
  NotFoundException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
    message: 'Not Found: $message',
    code: code ?? 'NOT_FOUND',
    stackTrace: stackTrace,
  );
}

/// Thrown when a permission is denied
class PermissionException extends AppException {
  PermissionException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
    message: 'Permission Denied: $message',
    code: code ?? 'PERMISSION_DENIED',
    stackTrace: stackTrace,
  );
}

/// Thrown when a network operation fails
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
    message: 'Network Error: $message',
    code: code ?? 'NETWORK_ERROR',
    stackTrace: stackTrace,
  );
}

/// Thrown when an operation times out
class TimeoutException extends AppException {
  TimeoutException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
    message: 'Timeout: $message',
    code: code ?? 'TIMEOUT',
    stackTrace: stackTrace,
  );
}
