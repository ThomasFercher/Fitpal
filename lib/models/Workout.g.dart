// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workout _$WorkoutFromJson(Map<String, dynamic> json) {
  return Workout(
      name: json['name'] as String,
      exercises: (json['exercises'] as List)
          ?.map((e) =>
              e == null ? null : Exercise.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      day: json['day'] as int);
}

Map<String, dynamic> _$WorkoutToJson(Workout instance) => <String, dynamic>{
      'name': instance.name,
      'day': instance.day,
      'exercises': instance.exercises
    };
