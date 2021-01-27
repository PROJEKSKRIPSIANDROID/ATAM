import 'dart:async';
//import 'dart:html';
import 'package:mattendance/Pages/assign_to_client_office.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:mattendance/Pages/main_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditAssign extends StatefulWidget {
  @override
  final DocumentSnapshot post;
  EditAssign({this.post});
  _EditAssign createState()=> _EditAssign();
  // State<StatefulWidget> createState() => new _EditAssign();
}

class _EditAssign extends State<EditAssign> {
  var _chooseOffice;
  var newLat;
  var _queryCat;
  CalendarController _controller;

  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    String currId = widget.post.data()['user_id'];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromRGBO(255, 240, 245, 10),
        title: Row(
          children: <Widget>[
            Text(
              "Edit Assign to Client Office",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
      body: new StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('ref_office_location').snapshots(),
          builder: (context, snapshot){
            if(snapshot.data == null){
              return CircularProgressIndicator();
            }
            var length = snapshot.data.docs.length;
            DocumentSnapshot ds = snapshot.data.docs[length - 1];
            _queryCat = snapshot.data.docs;
            return new Container(
              padding: EdgeInsets.only(bottom: 16.0),
              //         width: screenSize.width*0.9,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                      //flex: 2,
                      child: new Container(
                       /* height: 200,*/
                        padding: EdgeInsets.fromLTRB(12.0,10.0,10.0,10.0),
                        child: new Text("Client Office", style: TextStyle(fontSize: 16.0),/*,style: textStyleBlueBold,*/),
                      )
                  ),
                  new Expanded(
                    //flex: 4,
                    child:new InputDecorator(
                      decoration: const InputDecoration(
                        //labelText: 'Activity',
                        hintText: 'Choose Office',
                        hintStyle: TextStyle(
                         // color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      isEmpty: _chooseOffice == null,
                      child: new DropdownButton(
                        //value: _chooseOffice,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _chooseOffice = newValue.toString();
                            //dropDown = false;
                            print(_chooseOffice);
                          });
                        },
                        items: snapshot.data.docs.map((DocumentSnapshot document) {
                          return new DropdownMenuItem<String>(
                              value: document.data()['office_name'],
                              child: new Container(
                                decoration: new BoxDecoration(
                                  /*                           color: primaryColor,*/
                                    borderRadius: new BorderRadius.circular(5.0)
                                ),
                                height: 100.0,
                                padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
                                //color: primaryColor,
                                child: new Text(document.data()['office_name'],/*style: textStyle*/),
                              ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Update'),
                    onPressed: () {
                      FirebaseFirestore _db = FirebaseFirestore.instance;
                      FirebaseFirestore _db2 = FirebaseFirestore.instance;
                      FirebaseAuth _auth = FirebaseAuth.instance;
                      final user = _auth.currentUser;

                      String selectedOffice = _chooseOffice.toString();
                      String lat = newLat.toString();
/*
                      getData() {
                        return  FirebaseFirestore.instance.collection('client_office').where('office_name', isEqualTo: selectedOffice ).snapshots();
                      }

                      var a = FirebaseFirestore.instance.collection('client_office').where('office_name', isEqualTo: selectedOffice ).snapshots();
*/

                      // getData().then((val){
                      //   {
                      //     print(val.docs[0].data()["lat"]);
                      //     _db2.collection("users").doc(currId).update({
                      //       'office': selectedOffice,
                      //       'lat': val.docs[0].data()["lat"]
                      //     });
                      //   }
                      // });


                      _db2.collection("users").doc(currId).update({
                        'office': selectedOffice,
                      });

                      Navigator.of(context).pop();
                    },
                  )

                  /*TableCalendar(
                    initialCalendarFormat: CalendarFormat.week,
                    calendarController: _controller,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                  ),
                  Container(
                    //padding: EdgeInsets.symmetric(horizontal: 15.0),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Theme.of(context).dividerColor),
                          )),
                    ),
                  ),*/
                ],
              ),
            );
          }
      ),
    );
  }
}
