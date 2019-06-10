import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fitpal/models/CreateScheduleModel.dart';
import 'package:fitpal/models/Schedule.dart';
import 'package:fitpal/components/Components.dart';
import 'package:fitpal/models/Workout.dart';
import 'package:fitpal/models/Exercise.dart';
import 'package:fitpal/models/ScheduleViewModel.dart';

class ScheduleView extends StatelessWidget {
  final Schedule schedule;

  ScheduleView({this.schedule});

  @override
  Widget build(BuildContext context) {
    return schedule.name == null
        ? nullBuild()
        : View(
            scheduleViewModel: new ScheduleViewModel(schedule: schedule),
          );
  }

  Widget nullBuild() {
    return Container();
  }
}

class View extends StatelessWidget {
  //final Schedule schedule;
  final ScheduleViewModel scheduleViewModel;

  View({this.scheduleViewModel});

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<ScheduleViewModel>(
      model: scheduleViewModel,
      child: new Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
        // color: Colors.indigo[50],
        child: new Column(
          children: <Widget>[
            new WeekTable(
              dayColor: Colors.indigo[50],
              selectedDayColor: Colors.indigoAccent[100],
              weekendColor: Colors.indigo,
              marker: (name) => buildMarker(name),
              events: scheduleViewModel.events,
              onDaySelected: (day) => {scheduleViewModel.setSelected_day(day)},
              selectedDay: scheduleViewModel.selected_day,
            ),
            new Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: new ScopedModelDescendant<ScheduleViewModel>(
                builder: (context, child, model) {
                  return model.renderWorkouts()
                      ? new ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.rendered_workouts.length,
                          itemBuilder: (context, index) {
                            return WorkoutView(
                              workout: model.rendered_workouts[index],
                            );
                          },
                        )
                      : new Container(
                          margin: EdgeInsets.only(top: 150),
                          child: new ErrorMessage(
                            texts: ["Restday"],
                            color: Colors.blueGrey,
                          ),
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMarker(String name) {
    return Container(
      transform: Matrix4.translationValues(0.0, -7.5, 0.0),
      child: Icon(
          name == "done" ? Icons.done : name == "todo" ? Icons.event : Icons.block),
    );
  }
}

class WorkoutView extends StatelessWidget {
  final Workout workout;

  WorkoutView({this.workout});

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.only(top: 20),
        child: LayoutBuilder(builder: (context, constraints) {
          return new Card(
            color: Colors.indigoAccent[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: new Container(
              padding: EdgeInsets.all(10),
              child: new Column(
                children: <Widget>[
                  new Container(
                    width: constraints.maxWidth - 11,
                    //height: 30,
                    child: new Row(
                      children: <Widget>[
                        Container(
                          width: (constraints.maxWidth - 28) * 0.5,
                          alignment: Alignment.centerLeft,
                          child: new Text(workout.name,
                              style: new TextStyle(
                                  color: Colors.indigo[50],
                                  fontSize: 18.0,
                                  fontFamily: "RobotoMono")),
                        ),
                        new Container(
                          margin: EdgeInsets.only(
                              left: (constraints.maxWidth - 28) * 0.5 - 48),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.indigo),
                          width: 48,
                          height: 48,
                          child: new IconButton(
                            color: Colors.indigo[50],
                            padding: EdgeInsets.all(0),
                            onPressed: () => {},
                            icon: Icon(Icons.play_arrow),
                          ),
                        )
                      ],
                    ),
                  ),
                  new Divider(
                    color: Colors.indigo,
                  ),
                  new Container(
                    child: new ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: workout.exercises
                            .map((Exercise e) => ExerciseTile(
                                exercise: e, constraints: constraints))
                            .toList()),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
