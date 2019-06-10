library fitpal.components;

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fitpal/models/CreateScheduleModel.dart';
import 'package:fitpal/models/Workout.dart';
import 'package:fitpal/models/Exercise.dart';

class ErrorMessage extends StatelessWidget {
  final List<String> texts;
  final Color color;

  ErrorMessage({this.texts, this.color});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
          children: texts
              .map((s) => new Text(
                    s,
                    style: TextStyle(color: color),
                  ))
              .toList()),
    );
  }
}

class ExerciseSelectionList extends StatelessWidget {
  final String filter;
  final String sort;
  final List<Exercise> exercises;
  final List<Exercise> s_exercises;
  final void Function(int i) onTap;
  final void Function(String s) changeSort;
  final void Function(String s) changeFilter;
  final void Function() submitExercises;
  final List<PopupMenuItem<String>> dropDownFilter;

  ExerciseSelectionList({
    this.sort,
    this.filter,
    this.exercises,
    this.s_exercises,
    this.onTap,
    this.changeFilter,
    this.dropDownFilter,
    this.changeSort,
    this.submitExercises,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new LayoutBuilder(builder: (context, constraints) {
      return Column(children: <Widget>[
        new Container(
          height: 55,
          margin: EdgeInsets.only(left: 15, top: 10, right: 10),
          child: new Row(children: <Widget>[
            new Expanded(
                child: new TextField(
                    decoration: new InputDecoration(
                      labelText: "Search Exercises",
                      fillColor: Colors.white,
                    ),
                    onChanged: (s) => {changeSort(s)})),
            new PopupMenuButton<String>(
              icon: const Icon(Icons.arrow_drop_down),
              onSelected: (String value) {
                changeFilter(value);
              },
              itemBuilder: (BuildContext context) {
                return dropDownFilter;
              },
            ),
          ]),
        ),
        new Container(
            height: constraints.maxHeight - 130,
            margin: EdgeInsets.all(10),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  if (filter == null || sort == null) {
                    if (filter == null && sort == null) {
                      return ExerciseSelectionTile(
                        isSelected: s_exercises.contains(exercises[index]),
                        exercise: exercises[index],
                        onTap: () => onTap(index),
                      );
                    } else if (sort == null) {
                      if (exercises[index]
                              .muscleGroup
                              .compareTo(filter.toLowerCase()) ==
                          0)
                        return ExerciseSelectionTile(
                          isSelected: s_exercises.contains(exercises[index]),
                          exercise: exercises[index],
                          onTap: () => onTap(index),
                        );
                      else
                        return new Container();
                    } else if (filter == null) {
                      if (exercises[index].exercise.contains(sort))
                        return ExerciseSelectionTile(
                          isSelected: s_exercises.contains(exercises[index]),
                          exercise: exercises[index],
                          onTap: () => onTap(index),
                        );
                      else
                        return new Container();
                    }
                  } else {
                    if (exercises[index]
                                .muscleGroup
                                .compareTo(filter.toLowerCase()) ==
                            0 &&
                        exercises[index].exercise.contains(sort))
                      return ExerciseSelectionTile(
                        isSelected: s_exercises.contains(exercises[index]),
                        exercise: exercises[index],
                        onTap: () => onTap(index),
                      );
                    else
                      return new Container();
                  }
                })),
        new Container(
            alignment: Alignment.centerRight,
            height: 35,
            child: new Container(
              width: 160,
              height: 35,
              margin: EdgeInsets.only(right: 10),
              child: new RaisedButton(
                onPressed: submitExercises,
                color: Colors.blueAccent[200],
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.add),
                    new Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: new Text("Add Exercises"),
                    )
                  ],
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50)),
              ),
            ))
      ]);
    });
  }
}

class ExerciseSelectionTile extends StatelessWidget {
  final bool isSelected;
  final void Function() onTap;
  final Exercise exercise;

  ExerciseSelectionTile({this.isSelected, this.onTap, this.exercise});

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 100,
        child: new Card(
          color: isSelected ? Colors.blueAccent[100] : Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.all(10),
                  child: new Row(
                    children: <Widget>[
                      new Column(children: <Widget>[
                        new Text("Exercise:"),
                      ]),
                      new Column(
                        children: <Widget>[new Text(exercise.exercise)],
                      )
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(10),
                  child: new Row(
                    children: <Widget>[
                      new Column(
                        children: <Widget>[new Text("Muscle Groups:")],
                      ),
                      new Column(
                        children: <Widget>[new Text(exercise.muscleGroup)],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class ExerciseListTile extends StatelessWidget {
  final Exercise exercise;
  final void Function() deleteExercise;

  ExerciseListTile({this.exercise, this.deleteExercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Container(
            height: 60,
            padding: EdgeInsets.all(5),
            // width: MediaQuery.of(context).size.width,
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Container(
                          width: (MediaQuery.of(context).size.width - 30) * 0.5,
                          child: new Text(exercise.exercise),
                        )
                      ],
                    ),
                    new Column(
                      children: <Widget>[
                        new Container(
                          width: (MediaQuery.of(context).size.width - 30) * 0.4,
                          child: new Text(exercise.muscleGroup),
                        )
                      ],
                    ),
                    new Column(children: <Widget>[
                      new Container(
                        width: (MediaQuery.of(context).size.width - 30) * 0.1,
                        child: new IconButton(
                            icon: new Icon(Icons.delete),
                            onPressed: () {
                              deleteExercise();
                            }),
                      )
                    ])
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class WorkoutPreview extends StatelessWidget {
  final Workout w;
  final void Function() changeDate;
  final void Function() editWorkout;
  final void Function() deleteWorkout;

  WorkoutPreview(
      {this.w, this.changeDate, this.editWorkout, this.deleteWorkout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return new Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.greenAccent[200],
        child: new Container(
          margin: EdgeInsets.all(5),
          child: new Column(
            children: <Widget>[
              new Container(
                width: constraints.maxWidth - 6,
                //height: 30,
                child: new Row(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        Container(
                          width: (constraints.maxWidth - 18) * 0.64,
                          alignment: Alignment.centerLeft,
                          child: new Text(w.name,
                              style: new TextStyle(
                                  color: Colors.indigoAccent[100],
                                  fontSize: 18.0,
                                  fontFamily: "RobotoMono")),
                        )
                      ],
                    ),
                    new Column(
                      children: <Widget>[
                        Container(
                          width: (constraints.maxWidth - 18) * 0.12,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => {changeDate()},
                            color: Colors.indigoAccent[100],
                          ),
                        )
                      ],
                    ),
                    new Column(
                      children: <Widget>[
                        Container(
                          width: (constraints.maxWidth - 18) * 0.12,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => editWorkout(),
                            color: Colors.indigoAccent[100],
                          ),
                        )
                      ],
                    ),
                    new Column(
                      children: <Widget>[
                        Container(
                          width: (constraints.maxWidth - 18) * 0.12,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () => deleteWorkout(),
                              color: Colors.indigoAccent[100]),
                        )
                      ],
                    )
                  ],
                ),
              ),
              new Divider(
                color: Colors.indigoAccent[100],
              ),
              new Container(
                  child: new ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: w.exercises
                          .map((Exercise e) => ExerciseTile(
                              exercise: e, constraints: constraints))
                          .toList()))
            ],
          ),
        ),
      );
    });
  }
}

class ExerciseTile extends StatelessWidget {
  final BoxConstraints constraints;
  final Exercise exercise;

  ExerciseTile({this.constraints, this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Container(
                      width: (constraints.maxWidth - 28) * 0.1,
                      child: new Icon(Icons.fiber_manual_record,
                          color: Colors.indigo[50]),
                    )
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                      width: (constraints.maxWidth - 28) * 0.45,
                      child: new Text(exercise.exercise),
                    )
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                      width: (constraints.maxWidth - 28) * 0.45,
                      child: new Text(exercise.muscleGroup),
                    )
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}

class WeekTable extends StatelessWidget {
  final void Function(int day) onDaySelected;
  final Map<DateTime, List> events;
  final int selectedDay;
  final Color dayColor;
  final Color selectedDayColor;
  final Color weekendColor;
  final Widget Function(String name) marker;

  WeekTable(
      {this.events,
      this.onDaySelected,
      this.selectedDay,
      this.dayColor,
      this.marker,
      this.selectedDayColor,
      this.weekendColor});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
        onDaySelected: (DateTime time, List<dynamic> list) =>
            {onDaySelected(time.weekday)},
        events: events,
        daysOfWeekStyle: new DaysOfWeekStyle(
            weekendStyle: TextStyle(
          color: weekendColor,
        )),
        headerVisible: false,
        initialCalendarFormat: CalendarFormat.week,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDay: DateTime.now()
            .subtract(Duration(days: DateTime.now().weekday - 1))
            .add(Duration(days: selectedDay - 1)),
        availableGestures: AvailableGestures.none,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
        ),
        builders: CalendarBuilders(
          dayBuilder: (context, date, _) {
            return new Container(
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(Radius.circular(15)),
                color: dayColor,
              ),
            );
          },
          selectedDayBuilder: (context, date, _) {
            return Container(
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(Radius.circular(15)),
                color: selectedDayColor,
              ),
            );
          },
          singleMarkerBuilder: (context, date, _) {
            return marker(_);
          },
        ));
  }
}

class DeleteDialog extends StatelessWidget {
  final void Function() onDelete;

  DeleteDialog({this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: new Text("Delete Workout?"),
      content: new Text("This will delete this Workout"),
      contentPadding: EdgeInsets.only(left: 25, top: 20),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: new Text("Cancel", style: TextStyle(color: Colors.black))),
        new FlatButton(
            onPressed: () {
              onDelete();

              Navigator.of(context).pop();
            },
            child:
                new Text("Delete", style: TextStyle(color: Colors.redAccent)))
      ],
    );
  }
}

class DateSelectDialog extends StatelessWidget {
  final void Function(int day) onSelect;
  final int day;

  DateSelectDialog({this.onSelect, this.day});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: new Container(
          height: 110,
          child: new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(5),
                child: new Text(
                  "Select Day",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TableCalendar(
                onDaySelected: (DateTime time, List<dynamic> list) =>
                    {this.onSelect(time.weekday), Navigator.of(context).pop()},
                daysOfWeekStyle: new DaysOfWeekStyle(
                    weekendStyle: TextStyle(
                  color: Colors.teal,
                )),
                headerVisible: false,
                initialCalendarFormat: CalendarFormat.week,
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDay: DateTime.now()
                    .subtract(Duration(days: DateTime.now().weekday - 1))
                    .add(Duration(days: day - 1)),
                availableGestures: AvailableGestures.none,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                ),
                builders: CalendarBuilders(
                  dayBuilder: (context, date, _) {
                    return new Container(
                      margin: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.all(Radius.circular(15)),
                        color: Colors.green[50],
                      ),
                    );
                  },
                  selectedDayBuilder: (context, date, _) {
                    return Container(
                      margin: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.all(Radius.circular(15)),
                        color: Colors.greenAccent[200],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
