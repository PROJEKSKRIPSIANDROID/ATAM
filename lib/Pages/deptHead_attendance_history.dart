import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DeptHeadAttendanceHistory extends StatefulWidget{
  @override
  _DeptHeadAttendanceHistory createState() => _DeptHeadAttendanceHistory();
}

List<dynamic> _selectedEvents = [];

class _DeptHeadAttendanceHistory extends State<DeptHeadAttendanceHistory>{
  CalendarController _controller;

  DateTime _selectedDay = DateTime.now();
  String clockIn = '-',clockOut='-',status='-';


  @override
  void initState() {
    super.initState();
    fetchEvents();
    _controller = CalendarController();
  }

  Map<DateTime, List<dynamic>> dateEvents = {};
  //List<Widget> get _eventWidgets => _selectedEvents.map((e) => attendanceHist(e)).toList();

  Widget attendanceHist(var d){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              )),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text('Clock In :'),
                Text(d,
                    style:
                    Theme.of(context).primaryTextTheme.bodyText1),
              ]) ),
    );  }


  void fetchEvents() async{
    dateEvents = {};
    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    FirebaseFirestore.instance
        .collection('attendance_history')
        .where('user_id',isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((item) {
        Timestamp timestamp = item['attendance_date'];
        DateTime formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(timestamp.toDate()));
        if(dateEvents.containsKey(formattedDate)){
          dateEvents[formattedDate].add(item.id);
        }
        else{
          dateEvents[formattedDate] = [item.id];
        }
      });
    });
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 240, 245, 10),
          title: Row(
            children: <Widget>[
              Text("My Attendance History",
                style: TextStyle(color: Colors.black),
              )
            ],
          )
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              initialCalendarFormat: CalendarFormat.week,
              calendarController: _controller,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (day, events, holidays) {
                int days = _selectedDay.weekday;
                setState(() {
                  _selectedDay = day;
                  _selectedEvents = events;

                  if(_selectedEvents.length != 0){
                    FirebaseFirestore.instance
                        .collection('attendance_history')
                        .doc(_selectedEvents[0].toString())
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      var data = documentSnapshot.data();

                      if(data['clock_in'].toString().isNotEmpty){
                        Timestamp clockInTimestamp = data['clock_in'];
                        clockIn = DateFormat('HH:mm:ss').format(clockInTimestamp.toDate()).toString();
                      }else{
                        clockIn = '-';
                      }

                      if(data['clock_out'].toString().isNotEmpty){
                        Timestamp clockInTimestamp = data['clock_out'];
                        clockOut = DateFormat('HH:mm:ss').format(clockInTimestamp.toDate()).toString();
                      }else{
                        clockOut = '-';
                      }

                      if(data['status'].toString().isNotEmpty){
                        status = data['status'].toString();
                      }else{
                        status = 'Ok';
                      }
                      AttendanceDetail();
                    });
                  }else{
                    clockIn = '-';
                    clockOut = '-';
                    status = 'Mangkir';
                  }
                });
              },
              events: dateEvents,
            ),
            AttendanceDetail(clockIn: clockIn,clockOut: clockOut,status: status,),
            //Column(children:_eventWidgets)
          ],
        ),
      ),
    );
  }
}


class AttendanceDetail extends StatelessWidget {
  final String clockIn,clockOut,status;

  AttendanceDetail({this.clockIn,this.clockOut,this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AttendanceDetailBox(text: 'Office Location',value: '-',),
          AttendanceDetailBox(text: 'Clock in',value: clockIn,),
          AttendanceDetailBox(text: 'Clock out',value: clockOut,),
          AttendanceDetailBox(text: 'Status',value: status,),
        ],
      ),
    );
  }
}


class AttendanceDetailBox extends StatelessWidget {
  final String text, value;

  AttendanceDetailBox({this.text, this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.fromLTRB(5, 3, 5, 0),
      child: ListTile(
        leading: Container(
          width: 70,
          child: Text(text,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        title: Text(':  ' + value,
          style: TextStyle(
              fontSize: 15
          ),
        ),
        dense: true,
      ),
    );
  }
}
