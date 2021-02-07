import 'dart:async';
import 'package:mattendance/Pages/RequestAbsence/request_absence_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mattendance/Pages/home_page.dart';
import 'package:mattendance/Pages/main_menu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:cool_alert/cool_alert.dart';

class AbsenceApproval extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AbsenceApproval();
}

class _AbsenceApproval extends State<AbsenceApproval> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromRGBO(255, 240, 245, 10),
        title: Row(
          children: <Widget>[
            Text(
              "Absence Approval",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
      body: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

/*class _ListPageState extends State<ListPage> {
  FutureOr getPost() async {
    var _db = FirebaseFirestore.instance;
    QuerySnapshot reqA = await _db
        .collection("request_absence")
        .where("status", isEqualTo: 'waiting')
        .get();
    return reqA.docs;
  }*/

class _ListPageState extends State<ListPage> {
  FutureOr getPost() async {
    final user =  FirebaseAuth.instance.currentUser.uid;
    var _db = FirebaseFirestore.instance;
    QuerySnapshot reqA = await _db
        .collection("request_absence")
        .where("status", isEqualTo: 'waiting')
        .get();
    return reqA.docs;
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      child: FutureBuilder(
        future: getPost(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading..."),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: FutureBuilder<dynamic>(
                      future: getUserByUserId(snapshot.data[index]['user_id']),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          if(snapshot.data.length > 1){
                            return Text('Two or more users with the same Id exists');
                          }
                          else{
                            return Text(snapshot.data[0]['username']);
                          }
                        } else {
                          return Text('User not found');
                        }
                      },
                    ),
                    subtitle: Row(
                        children: <Widget>[
                          Expanded(child: Text((DateFormat('yyyy-MM-dd').format(snapshot.data[index]['request_date'].toDate())).toString())),
                          //Expanded(child: Text(DateTime.fromMicrosecondsSinceEpoch(snapshot.data[index]['request_date'].microsecondsSinceEpoch).toString(),)),
                          Expanded(child: Text(snapshot.data[index]['reason'].toString()),),
                          Expanded(child: RaisedButton(onPressed: () {
                            setState(() {
                              String id = snapshot.data[index]['request_id'].toString();
                              // var reqAbsenceId = FirebaseFirestore.instance
                              //     .collection("request_absence")
                              //     .where("request_id", isEqualTo: id)
                              //     .get();


                              FirebaseFirestore.instance.collection('request_absence').doc(snapshot.data[index].documentID).update({
                                'status': 'approve'
                              });


                              FirebaseFirestore.instance.collection('attendance_history').doc().set({
                                'attendance_date': snapshot.data[index]['request_date'],
                                'status': snapshot.data[index]['reason'],
                                'user_id': snapshot.data[index]['user_id'],
                                'clock_in': ''.toString(),
                                'clock_out': ''.toString(),
                              });

                              //Navigator.push(context, MaterialPageRoute(builder: (context) => new AbsenceApproval()));
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                text: "Your Approve was successful!",
                              );
                            });
                          },
                            child: Text("Approve"),
                            color: Colors.blue,textColor: Colors.white,)),
                          Expanded(child: RaisedButton(onPressed: () {
                            setState(() {
                              FirebaseFirestore.instance.collection('request_absence').doc(snapshot.data[index].documentID).update({
                                'status': 'reject'
                              });

                              //Navigator.push(context, MaterialPageRoute(builder: (context) => AbsenceApproval()));

                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                text: "Your Reject was successful!",
                              );
                            });

                          },
                            child: Text("Reject"),
                            color: Colors.red,textColor: Colors.white,)),
                        ]
                    ),
                  );
                });
          }
        },
      ),
    );

  }

  Future<dynamic> getUserByUserId(String userId) async {
    return (await FirebaseFirestore.instance
        .collection("users")
        .where("user_id", isEqualTo: userId)
        .get()
    ).docs;
  }


}
