import 'dart:async';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mattendance/Pages/home_page.dart';
import 'package:mattendance/Pages/main_menu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_formatter/time_formatter.dart';

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
                    title: Text(snapshot.data[index]['username']),
                    subtitle: Row(
                      children: <Widget>[

                        //Expanded(child: Text(formatTime(snapshot.data[index]['request_date'].toDate())),),
                        Expanded(child: Text(DateTime.fromMicrosecondsSinceEpoch(snapshot.data[index]['request_date'].microsecondsSinceEpoch).toString(),)),
                        Expanded(child: Text(snapshot.data[index]['reason'].toString()),),
                        Expanded(child: RaisedButton(onPressed: () {},child: Text("Approve"),color: Colors.blue,textColor: Colors.white,)),
                        Expanded(child: RaisedButton(onPressed: () {

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
}

class DetailPage extends StatefulWidget{
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>{
  @override
  Widget build(BuildContext context){
    return Container();
  }
}
