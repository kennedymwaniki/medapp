import 'package:equatable/equatable.dart';

/// Base class for all application failures
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// Database-related failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// Biometric authentication failures
class BiometricFailure extends Failure {
  const BiometricFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// Medication-related failures
class MedicationFailure extends Failure {
  const MedicationFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// Health data failures
class HealthDataFailure extends Failure {
  const HealthDataFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// Notification failures
class NotificationFailure extends Failure {
  const NotificationFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// File/Image related failures
class FileFailure extends Failure {
  const FileFailure({required String message, int? code})
    : super(message: message, code: code);
}

/// OCR/Camera related failures
class OCRFailure extends Failure {
  const OCRFailure({required String message, int? code})
    : super(message: message, code: code);
}
