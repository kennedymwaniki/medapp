// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicationForm _$MedicationFormFromJson(Map<String, dynamic> json) =>
    MedicationForm(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$MedicationFormToJson(MedicationForm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MedicationUnit _$MedicationUnitFromJson(Map<String, dynamic> json) =>
    MedicationUnit(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$MedicationUnitToJson(MedicationUnit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MedicationRoute _$MedicationRouteFromJson(Map<String, dynamic> json) =>
    MedicationRoute(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$MedicationRouteToJson(MedicationRoute instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MedicationFrequency _$MedicationFrequencyFromJson(Map<String, dynamic> json) =>
    MedicationFrequency(
      id: json['id'] as String,
      name: json['name'] as String,
      timesPerDay: (json['times_per_day'] as num).toInt(),
      intervalHours: (json['interval_hours'] as num).toInt(),
    );

Map<String, dynamic> _$MedicationFrequencyToJson(
        MedicationFrequency instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'times_per_day': instance.timesPerDay,
      'interval_hours': instance.intervalHours,
    };

Medication _$MedicationFromJson(Map<String, dynamic> json) => Medication(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      diagnosisId: json['diagnosis_id'] as String?,
      medicationName: json['medication_name'] as String,
      dosageQuantity: (json['dosage_quantity'] as num).toDouble(),
      dosageStrength: json['dosage_strength'] as String,
      formId: json['form_id'] as String,
      unitId: json['unit_id'] as String,
      routeId: json['route_id'] as String,
      frequency: json['frequency'] as String,
      duration: json['duration'] as String?,
      prescribedDate: DateTime.parse(json['prescribed_date'] as String),
      doctorId: json['doctor_id'] as String?,
      caregiverId: json['caregiver_id'] as String?,
      stock: (json['stock'] as num).toInt(),
      active: json['active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      patient: json['patient'] == null
          ? null
          : Patient.fromJson(json['patient'] as Map<String, dynamic>),
      doctor: json['doctor'] == null
          ? null
          : Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
      caregiver: json['caregiver'] == null
          ? null
          : Caregiver.fromJson(json['caregiver'] as Map<String, dynamic>),
      form: json['form'] == null
          ? null
          : MedicationForm.fromJson(json['form'] as Map<String, dynamic>),
      unit: json['unit'] == null
          ? null
          : MedicationUnit.fromJson(json['unit'] as Map<String, dynamic>),
      route: json['route'] == null
          ? null
          : MedicationRoute.fromJson(json['route'] as Map<String, dynamic>),
      schedules: (json['schedules'] as List<dynamic>?)
          ?.map((e) => MedicationSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MedicationToJson(Medication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patient_id': instance.patientId,
      'diagnosis_id': instance.diagnosisId,
      'medication_name': instance.medicationName,
      'dosage_quantity': instance.dosageQuantity,
      'dosage_strength': instance.dosageStrength,
      'form_id': instance.formId,
      'unit_id': instance.unitId,
      'route_id': instance.routeId,
      'frequency': instance.frequency,
      'duration': instance.duration,
      'prescribed_date': instance.prescribedDate.toIso8601String(),
      'doctor_id': instance.doctorId,
      'caregiver_id': instance.caregiverId,
      'stock': instance.stock,
      'active': instance.active,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'patient': instance.patient,
      'doctor': instance.doctor,
      'caregiver': instance.caregiver,
      'form': instance.form,
      'unit': instance.unit,
      'route': instance.route,
      'schedules': instance.schedules,
    };

MedicationSchedule _$MedicationScheduleFromJson(Map<String, dynamic> json) =>
    MedicationSchedule(
      id: json['id'] as String,
      medicationId: json['medication_id'] as String,
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      status: $enumDecodeNullable(_$MedicationStatusEnumMap, json['status']) ??
          MedicationStatus.pending,
      actualTakenTime: json['actual_taken_time'] == null
          ? null
          : DateTime.parse(json['actual_taken_time'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      medication: json['medication'] == null
          ? null
          : Medication.fromJson(json['medication'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicationScheduleToJson(MedicationSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medication_id': instance.medicationId,
      'scheduled_time': instance.scheduledTime.toIso8601String(),
      'status': _$MedicationStatusEnumMap[instance.status]!,
      'actual_taken_time': instance.actualTakenTime?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'medication': instance.medication,
    };

const _$MedicationStatusEnumMap = {
  MedicationStatus.pending: 'pending',
  MedicationStatus.taken: 'taken',
  MedicationStatus.missed: 'missed',
  MedicationStatus.skipped: 'skipped',
};

MedicationTracker _$MedicationTrackerFromJson(Map<String, dynamic> json) =>
    MedicationTracker(
      id: json['id'] as String,
      medicationId: json['medication_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      stopDate: json['stop_date'] == null
          ? null
          : DateTime.parse(json['stop_date'] as String),
      status: $enumDecodeNullable(_$TrackerStatusEnumMap, json['status']) ??
          TrackerStatus.active,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      medication: json['medication'] == null
          ? null
          : Medication.fromJson(json['medication'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicationTrackerToJson(MedicationTracker instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medication_id': instance.medicationId,
      'start_date': instance.startDate.toIso8601String(),
      'stop_date': instance.stopDate?.toIso8601String(),
      'status': _$TrackerStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'medication': instance.medication,
    };

const _$TrackerStatusEnumMap = {
  TrackerStatus.active: 'active',
  TrackerStatus.completed: 'completed',
  TrackerStatus.expired: 'expired',
  TrackerStatus.paused: 'paused',
};

MedicationSnooze _$MedicationSnoozeFromJson(Map<String, dynamic> json) =>
    MedicationSnooze(
      id: json['id'] as String,
      medicationScheduleId: json['medication_schedule_id'] as String,
      originalTime: DateTime.parse(json['original_time'] as String),
      snoozeTime: DateTime.parse(json['snooze_time'] as String),
      snoozeDuration: (json['snooze_duration'] as num).toInt(),
      status: $enumDecodeNullable(_$SnoozeStatusEnumMap, json['status']) ??
          SnoozeStatus.pending,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      medicationSchedule: json['medicationSchedule'] == null
          ? null
          : MedicationSchedule.fromJson(
              json['medicationSchedule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicationSnoozeToJson(MedicationSnooze instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medication_schedule_id': instance.medicationScheduleId,
      'original_time': instance.originalTime.toIso8601String(),
      'snooze_time': instance.snoozeTime.toIso8601String(),
      'snooze_duration': instance.snoozeDuration,
      'status': _$SnoozeStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'medicationSchedule': instance.medicationSchedule,
    };

const _$SnoozeStatusEnumMap = {
  SnoozeStatus.pending: 'pending',
  SnoozeStatus.dismissed: 'dismissed',
};
