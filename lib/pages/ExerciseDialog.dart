import 'package:flutter/material.dart';
import 'package:fitpal/models/Exercise.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fitpal/models/SearchModel.dart';
import 'package:fitpal/models/WorkoutModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fitpal/components/Components.dart';

class ExerciseDialog extends StatelessWidget {
  var items = [' biceps', ' chest', 'abdominals'];
  final WorkoutModel workoutModel;
  final SearchModel model = new SearchModel();

  ExerciseDialog({@required this.workoutModel});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SearchModel>(
      model: model,
      child: Dialog(
          shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: FutureBuilder(
            future: getExercises(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ScopedModelDescendant<SearchModel>(
                    builder: (context, child, model) {
                  return new ExerciseSelectionList(
                    exercises: snapshot.data,
                    changeFilter: (s) => model.changeFilter(s),
                    changeSort: (s) => model.changeSort(s),
                    filter: model.filter,
                    sort: model.sort,
                    onTap: (index) => model.selectExercise(snapshot.data[index]),
                    s_exercises: model.selectedExercises,
                    submitExercises: () => submitExercises(context),
                    dropDownFilter: dropDownFilter(),

                  );
                });
              } else
                return new Container(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
            },
          )),
    );
  }

  Future<String> loadExercise() async {
    return await rootBundle.loadString('assets/exercises.json');
  }

  Future<List<Exercise>> getExercises() async {
    List<Exercise> exercises = [];
    String jsonString = await loadExercise();
    final jsonResponse = json.decode(jsonString);
    for (var value in jsonResponse) {
      Exercise e = new Exercise.fromList(value);
      exercises.add(e);
    }
    return exercises;
  }

  List<PopupMenuItem<String>> dropDownFilter() {
    return items.map<PopupMenuItem<String>>((String value) {
      return new PopupMenuItem(child: new Text(value), value: value);
    }).toList();
  }

  void submitExercises(context) {
    workoutModel.addExercises(model.selected);

    model.selectedExercises = [];
    Navigator.of(context).pop();
  }

}
