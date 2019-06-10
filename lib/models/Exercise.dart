import 'package:fitpal/models/DatabaseHelper.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Exercise.g.dart';

@JsonSerializable()

class Exercise {
  String exercise;
  String muscleGroup;


  Exercise({this.exercise, this.muscleGroup});

  factory Exercise.fromList(Map<String, dynamic> parsedJson){
    return Exercise(
        exercise : parsedJson["exercise"],
        muscleGroup : parsedJson["muscle group"],
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}
