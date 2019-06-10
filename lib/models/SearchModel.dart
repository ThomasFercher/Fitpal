import 'package:scoped_model/scoped_model.dart';
import 'package:fitpal/models/Exercise.dart';

class SearchModel extends Model {
  String _filter;
  String _sort;
  List<Exercise> selectedExercises = [];

  String get filter => _filter;

  String get sort => _sort;

  get selected => selectedExercises;


  void changeFilter(String filter) {
    print(filter);
    this._filter = filter;
    notifyListeners();
  }

  void changeSort(String sort) {
    this._sort = sort;
    print(_sort);
    notifyListeners();
  }

  void selectExercise(Exercise e) {
    if (selectedExercises.contains(e))
      selectedExercises.remove(e);
    else
      selectedExercises.add(e);
    notifyListeners();
  }

  bool isSelected(Exercise e) {
    if (selectedExercises.contains(e))
      return true;
    else
      return false;
  }

}
