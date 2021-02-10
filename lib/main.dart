import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mattendance/Pages/attendance_history_screen.dart';
import 'package:mattendance/Pages/employee_main_menu.dart';
import 'package:mattendance/Pages/home_page.dart';
import 'package:mattendance/Pages/login_page.dart';
import 'package:mattendance/Pages/main_menu.dart';
import 'package:mattendance/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mattendance/services/auth_helper.dart';
import 'Package:mattendance/Pages/RequestAbsence/request_absence_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.blue,
        accentColor: Colors.blueAccent,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      routes: <String, WidgetBuilder>{
        // Set routes for using the Navigator.
        '/home': (BuildContext context) => new BottomNavBar(),
        '/login': (BuildContext context) => new LoginScreen()
      },
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (ctx, userSnapshot) {
        if (userSnapshot.hasData) {
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("users").doc(userSnapshot.data.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              if(snapshot.hasData && snapshot.data != null ){
                final user = snapshot.data.data();
                if(user['position'] == 'deptHead'){
                  return BottomNavBar();
                }else{
                  return EmployeeMainMenu();
                }
              }else {
                return Material(
                  child: Center(child: CircularProgressIndicator(),),
                );
              }
            },
          );
        }
        return LoginScreen();
      }),
      builder: EasyLoading.init(),
    );
  }
}
/*
class MainScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData && snapshot.data != null)
          {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("users").doc(snapshot.data.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                if(snapshot.hasData && snapshot.data != null ){
                  final user = snapshot.data.data();
                  if(user['position'] == 'deptHead'){
                    Navigator.of(context).pushReplacementNamed('/home');
                  }else{
                    Navigator.of(context).pushReplacementNamed('/home');
                  }
                }else {
                  return Material(
                    child: Center(child: CircularProgressIndicator(),),
                  );
                }
              },
            );
          }
          return LoginScreen();
        }
    );
  }
}*/
