import 'package:flutter/material.dart';
import 'package:fitpal/models/Exercise.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fitpal/components/Components.dart';
import 'package:fitpal/models/CreateScheduleModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fitpal/pages/ExerciseDialog.dart';
import 'package:fitpal/models/WorkoutModel.dart';
import 'package:fitpal/models/Workout.dart';
import 'package:dragable_flutter_list/dragable_flutter_list.dart';

class createWorkout extends StatefulWidget {
  CreateScheduleModel sModel;
  int day;
  Workout workout;

  createWorkout({Key key, this.sModel, this.day, this.workout})
      : super(key: key);

  @override
  _createWorkout createState() =>
      new _createWorkout(sModel: sModel, day: day, editWorkout: workout);
}

class _createWorkout extends State<createWorkout> {
  var wmodel;
  var sModel;
  var name;
  var day;
  var color;
  Workout editWorkout;
  ExerciseDialog exerciseDialog;
  TextEditingController txt;

  final _formKey = GlobalKey<FormState>();

  _createWorkout({@required this.sModel, this.day, this.editWorkout});

  @override
  void initState() {
    wmodel = new WorkoutModel();
    exerciseDialog = new ExerciseDialog(workoutModel: wmodel);
    if (editWorkout != null) wmodel.setExercises(editWorkout.exercises);
    name = editWorkout != null ? editWorkout.name : "";
    txt = new TextEditingController();
    txt.text = editWorkout != null ? editWorkout.name : "";
    color = Colors.black26;
    super.initState();
  }

  void deleteExercise(Exercise e) {
    wmodel.removeExercise(e);
  }

  void showExerciseDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return exerciseDialog;
      },
    );
  }

  void createWorkout() {
    if (_formKey.currentState.validate() && wmodel.exercises.length != 0) {
      Workout w = new Workout(
          name: this.name, exercises: wmodel.exercises, day: this.day);
      //print(wmodel.exercises);
      (editWorkout != null)
          ? sModel.editWorkout(editWorkout, w)
          : sModel.addWorkout(w);
      Navigator.pop(context);
    } else {
      setState(() {
        color = Colors.red[700];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
          title: new Text("Create Workout"),
          backgroundColor: Colors.greenAccent,
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.file_upload), onPressed: createWorkout)
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => {this.showExerciseDialog(context)},
            child: new Icon(Icons.add)),
        body: new ScopedModel<WorkoutModel>(
          model: wmodel,
          child: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.all(10),
                  child: new TextFormField(
                    controller: txt,
                    decoration: InputDecoration(
                      labelText: "Workoutname",
                    ),
                    onFieldSubmitted: (value) => setState(() {
                          name = value;
                        }),
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a Name';
                    },
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ScopedModelDescendant<WorkoutModel>(
                      builder: (context, child, model) {
                    return (model.exercises.length == 0)
                        ? new Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.30),
                            child: new ErrorMessage(
                                color: color,
                                texts: [
                                  "No Exercises selected",
                                  "Add some by clicking the button below"
                                ]),
                          )
                        : new DragAndDropList(
                            model.exercises.length,
                            itemBuilder: (context, index) {
                              return ExerciseListTile(
                                  exercise: model.exercises[index],
                                  deleteExercise: () =>
                                      deleteExercise(model.exercises[index]));
                            },
                            canBeDraggedTo: (one, two) => true,
                            onDragFinish: (before, after) {
                              print('on drag finish $before $after');
                              Exercise data = model.exercises[before];
                              model.exercises.removeAt(before);
                              model.exercises.insert(after, data);
                            },
                            dragElevation: 8.0,
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
