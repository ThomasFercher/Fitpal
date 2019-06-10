import 'package:fitpal/models/Exercise.dart';
import 'package:fitpal/models/DatabaseHelper.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Workout.g.dart';

@JsonSerializable()

class Workout {
  String name = "";
  int day;
  List<Exercise> exercises = [];

  Workout({this.name, this.exercises,this.day});


  factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutToJson(this);
}
