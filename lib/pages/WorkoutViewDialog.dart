import 'package:flutter/material.dart';
import 'package:fitpal/models/Workout.dart';
import 'package:fitpal/models/Exercise.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sticky_headers/sticky_headers.dart';

class WorkoutViewDialog extends StatelessWidget {
  Workout workout;

  WorkoutViewDialog({@required this.workout});

  Widget ExerciseTile(
      {@required Exercise exercise, BoxConstraints constraints}) {
    return Card(
      child: InkWell(
        child: Container(
            height: 100,
            padding: EdgeInsets.all(5),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Container(
                          width: (constraints.maxWidth - 8 - 16) * 0.5,
                          child: new Text(exercise.exercise),
                        )
                      ],
                    ),
                    new Column(
                      children: <Widget>[
                        new Container(
                          width: (constraints.maxWidth - 8 - 16) * 0.5,
                          child: new Text(exercise.muscleGroup),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Container(
        height: (workout.exercises.length + 1) * 100.0,
        child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: new LayoutBuilder(builder: (context, constraints) {
              return new Container(
                  margin: EdgeInsets.all(3),
                  child: new Column(
                    children: <Widget>[
                      new Text("test"),
                      new ListView(
                          shrinkWrap: true,
                          children: workout.exercises
                              .map((Exercise e) => ExerciseTile(
                                  exercise: e, constraints: constraints))
                              .toList())
                    ],
                  ));
            })),
      ),
    );
  }
}
