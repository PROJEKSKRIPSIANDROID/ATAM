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


  void fetchEvents(){
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
  }

  Future<DocumentSnapshot> getAttendanceDetail() async {
    DocumentSnapshot doc;
    if(_selectedEvents.length > 0){
      return (await FirebaseFirestore.instance
          .collection('attendance_history')
          .doc(_selectedEvents[0].toString())
          .get());
    }else if(_selectedDay.weekday == 6 || _selectedDay.weekday == 7 || (_selectedDay.month == 1 && _selectedDay.day == 7)){
      clockIn = '-';
      clockOut = '-';
      status = 'OFF';
      return doc;
    }else{
      clockIn = '-';
      clockOut = '-';
      status = 'Mangkir';
      return doc;
    }
  }

  Widget build(BuildContext context) {
    String currId = widget.post.data()['user_id'];
    String username = widget.post.data()['username'];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromRGBO(255, 240, 245, 10),
        title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              username + " Attendance History",
              style: TextStyle(color: Colors.black),
            )
        ),
        /*title: Row(
          children: <Widget>[
            Text(
              username + "'s Attendance History",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),*/
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
                });
              },
              events: dateEvents,
            ),
            FutureBuilder(
                future: getAttendanceDetail(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                  if (snapshot.hasData) {
                    if(_selectedEvents.length != 0){
                      var data = snapshot.data;

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
                      return AttendanceDetail(clockIn: clockIn,clockOut: clockOut,status: status,);
                    }else{
                      return AttendanceDetail(clockIn: clockIn,clockOut: clockOut,status: status,);
                    }
                  }
                  else{
                    if(_selectedEvents.length == 0){
                      return AttendanceDetail(clockIn: clockIn,clockOut: clockOut,status: status,);
                    }
                    else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                }),
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
