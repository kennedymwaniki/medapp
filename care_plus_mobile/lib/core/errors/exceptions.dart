/// Custom exceptions for the Care Plus application
class AppException implements Exception {
  final String message;
  final int? code;

  const AppException({required this.message, this.code});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Server exceptions
class ServerException extends AppException {
  const ServerException({required String message, int? code})
    : super(message: message, code: code);
}

/// Network exceptions
class NetworkException extends AppException {
  const NetworkException({required String message, int? code})
    : super(message: message, code: code);
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException({required String message, int? code})
    : super(message: message, code: code);
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException({required String message, int? code})
    : super(message: message, code: code);
}

/// Cache exceptions
class CacheException extends AppException {
  const CacheException({required String message, int? code})
    : super(message: message, code: code);
}

/// Database exceptions
class DatabaseException extends AppException {
  const DatabaseException({required String message, int? code})
    : super(message: message, code: code);
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException({required String message, int? code})
    : super(message: message, code: code);
}

/// Biometric exceptions
class BiometricException extends AppException {
  const BiometricException({required String message, int? code})
    : super(message: message, code: code);
}

/// Medication exceptions
class MedicationException extends AppException {
  const MedicationException({required String message, int? code})
    : super(message: message, code: code);
}

/// Health data exceptions
class HealthDataException extends AppException {
  const HealthDataException({required String message, int? code})
    : super(message: message, code: code);
}

/// Notification exceptions
class NotificationException extends AppException {
  const NotificationException({required String message, int? code})
    : super(message: message, code: code);
}

/// File/Image exceptions
class FileException extends AppException {
  const FileException({required String message, int? code})
    : super(message: message, code: code);
}

/// OCR/Camera exceptions
class OCRException extends AppException {
  const OCRException({required String message, int? code})
    : super(message: message, code: code);
}
