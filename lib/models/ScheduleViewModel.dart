import 'package:scoped_model/scoped_model.dart';
import 'package:fitpal/models/Workout.dart';
import 'package:fitpal/models/Schedule.dart';
import 'dart:convert';

class ScheduleViewModel extends Model {
  final Schedule schedule;
  int selected_day = DateTime
      .now()
      .weekday;
  List<Workout> rendered_workouts = [];

  //events
  static DateTime selectedDay =
  DateTime.now().subtract(Duration(days: DateTime
      .now()
      .weekday - 1));
  Map<DateTime, List<String>> events = {
    selectedDay.add(Duration(days: 0)): [],
    selectedDay.add(Duration(days: 1)): [],
    selectedDay.add(Duration(days: 2)): [],
    selectedDay.add(Duration(days: 3)): [],
    selectedDay.add(Duration(days: 4)): [],
    selectedDay.add(Duration(days: 5)): [],
    selectedDay.add(Duration(days: 6)): [],
  };

  ScheduleViewModel({this.schedule});


  void setSelected_day(int day) {
    this.selected_day = day;
    notifyListeners();
  }

  bool renderWorkouts() {
    print(selected_day);
    rendered_workouts = [];
    schedule.workouts.forEach(
            (w) => w.day == selected_day ? rendered_workouts.add(w) : null);
    return rendered_workouts.length == 0 ? false : true;
  }
}
