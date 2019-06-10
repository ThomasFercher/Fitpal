import 'package:flutter/material.dart';
import 'package:fitpal/models/DatabaseHelper.dart';
import 'package:fitpal/pages/createSchedulePage.dart';
import 'package:fitpal/models/Schedule.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'package:fitpal/models/CreateScheduleModel.dart';
import 'package:fitpal/components/Components.dart';
import 'package:fitpal/pages/ScheduleView.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  createSchedulePage create = createSchedulePage();
  CreateScheduleModel scheduleModel = new CreateScheduleModel();
  String header;

  @override
  void initState() {
    create = createSchedulePage();
    header = scheduleModel.schedule.name == null
        ? "FitPal"
        : scheduleModel.schedule.name;
    super.initState();
  }

  final dbHelper = DatabaseHelper.instance;

  void goToScheduleView(Schedule schedule) {
    scheduleModel.setSelectedSchedule(schedule);
    setState(() {
      header = schedule.name;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel<CreateScheduleModel>(
      model: scheduleModel,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(this.header),
          actions: <Widget>[
            new IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => {},
            ),
            new IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => {},
            )
          ],
        ),
        body: new ScopedModelDescendant<CreateScheduleModel>(
            builder: (context, child, model) {
          return new ScheduleView(
            schedule: model.schedule,
          );
        }),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new ExpansionTile(
                    title: new Row(
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(right: 15),
                            child: new Icon(
                              Icons.schedule,
                              color: Colors.blueAccent,
                            )),
                        new Container(child: new Text("Schedules"))
                      ],
                    ),
                    initiallyExpanded: true,
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.only(left: 55),
                          child: ScheduleList(
                            onTap: (schedule) =>
                                this.goToScheduleView(schedule),
                            loadData: _query(),
                          )),
                      new Container(
                        child: ListTile(
                          title: new Container(
                              child: new Row(
                            children: <Widget>[
                              new Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: new Icon(
                                    Icons.add,
                                    color: Colors.blueAccent,
                                  )),
                              new Text(
                                "Create new Schedule",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    this.create));
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _insert() async {
    // row to insert
    //final id = await dbHelper.insert(s.toMap());
    // print('inserted row id: $id');
  }

  Future<List<dynamic>> _query() async {
    final allRows = await dbHelper.queryAllRows();
    var list = [];
    for (Map<String, dynamic> m in allRows) {
      Map a = jsonDecode(m['schedule']);
      Schedule schedule = Schedule.fromJson(a, m['_id']);
      // print(schedule.name);
      list.add(schedule);
    }

    return list;
  }

  void _update() async {
    // row to update
    //final rowsAffected = await dbHelper.update(s.toMap());
    //  print('updated $rowsAffected row(s)');
  }

  void _delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}

class ScheduleList extends StatelessWidget {
  final Future<dynamic> loadData;
  final dbHelper = DatabaseHelper.instance;
  final void Function(Schedule schedule) onTap;

  ScheduleList({this.loadData, this.onTap});

  void delete(Schedule s, context) {
    //Todo
    //Implement Popupmenu with delete and edit options
    showDialog(
        context: context,
        builder: (context) {
          return DeleteDialog(
            onDelete: () => {this._delete(s.id)},
          );
        });
  }

  void _delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<CreateScheduleModel>(
        builder: (context, child, model) {
      return FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //  print(snapshot.data);
            var list = snapshot.data;
            return new ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ScheduleTile(
                    schedule: list[index],
                    onTap: (schedule) => onTap(schedule),
                    onDelete: (schedule) => {
                          this.delete(schedule, context),
                        });
              },
            );
          } else
            return CircularProgressIndicator();
        },
      );
    });
  }
}

class ScheduleTile extends StatelessWidget {
  final Schedule schedule;
  final void Function(Schedule schedule) onTap;
  final void Function(Schedule schedule) onEdit;
  final void Function(Schedule schedule) onDelete;

  ScheduleTile({this.schedule, this.onTap, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListTile(
        contentPadding: EdgeInsets.all(2),
        title: new Container(
          child: new Text(schedule.name),
        ),
        onTap: () => onTap(schedule),
        trailing: new Container(
          width: 52,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () => onDelete(schedule),
              ),
            ],
          ),
        ));
  }
}
