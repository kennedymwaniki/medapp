/// App-wide constants for Care Plus Healthcare Management App
class AppConstants {
  // App Information
  static const String appName = 'Care Plus';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Healthcare Management Mobile Application';

  // API Configuration
  static const String baseUrl = 'https://api.careplus.com/v1';
  static const String apiTimeout = '30'; // seconds

  // Database Configuration
  static const String localDbName = 'care_plus_local.db';
  static const int dbVersion = 1;

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String userRoleKey = 'user_role';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String notificationSettingsKey = 'notification_settings';

  // User Roles
  static const String patientRole = 'patient';
  static const String doctorRole = 'doctor';
  static const String caregiverRole = 'caregiver';

  // Medication Constants
  static const List<String> medicationForms = [
    'Tablet',
    'Capsule',
    'Liquid',
    'Injection',
    'Topical',
    'Inhaler',
    'Drops',
    'Patch',
  ];

  static const List<String> medicationUnits = [
    'mg',
    'g',
    'ml',
    'IU',
    'drops',
    'puffs',
    'tablets',
    'capsules',
  ];

  static const List<String> medicationRoutes = [
    'Oral',
    'Topical',
    'Injection',
    'Inhalation',
    'Sublingual',
    'Rectal',
    'Ophthalmic',
    'Otic',
  ];

  // Notification Constants
  static const String medicationChannelId = 'medication_reminders';
  static const String medicationChannelName = 'Medication Reminders';
  static const String medicationChannelDescription =
      'Notifications for medication reminders';

  static const String appointmentChannelId = 'appointments';
  static const String appointmentChannelName = 'Appointments';
  static const String appointmentChannelDescription =
      'Notifications for appointments';

  static const String healthChannelId = 'health_alerts';
  static const String healthChannelName = 'Health Alerts';
  static const String healthChannelDescription =
      'Important health notifications';

  // Time Constants
  static const List<int> snoozeOptions = [5, 10, 15, 30]; // minutes
  static const int defaultReminderMinutes = 15;
  static const int maxMissedDoses = 3;

  // Health Vitals Ranges
  static const Map<String, Map<String, double>> vitalRanges = {
    'bloodPressure': {
      'systolicMin': 90.0,
      'systolicMax': 140.0,
      'diastolicMin': 60.0,
      'diastolicMax': 90.0,
    },
    'heartRate': {'min': 60.0, 'max': 100.0},
    'temperature': {'min': 36.1, 'max': 37.5},
  };

  // Error Messages
  static const String networkErrorMessage =
      'Please check your internet connection';
  static const String serverErrorMessage =
      'Server error. Please try again later';
  static const String unauthorizedMessage =
      'Session expired. Please login again';
  static const String validationErrorMessage =
      'Please check your input and try again';

  // Success Messages
  static const String medicationTakenMessage = 'Medication marked as taken';
  static const String profileUpdatedMessage = 'Profile updated successfully';
  static const String passwordChangedMessage = 'Password changed successfully';

  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Image Configuration
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png'];

  // Security
  static const int maxLoginAttempts = 5;
  static const int lockoutDurationMinutes = 30;
  static const int sessionTimeoutMinutes = 60;

  // Chart Configuration
  static const int maxChartDataPoints = 50;
  static const List<String> chartColors = [
    '#2196F3', // Blue
    '#4CAF50', // Green
    '#FF9800', // Orange
    '#F44336', // Red
    '#9C27B0', // Purple
    '#00BCD4', // Cyan
  ];
}
