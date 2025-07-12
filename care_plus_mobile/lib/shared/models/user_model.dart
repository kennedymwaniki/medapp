import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// User roles enum
enum UserRole {
  @JsonValue('patient')
  patient,
  @JsonValue('doctor')
  doctor,
  @JsonValue('caregiver')
  caregiver,
}

/// Gender enum
enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('other')
  other,
}

/// User model representing the core user information
@JsonSerializable()
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final UserProfile? profile;
  final UserSettings? settings;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.profile,
    this.settings,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserProfile? profile,
    UserSettings? settings,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profile: profile ?? this.profile,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    emailVerifiedAt,
    createdAt,
    updatedAt,
    profile,
    settings,
  ];
}

/// User profile model with extended information
@JsonSerializable()
class UserProfile extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final Gender? gender;
  @JsonKey(name: 'date_of_birth')
  final DateTime? dateOfBirth;
  final String? address;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? avatar;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.userId,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.phoneNumber,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? id,
    String? userId,
    Gender? gender,
    DateTime? dateOfBirth,
    String? address,
    String? phoneNumber,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Calculate age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    gender,
    dateOfBirth,
    address,
    phoneNumber,
    avatar,
    createdAt,
    updatedAt,
  ];
}

/// User settings model for app preferences
@JsonSerializable()
class UserSettings extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'timezone_id')
  final String? timezoneId;
  @JsonKey(name: 'notification_preferences')
  final NotificationPreferences notificationPreferences;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const UserSettings({
    required this.id,
    required this.userId,
    this.timezoneId,
    required this.notificationPreferences,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  UserSettings copyWith({
    String? id,
    String? userId,
    String? timezoneId,
    NotificationPreferences? notificationPreferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timezoneId: timezoneId ?? this.timezoneId,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    timezoneId,
    notificationPreferences,
    createdAt,
    updatedAt,
  ];
}

/// Notification preferences model
@JsonSerializable()
class NotificationPreferences extends Equatable {
  @JsonKey(name: 'medication_reminders')
  final bool medicationReminders;
  @JsonKey(name: 'appointment_reminders')
  final bool appointmentReminders;
  @JsonKey(name: 'health_alerts')
  final bool healthAlerts;
  @JsonKey(name: 'email_notifications')
  final bool emailNotifications;
  @JsonKey(name: 'push_notifications')
  final bool pushNotifications;
  @JsonKey(name: 'sound_enabled')
  final bool soundEnabled;
  @JsonKey(name: 'vibration_enabled')
  final bool vibrationEnabled;
  @JsonKey(name: 'quiet_hours_start')
  final String? quietHoursStart;
  @JsonKey(name: 'quiet_hours_end')
  final String? quietHoursEnd;

  const NotificationPreferences({
    this.medicationReminders = true,
    this.appointmentReminders = true,
    this.healthAlerts = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPreferencesToJson(this);

  NotificationPreferences copyWith({
    bool? medicationReminders,
    bool? appointmentReminders,
    bool? healthAlerts,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) {
    return NotificationPreferences(
      medicationReminders: medicationReminders ?? this.medicationReminders,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      healthAlerts: healthAlerts ?? this.healthAlerts,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  @override
  List<Object?> get props => [
    medicationReminders,
    appointmentReminders,
    healthAlerts,
    emailNotifications,
    pushNotifications,
    soundEnabled,
    vibrationEnabled,
    quietHoursStart,
    quietHoursEnd,
  ];
}

/// Doctor model with specialized information
@JsonSerializable()
class Doctor extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String specialization;
  @JsonKey(name: 'license_number')
  final String licenseNumber;
  @JsonKey(name: 'license_issuing_body')
  final String licenseIssuingBody;
  @JsonKey(name: 'clinic_name')
  final String? clinicName;
  @JsonKey(name: 'clinic_address')
  final String? clinicAddress;
  @JsonKey(name: 'last_activity')
  final DateTime? lastActivity;
  final bool active;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final User? user;

  const Doctor({
    required this.id,
    required this.userId,
    required this.specialization,
    required this.licenseNumber,
    required this.licenseIssuingBody,
    this.clinicName,
    this.clinicAddress,
    this.lastActivity,
    this.active = true,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorToJson(this);

  Doctor copyWith({
    String? id,
    String? userId,
    String? specialization,
    String? licenseNumber,
    String? licenseIssuingBody,
    String? clinicName,
    String? clinicAddress,
    DateTime? lastActivity,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return Doctor(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      specialization: specialization ?? this.specialization,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseIssuingBody: licenseIssuingBody ?? this.licenseIssuingBody,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      lastActivity: lastActivity ?? this.lastActivity,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    specialization,
    licenseNumber,
    licenseIssuingBody,
    clinicName,
    clinicAddress,
    lastActivity,
    active,
    createdAt,
    updatedAt,
    user,
  ];
}

/// Patient model
@JsonSerializable()
class Patient extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final User? user;

  const Patient({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  Map<String, dynamic> toJson() => _$PatientToJson(this);

  Patient copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return Patient(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [id, userId, createdAt, updatedAt, user];
}

/// Caregiver model
@JsonSerializable()
class Caregiver extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String? certification;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final User? user;

  const Caregiver({
    required this.id,
    required this.userId,
    this.certification,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Caregiver.fromJson(Map<String, dynamic> json) =>
      _$CaregiverFromJson(json);
  Map<String, dynamic> toJson() => _$CaregiverToJson(this);

  Caregiver copyWith({
    String? id,
    String? userId,
    String? certification,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return Caregiver(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      certification: certification ?? this.certification,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    certification,
    createdAt,
    updatedAt,
    user,
  ];
}
