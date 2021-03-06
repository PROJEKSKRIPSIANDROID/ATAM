import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mattendance/Pages/employee_main_menu.dart';
import 'package:mattendance/Pages/home_page.dart';
import 'package:mattendance/Pages/main_menu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestAbsencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RequestAbsencePage();
}

class _RequestAbsencePage extends State<RequestAbsencePage> {
  CalendarController _controller;

  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  var selectedName;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _absenceReason = <String>['Cuti', 'Izin', 'Sakit'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 240, 245, 10),
          title: Row(
            children: <Widget>[
              Text(
                "Request for Absence",
                style: TextStyle(color: Colors.black),
              )
            ],
          )),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          //padding: EdgeInsets.symmetric(horizontal: 15.0),
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.calendarDay,
                  size: 25.0,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 50.0,
                ),
                DropdownButton(
                  items: _absenceReason
                      .map((value) => DropdownMenuItem(
                            child: Text(value,
                                style: TextStyle(color: Colors.black)),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (selectedReasonName) {
                    setState(() {
                      selectedName = selectedReasonName;
                    });
                  },
                  value: selectedName,
                  isExpanded: false,
                  hint: Text('Choose your Reason Absence'),
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            TableCalendar(
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
            ),
            RaisedButton(
              child: Text('Sumbit'),
              onPressed: () {
                addToReqAbsence();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EmployeeMainMenu(),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }

  void addToReqAbsence() {

    FirebaseFirestore _db = FirebaseFirestore.instance;
    FirebaseFirestore _db2 = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    String reqReason = selectedName.toString();
    DateTime reqDate = _controller.selectedDay;

/*    Stream<QuerySnapshot> getUsername(BuildContext context) async*{
      final uid = await Provider.of(context).user.getCurrentUID();
      yield* FirebaseFirestore.instance.collection('users').doc(uid)
    }*/
/*    FutureOr getPost() async {
      var _db = FirebaseFirestore.instance;
      QuerySnapshot uname = await _db2.collection("users").where("user_id", isEqualTo: user.uid).get();
      return uname.docs;
    }*/
    final uid =  FirebaseAuth.instance.currentUser.uid;
    getName() async {
      final uid = await FirebaseAuth.instance.currentUser.uid;
      QuerySnapshot uname = await _db
          .collection("users")
          .where("user_id", isEqualTo: uid)
          .get();
      return uname.docs;
    }

    String name = user.uid.toString();
    String uname = _db2.collection("users").where("user_id", isEqualTo: name).snapshots().toString();


//DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
    DocumentReference ref = FirebaseFirestore.instance.collection('request_absence').doc(); //penambahan baru
  _db2.collection('request_absence').doc().set({
   // 'username':_db2.collection("users").where("user_id", isEqualTo: name).get(),
    'request_date': reqDate,
    'status': 'waiting',
    'reason':reqReason,
    'user_id': user.uid,
    'request_id': ref.id,  //penambahan baru
  });

/*    _db.collection('request_absence').doc().set(
        {
          'username':getName(),
          'user_id': user.uid,
          'request_date': reqDate,
          'status': 'waiting',
          'reason':reqReason,
        });*/
  }
}
