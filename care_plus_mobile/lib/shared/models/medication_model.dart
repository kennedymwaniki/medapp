import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'medication_model.g.dart';

/// Medication status enum
enum MedicationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('taken')
  taken,
  @JsonValue('missed')
  missed,
  @JsonValue('skipped')
  skipped,
}

/// Medication tracker status
enum TrackerStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('expired')
  expired,
  @JsonValue('paused')
  paused,
}

/// Snooze status
enum SnoozeStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('dismissed')
  dismissed,
}

/// Medication form model
@JsonSerializable()
class MedicationForm extends Equatable {
  final String id;
  final String name;

  const MedicationForm({required this.id, required this.name});

  factory MedicationForm.fromJson(Map<String, dynamic> json) =>
      _$MedicationFormFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationFormToJson(this);

  @override
  List<Object?> get props => [id, name];
}

/// Medication unit model
@JsonSerializable()
class MedicationUnit extends Equatable {
  final String id;
  final String name;

  const MedicationUnit({required this.id, required this.name});

  factory MedicationUnit.fromJson(Map<String, dynamic> json) =>
      _$MedicationUnitFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationUnitToJson(this);

  @override
  List<Object?> get props => [id, name];
}

/// Medication route model
@JsonSerializable()
class MedicationRoute extends Equatable {
  final String id;
  final String name;

  const MedicationRoute({required this.id, required this.name});

  factory MedicationRoute.fromJson(Map<String, dynamic> json) =>
      _$MedicationRouteFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationRouteToJson(this);

  @override
  List<Object?> get props => [id, name];
}

/// Medication frequency model
@JsonSerializable()
class MedicationFrequency extends Equatable {
  final String id;
  final String name;
  @JsonKey(name: 'times_per_day')
  final int timesPerDay;
  @JsonKey(name: 'interval_hours')
  final int intervalHours;

  const MedicationFrequency({
    required this.id,
    required this.name,
    required this.timesPerDay,
    required this.intervalHours,
  });

  factory MedicationFrequency.fromJson(Map<String, dynamic> json) =>
      _$MedicationFrequencyFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationFrequencyToJson(this);

  @override
  List<Object?> get props => [id, name, timesPerDay, intervalHours];
}

/// Main medication model
@JsonSerializable()
class Medication extends Equatable {
  final String id;
  @JsonKey(name: 'patient_id')
  final String patientId;
  @JsonKey(name: 'diagnosis_id')
  final String? diagnosisId;
  @JsonKey(name: 'medication_name')
  final String medicationName;
  @JsonKey(name: 'dosage_quantity')
  final double dosageQuantity;
  @JsonKey(name: 'dosage_strength')
  final String dosageStrength;
  @JsonKey(name: 'form_id')
  final String formId;
  @JsonKey(name: 'unit_id')
  final String unitId;
  @JsonKey(name: 'route_id')
  final String routeId;
  final String frequency;
  final String? duration;
  @JsonKey(name: 'prescribed_date')
  final DateTime prescribedDate;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  @JsonKey(name: 'caregiver_id')
  final String? caregiverId;
  final int stock;
  final bool active;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  // Related models
  final Patient? patient;
  final Doctor? doctor;
  final Caregiver? caregiver;
  final MedicationForm? form;
  final MedicationUnit? unit;
  final MedicationRoute? route;
  final List<MedicationSchedule>? schedules;

  const Medication({
    required this.id,
    required this.patientId,
    this.diagnosisId,
    required this.medicationName,
    required this.dosageQuantity,
    required this.dosageStrength,
    required this.formId,
    required this.unitId,
    required this.routeId,
    required this.frequency,
    this.duration,
    required this.prescribedDate,
    this.doctorId,
    this.caregiverId,
    required this.stock,
    this.active = true,
    required this.createdAt,
    required this.updatedAt,
    this.patient,
    this.doctor,
    this.caregiver,
    this.form,
    this.unit,
    this.route,
    this.schedules,
  });

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationToJson(this);

  Medication copyWith({
    String? id,
    String? patientId,
    String? diagnosisId,
    String? medicationName,
    double? dosageQuantity,
    String? dosageStrength,
    String? formId,
    String? unitId,
    String? routeId,
    String? frequency,
    String? duration,
    DateTime? prescribedDate,
    String? doctorId,
    String? caregiverId,
    int? stock,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
    Patient? patient,
    Doctor? doctor,
    Caregiver? caregiver,
    MedicationForm? form,
    MedicationUnit? unit,
    MedicationRoute? route,
    List<MedicationSchedule>? schedules,
  }) {
    return Medication(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      diagnosisId: diagnosisId ?? this.diagnosisId,
      medicationName: medicationName ?? this.medicationName,
      dosageQuantity: dosageQuantity ?? this.dosageQuantity,
      dosageStrength: dosageStrength ?? this.dosageStrength,
      formId: formId ?? this.formId,
      unitId: unitId ?? this.unitId,
      routeId: routeId ?? this.routeId,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      prescribedDate: prescribedDate ?? this.prescribedDate,
      doctorId: doctorId ?? this.doctorId,
      caregiverId: caregiverId ?? this.caregiverId,
      stock: stock ?? this.stock,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      patient: patient ?? this.patient,
      doctor: doctor ?? this.doctor,
      caregiver: caregiver ?? this.caregiver,
      form: form ?? this.form,
      unit: unit ?? this.unit,
      route: route ?? this.route,
      schedules: schedules ?? this.schedules,
    );
  }

  /// Get formatted dosage string
  String get formattedDosage {
    return '$dosageQuantity ${unit?.name ?? ''} $dosageStrength';
  }

  /// Check if medication is low in stock
  bool get isLowStock {
    return stock <= 5; // Consider low stock if 5 or fewer doses remaining
  }

  /// Check if medication is out of stock
  bool get isOutOfStock {
    return stock <= 0;
  }

  @override
  List<Object?> get props => [
    id,
    patientId,
    diagnosisId,
    medicationName,
    dosageQuantity,
    dosageStrength,
    formId,
    unitId,
    routeId,
    frequency,
    duration,
    prescribedDate,
    doctorId,
    caregiverId,
    stock,
    active,
    createdAt,
    updatedAt,
  ];
}

/// Medication schedule model
@JsonSerializable()
class MedicationSchedule extends Equatable {
  final String id;
  @JsonKey(name: 'medication_id')
  final String medicationId;
  @JsonKey(name: 'scheduled_time')
  final DateTime scheduledTime;
  final MedicationStatus status;
  @JsonKey(name: 'actual_taken_time')
  final DateTime? actualTakenTime;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  // Related models
  final Medication? medication;

  const MedicationSchedule({
    required this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.status = MedicationStatus.pending,
    this.actualTakenTime,
    required this.createdAt,
    required this.updatedAt,
    this.medication,
  });

  factory MedicationSchedule.fromJson(Map<String, dynamic> json) =>
      _$MedicationScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationScheduleToJson(this);

  MedicationSchedule copyWith({
    String? id,
    String? medicationId,
    DateTime? scheduledTime,
    MedicationStatus? status,
    DateTime? actualTakenTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    Medication? medication,
  }) {
    return MedicationSchedule(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      actualTakenTime: actualTakenTime ?? this.actualTakenTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      medication: medication ?? this.medication,
    );
  }

  /// Check if medication is overdue
  bool get isOverdue {
    return status == MedicationStatus.pending &&
        DateTime.now().isAfter(scheduledTime.add(const Duration(minutes: 30)));
  }

  /// Check if medication is due soon (within next 15 minutes)
  bool get isDueSoon {
    final now = DateTime.now();
    final timeDifference = scheduledTime.difference(now);
    return status == MedicationStatus.pending &&
        timeDifference.inMinutes <= 15 &&
        timeDifference.inMinutes >= 0;
  }

  @override
  List<Object?> get props => [
    id,
    medicationId,
    scheduledTime,
    status,
    actualTakenTime,
    createdAt,
    updatedAt,
  ];
}

/// Medication tracker model
@JsonSerializable()
class MedicationTracker extends Equatable {
  final String id;
  @JsonKey(name: 'medication_id')
  final String medicationId;
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @JsonKey(name: 'stop_date')
  final DateTime? stopDate;
  final TrackerStatus status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  // Related models
  final Medication? medication;

  const MedicationTracker({
    required this.id,
    required this.medicationId,
    required this.startDate,
    this.stopDate,
    this.status = TrackerStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.medication,
  });

  factory MedicationTracker.fromJson(Map<String, dynamic> json) =>
      _$MedicationTrackerFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationTrackerToJson(this);

  MedicationTracker copyWith({
    String? id,
    String? medicationId,
    DateTime? startDate,
    DateTime? stopDate,
    TrackerStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Medication? medication,
  }) {
    return MedicationTracker(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      startDate: startDate ?? this.startDate,
      stopDate: stopDate ?? this.stopDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      medication: medication ?? this.medication,
    );
  }

  @override
  List<Object?> get props => [
    id,
    medicationId,
    startDate,
    stopDate,
    status,
    createdAt,
    updatedAt,
  ];
}

/// Medication snooze model
@JsonSerializable()
class MedicationSnooze extends Equatable {
  final String id;
  @JsonKey(name: 'medication_schedule_id')
  final String medicationScheduleId;
  @JsonKey(name: 'original_time')
  final DateTime originalTime;
  @JsonKey(name: 'snooze_time')
  final DateTime snoozeTime;
  @JsonKey(name: 'snooze_duration')
  final int snoozeDuration; // in minutes
  final SnoozeStatus status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  // Related models
  final MedicationSchedule? medicationSchedule;

  const MedicationSnooze({
    required this.id,
    required this.medicationScheduleId,
    required this.originalTime,
    required this.snoozeTime,
    required this.snoozeDuration,
    this.status = SnoozeStatus.pending,
    required this.createdAt,
    required this.updatedAt,
    this.medicationSchedule,
  });

  factory MedicationSnooze.fromJson(Map<String, dynamic> json) =>
      _$MedicationSnoozeFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationSnoozeToJson(this);

  MedicationSnooze copyWith({
    String? id,
    String? medicationScheduleId,
    DateTime? originalTime,
    DateTime? snoozeTime,
    int? snoozeDuration,
    SnoozeStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    MedicationSchedule? medicationSchedule,
  }) {
    return MedicationSnooze(
      id: id ?? this.id,
      medicationScheduleId: medicationScheduleId ?? this.medicationScheduleId,
      originalTime: originalTime ?? this.originalTime,
      snoozeTime: snoozeTime ?? this.snoozeTime,
      snoozeDuration: snoozeDuration ?? this.snoozeDuration,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      medicationSchedule: medicationSchedule ?? this.medicationSchedule,
    );
  }

  @override
  List<Object?> get props => [
    id,
    medicationScheduleId,
    originalTime,
    snoozeTime,
    snoozeDuration,
    status,
    createdAt,
    updatedAt,
  ];
}
