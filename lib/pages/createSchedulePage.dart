import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fitpal/pages/createWorkout.dart';
import 'package:fitpal/models/CreateScheduleModel.dart';
import 'package:fitpal/models/Workout.dart';
import 'package:fitpal/models/Schedule.dart';
import 'package:fitpal/components/Components.dart';
import 'dart:convert';
import 'package:fitpal/models/DatabaseHelper.dart';

class createSchedulePage extends StatefulWidget {
  @override
  _createSchedulePage createState() => new _createSchedulePage();
}

class _createSchedulePage extends State<createSchedulePage>
    with SingleTickerProviderStateMixin {
  static final formKey = new GlobalKey<FormState>();
  var sModel = new CreateScheduleModel();
  final dbHelper = DatabaseHelper.instance;


  void submitSchedule() async {
    //  Schedule schedule = new Schedule(name: name, workouts: sModel.workouts);
    Map<String, dynamic> row = {
      'schedule': jsonEncode(sModel.schedule).toString(),
    };
    final id = await dbHelper.insert(row);
    Navigator.of(context).pop();
  }

  void editWorkout(Workout w) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            new createWorkout(sModel: sModel, day: sModel.day, workout: w)));
  }

  void changeDate(Workout w) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DateSelectDialog(
              day: w.day,
              onSelect: (int weekday) {
                sModel.changeDateOfWorkout(w, weekday);
              });
        });
  }

  void deleteWorkout(Workout w) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteDialog(
            onDelete: () => {sModel.removeWorkout(w)},
          );
        });
  }

  Widget _buildWeekTable() {
    return new ScopedModelDescendant<CreateScheduleModel>(
        builder: (context, child, model) {
      return WeekTable(
        marker: (name) => markerBuilder(name),
        weekendColor: Colors.teal,
        selectedDayColor: Colors.tealAccent[200],
        dayColor: Colors.teal[50],
        selectedDay: sModel.day,
        events: model.events,
        onDaySelected: (int weekDay) => sModel.selectDay(weekDay),
      );
    });
  }

  Widget markerBuilder(String name) {
    return Text(name);
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: formKey,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Create Schedule"),
          backgroundColor: Colors.greenAccent,
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.file_upload),
                onPressed: () => submitSchedule())
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new createWorkout(sModel: sModel, day: sModel.day)))
                },
            child: new Icon(Icons.add)),
        body: new Form(
          child: new Container(
            margin: EdgeInsets.all(15),
            child: new ScopedModel(
              model: sModel,
              child: new Column(children: <Widget>[
                new Container(
                  child: new TextField(
                    decoration: const InputDecoration(
                      labelText: "Schedule Name",
                    ),
                    onChanged: (input) => sModel.schedule.name=input,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(top: 20),
                  child: _buildWeekTable(),
                ),
                new Divider(
                  color: Colors.black,
                  height: 50,
                ),
                new Expanded(
                    child: new Container(
                  padding: EdgeInsets.only(top: 0),
                  child: _buildWorkoutList(context),
                ))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutList(context) {
    return ScopedModelDescendant<CreateScheduleModel>(
        builder: (context, child, model) {
      return new ListView.builder(
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return model.workouts[index].day == sModel.day
              ? new WorkoutPreview(
                  w: model.workouts[index],
                  changeDate: () => {changeDate(model.workouts[index])},
                  deleteWorkout: () => {deleteWorkout(model.workouts[index])},
                  editWorkout: () => {editWorkout(model.workouts[index])})
              : new Container(
                  padding: EdgeInsets.only(top: 100),
                  child: new ErrorMessage(
                    texts: [
                      "No Exercises on this day",
                      "Add by clicking the button below"
                    ],
                    color: Colors.black26,
                  ));
        },
        itemCount: model.workouts.length,
      );
    });
  }
}
