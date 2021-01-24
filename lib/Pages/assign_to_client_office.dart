import 'dart:async';
import 'package:mattendance/Pages/DatabaseManager.dart';
import 'package:mattendance/Pages/edit_assign.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mattendance/Pages/home_page.dart';
import 'package:mattendance/Pages/main_menu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_formatter/time_formatter.dart';

class AssignToClientOffice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AssignToClientOffice();
}


class _AssignToClientOffice extends State<AssignToClientOffice> {
  navigateToDetail (DocumentSnapshot post){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditAssign(post: post,)));
  }
  @override
  Widget build(BuildContext context) {
    int _id;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromRGBO(255, 240, 245, 10),
          title: Row(
            children: <Widget>[
              Text(
                "Assign to Client Office",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
      ),

      //new AppBar(
      //  title: Row(
      //    children: <Widget>[
      //      Text(
      //        "Assign to Client Office",
      //        style: TextStyle(color: Colors.white),
      //      )
      //    ],
      //  ),
      //),
      floatingActionButton: null,
      body: StreamBuilder(
          /*stream: FirebaseFirestore.instance.collection('users').where("position", isEqualTo: 'employee').snapshots(),*/
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data.docs.map((document){
                return ListTile(
                  onTap: () => navigateToDetail(document),
                  title: Text(document['username']),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(child: Text(document['office'])),
                      Visibility(
                        child: Text(document['user_id']),
                        visible: false,
                      ),
                      /*Expanded(child: RaisedButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditAssign()),
                        );
                      },
                        child: Text("Edit"),
                        color: Colors.blue,
                        textColor: Colors.white,)),*/
                    ],
                  ),
                );
              }).toList(),
            );
          }
      ),
    );
  }
}
