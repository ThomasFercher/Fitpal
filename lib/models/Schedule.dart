import 'package:fitpal/models/Exercise.dart';
import 'package:fitpal/models/DatabaseHelper.dart';
import 'package:fitpal/models/Workout.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Schedule.g.dart';

@JsonSerializable()

class Schedule {
  String name = "";
  int id;
  List<Workout> workouts = [];

  Schedule({this.name, this.workouts,this.id});


  factory Schedule.fromJson(Map<String, dynamic> json, int id) => _$ScheduleFromJson(json, id);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
