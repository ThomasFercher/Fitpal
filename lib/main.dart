import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'pages/HomePage.dart';
import 'package:fitpal/models/DatabaseHelper.dart';
import 'package:fitpal/models/SearchModel.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(accentColor: Colors.blueAccent,primaryColor: Colors.greenAccent),
      home: new HomePage(),
    );
  }
}
