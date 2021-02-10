import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mattendance/Pages/EmployeeAttendance/employee_attendance_hist.dart';
import 'package:mattendance/Pages/MonitoringEmployee/monitoring_employee_location.dart';
import 'package:mattendance/Pages/OfficeManagement/office_management.dart';
import 'package:mattendance/Pages/attendance_history_screen.dart';
import 'package:mattendance/Pages/main_menu.dart';
import 'package:mattendance/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue[600],
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10 ),
                    child: Text('Profile',style: TextStyle(fontSize: 25)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/Logo_AdIns2019_Colour.png'),
                    ),
                    SizedBox(width: 10)
                  ],
                ),
                Align(
                  // child: Padding(
                  //   padding: EdgeInsets.fromLTRB(0, 10, 0,0 ),
                  //   child: Text('Radhitya Dimas Purwanta',style: TextStyle(fontSize: 25)),
                  // ),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').where('user_id', isEqualTo: FirebaseAuth.instance.currentUser.uid).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if(!snapshot.hasData){
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListBody(
                            children: snapshot.data.docs.map((document){
                              return Center(
                                //padding: EdgeInsets.fromLTRB(0, 10, 0,0 ),
                                child: Text(document['username'],style: TextStyle(fontSize: 25)),
                              );
                            }).toList(),
                          );
                        }
                    )
                ),
              ],
            ),
          ),

          Container(
            width: 360,
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: FlatButton(
                  color: Colors.blue[600],
                  padding: EdgeInsets.symmetric(vertical: 16,horizontal: 40),
                  child: Text('My Attendance History',style: TextStyle(color: Colors.white,fontSize: 20),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceHistory()));//authenticationBloc.dispatch(LoggedOut());
                  },
                )
            ),
          ),

          Container(
            width: 360,
            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: FlatButton(
                  color: Colors.blue[600],
                  padding: EdgeInsets.symmetric(vertical: 16,horizontal: 40),
                  child: Text('Client Office Management',style: TextStyle(color: Colors.white,fontSize: 20),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OfficeManagement()));//authenticationBloc.dispatch(LoggedOut());
                  },
                )
            ),
          ),

          Container(
            width: 360,
            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: FlatButton(
                  color: Colors.blue[600],
                  padding: EdgeInsets.symmetric(vertical: 16,horizontal: 40),
                  child: Text('Monitoring Employee Location',style: TextStyle(color: Colors.white,fontSize: 20),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MonitoringEmployeeLocation()));//authenticationBloc.dispatch(LoggedOut());
                  },
                )
            ),
          ),

          Container(
            width: 360,
            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: FlatButton(
                  color: Colors.blue[600],
                  padding: EdgeInsets.symmetric(vertical: 16,horizontal: 40),
                  child: Text('Employee Attendance History',style: TextStyle(color: Colors.white,fontSize: 20),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeAttendanceHist()));//authenticationBloc.dispatch(LoggedOut());
                  },
                )
            ),
          ),

          Container(
            width: 360,
            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: FlatButton(
                color: Colors.blue[600],
                padding: EdgeInsets.symmetric(vertical: 16,horizontal: 40),
                child: Text('Sign Out',style: TextStyle(color: Colors.white,fontSize: 20),),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text("Sign Out?"),
                        content: Text("Are you sure you want to sign out?"),
                        actions: [
                          CupertinoDialogAction(
                            child: Text("No"),
                            onPressed: () {Navigator.of(context).pop();},),
                          CupertinoDialogAction(
                            child: Text("Yes",style: TextStyle(color: Colors.red),),
                          onPressed: () {
                            _signOut();
                            Navigator.popUntil(context, ModalRoute.withName("/"));
                          })
                        ],
                    )
                  );                   //authenticationBloc.dispatch(LoggedOut());
                },
              )
            ),
          )
        ],
      ),
    );
  }

  Future <void> _signOut()  async{
    await FirebaseAuth.instance.signOut();
    //return BottomNavBar();
  }

  Future getPost() async {
    final user =  FirebaseAuth.instance.currentUser.uid;
    var _db = FirebaseFirestore.instance;
    QuerySnapshot reqA = await _db
        .collection("users").doc(user).collection('request_absence')
        .where("status", isEqualTo: 'waiting')
        .get();
    return reqA.docs;
  }
}

