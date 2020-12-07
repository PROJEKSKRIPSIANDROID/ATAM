import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceHistory extends StatefulWidget{
  @override
  _AttendanceHistory createState() => _AttendanceHistory();
}

class _AttendanceHistory extends State<AttendanceHistory>{
  CalendarController _controller;
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              initialCalendarFormat: CalendarFormat.week,
              calendarController: _controller,
            startingDayOfWeek: StartingDayOfWeek.monday,
            ),
        Container(
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
                    Text("Clock in : ",
                      style:
                      Theme.of(context).primaryTextTheme.bodyText1),
                    Text("Clock out : ",style:
                    Theme.of(context).primaryTextTheme.bodyText1)
                  ]) ),
        )
        ],
        ),
      ),
    );
  }
}
