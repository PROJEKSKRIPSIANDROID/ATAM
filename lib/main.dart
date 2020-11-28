import 'package:flutter/material.dart';
import 'package:mattendance/Pages/login_page.dart';

void main() => runApp(AttendanceApp());

class AttendanceApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Attendance',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      home: LoginScreen(),
    );
  }
}