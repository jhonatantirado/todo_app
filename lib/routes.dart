import 'package:flutter/material.dart';
import 'package:todo_app/screen/login/login_screen.dart';
import 'package:todo_app/screen/home/home_screen.dart';

final routes = {
  '/login':         (BuildContext context) => new LoginScreen(),
  '/home':         (BuildContext context) => new HomeScreen(),
  '/' :          (BuildContext context) => new LoginScreen(),
};