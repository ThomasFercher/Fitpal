// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json, int id) {
  return Schedule(
      name: json['name'] as String,
      workouts: (json['workouts'] as List)
          ?.map((e) =>
              e == null ? null : Workout.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      id: id);
}

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'workouts': instance.workouts,
    };
