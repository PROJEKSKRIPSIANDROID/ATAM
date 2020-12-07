import 'package:flutter/material.dart';
import 'package:mattendance/Pages/login_page.dart';
import 'package:mattendance/Pages/main_menu.dart';
import 'package:mattendance/services/auth_service.dart';

AuthService appAuth = new AuthService();

//void main() => runApp(AttendanceApp());
//
//class AttendanceApp extends StatelessWidget{
//  @override
//  Widget build(BuildContext context){
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'Mobile Attendance',
//      theme: ThemeData(
//        scaffoldBackgroundColor: Colors.white
//      ),
//      home: LoginScreen(),
//    );
//  }
//}

void main() async {
  // Set default home.
  Widget _defaultHome = new LoginScreen();

  // Get result of the login function.
  bool _result = await appAuth.login();
  if (_result) {
    _defaultHome = new BottomNavBar();
  }

  // Run app!
  runApp(new MaterialApp(
    title: 'App',
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new BottomNavBar(),
      '/login': (BuildContext context) => new LoginScreen()
    },
  ));
}