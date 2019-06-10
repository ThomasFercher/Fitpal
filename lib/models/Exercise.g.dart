// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return Exercise(
      exercise: json['exercise'] as String,
      muscleGroup: json['muscleGroup'] as String);
}

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'exercise': instance.exercise,
      'muscleGroup': instance.muscleGroup
    };
