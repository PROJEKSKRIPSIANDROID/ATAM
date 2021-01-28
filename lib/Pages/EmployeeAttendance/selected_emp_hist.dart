import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectedEmpHist extends StatefulWidget {
  @override
  final DocumentSnapshot post;
  SelectedEmpHist({this.post});
  _SelectedEmpHist createState()=> _SelectedEmpHist();
}

List<dynamic> _selectedEvents = [];

class _SelectedEmpHist extends State<SelectedEmpHist> {
  @override

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

  void fetchEvents() async{
    dateEvents = {};
    var selectedUser = widget.post.data()['user_id'].toString();

    FirebaseFirestore.instance
        .collection('attendance_history')
        .where('user_id',isEqualTo: selectedUser)
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
    String currId = widget.post.data()['user_id'];
    String username = widget.post.data()['username'];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromRGBO(255, 240, 245, 10),
        title: Row(
          children: <Widget>[
            Text(
              username + "'s Attendance History",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new TableCalendar(
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
                        status = 'Work';
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
    return new Container(
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
