import 'package:scoped_model/scoped_model.dart';
import 'package:fitpal/models/Exercise.dart';

class WorkoutModel extends Model {
  List<Exercise> exercises = [];
  get selected => exercises;

  void setExercises(List<Exercise> list){
    exercises = list;

    notifyListeners();
  }

  void addExercises(List<Exercise> list){
    exercises.addAll(list);

    notifyListeners();
  }

  void removeExercise(Exercise e){
    exercises.remove(e);
    notifyListeners();
  }


}
