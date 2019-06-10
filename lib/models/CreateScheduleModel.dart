import 'package:scoped_model/scoped_model.dart';
import 'package:fitpal/models/Workout.dart';
import 'package:fitpal/models/Schedule.dart';
import 'dart:convert';

class CreateScheduleModel extends Model {
  Schedule schedule = new Schedule(workouts: []);
  int day = DateTime.now().weekday;

  static DateTime selectedDay =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  Map<DateTime, List> events = {
    selectedDay.add(Duration(days: 0)): [],
    selectedDay.add(Duration(days: 1)): [],
    selectedDay.add(Duration(days: 2)): [],
    selectedDay.add(Duration(days: 3)): [],
    selectedDay.add(Duration(days: 4)): [],
    selectedDay.add(Duration(days: 5)): [],
    selectedDay.add(Duration(days: 6)): [],
  };

  get workouts => schedule.workouts;

  void selectDay(int day) {
    this.day = day;
  }

  void setSelectedSchedule(Schedule schedule) {
    this.schedule = schedule;
    notifyListeners();
  }

  Schedule getSchedule() {
    return this.schedule;
  }

  void setWorkouts(List<Workout> list) {
    schedule.workouts = list;
    notifyListeners();
  }

  void removeWorkout(Workout w) {
    schedule.workouts.remove(w);
    events[selectedDay.add(Duration(days: w.day - 1))].remove(w.name);
    notifyListeners();
  }

  void addWorkout(Workout w) {
    schedule.workouts.add(w);
    events[selectedDay.add(Duration(days: w.day - 1))].add(w.name);
    notifyListeners();
  }

  void editWorkout(Workout editWorkout, Workout newWorkout) {
    schedule.workouts[workouts.indexOf(editWorkout)] = newWorkout;
    notifyListeners();
  }

  void changeDateOfWorkout(Workout w, int day) {
    events[selectedDay.add(Duration(days: w.day - 1))].remove(w.name);
    schedule.workouts[workouts.indexOf(w)].day = day;
    events[selectedDay.add(Duration(days: day - 1))].add(w.name);
    this.day = day;
    notifyListeners();
  }
}
