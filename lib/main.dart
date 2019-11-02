import 'package:flutter/material.dart';
import 'package:todo_app/routes.dart';
import 'package:todo_app/common/app_constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
        primarySwatch: AppConstants.primaryColor,
      ),
      routes: routes,
    );
  }
}
