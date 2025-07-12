// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      profile: json['profile'] == null
          ? null
          : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? null
          : UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'profile': instance.profile,
      'settings': instance.settings,
    };

const _$UserRoleEnumMap = {
  UserRole.patient: 'patient',
  UserRole.doctor: 'doctor',
  UserRole.caregiver: 'caregiver',
};

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      address: json['address'] as String?,
      phoneNumber: json['phone_number'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'gender': _$GenderEnumMap[instance.gender],
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'address': instance.address,
      'phone_number': instance.phoneNumber,
      'avatar': instance.avatar,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      timezoneId: json['timezone_id'] as String?,
      notificationPreferences: NotificationPreferences.fromJson(
          json['notification_preferences'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'timezone_id': instance.timezoneId,
      'notification_preferences': instance.notificationPreferences,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

NotificationPreferences _$NotificationPreferencesFromJson(
        Map<String, dynamic> json) =>
    NotificationPreferences(
      medicationReminders: json['medication_reminders'] as bool? ?? true,
      appointmentReminders: json['appointment_reminders'] as bool? ?? true,
      healthAlerts: json['health_alerts'] as bool? ?? true,
      emailNotifications: json['email_notifications'] as bool? ?? true,
      pushNotifications: json['push_notifications'] as bool? ?? true,
      soundEnabled: json['sound_enabled'] as bool? ?? true,
      vibrationEnabled: json['vibration_enabled'] as bool? ?? true,
      quietHoursStart: json['quiet_hours_start'] as String?,
      quietHoursEnd: json['quiet_hours_end'] as String?,
    );

Map<String, dynamic> _$NotificationPreferencesToJson(
        NotificationPreferences instance) =>
    <String, dynamic>{
      'medication_reminders': instance.medicationReminders,
      'appointment_reminders': instance.appointmentReminders,
      'health_alerts': instance.healthAlerts,
      'email_notifications': instance.emailNotifications,
      'push_notifications': instance.pushNotifications,
      'sound_enabled': instance.soundEnabled,
      'vibration_enabled': instance.vibrationEnabled,
      'quiet_hours_start': instance.quietHoursStart,
      'quiet_hours_end': instance.quietHoursEnd,
    };

Doctor _$DoctorFromJson(Map<String, dynamic> json) => Doctor(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      specialization: json['specialization'] as String,
      licenseNumber: json['license_number'] as String,
      licenseIssuingBody: json['license_issuing_body'] as String,
      clinicName: json['clinic_name'] as String?,
      clinicAddress: json['clinic_address'] as String?,
      lastActivity: json['last_activity'] == null
          ? null
          : DateTime.parse(json['last_activity'] as String),
      active: json['active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'specialization': instance.specialization,
      'license_number': instance.licenseNumber,
      'license_issuing_body': instance.licenseIssuingBody,
      'clinic_name': instance.clinicName,
      'clinic_address': instance.clinicAddress,
      'last_activity': instance.lastActivity?.toIso8601String(),
      'active': instance.active,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'user': instance.user,
    };

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'user': instance.user,
    };

Caregiver _$CaregiverFromJson(Map<String, dynamic> json) => Caregiver(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      certification: json['certification'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CaregiverToJson(Caregiver instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'certification': instance.certification,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'user': instance.user,
    };
