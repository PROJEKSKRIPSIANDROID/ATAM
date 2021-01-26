import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mattendance/Pages/EmployeeAttendance/employee_attendance_hist.dart';

class SelectedEmpHist extends StatefulWidget {
  @override
  final DocumentSnapshot post;
  SelectedEmpHist({this.post});
  _SelectedEmpHist createState()=> _SelectedEmpHist();
}


class _SelectedEmpHist extends State<SelectedEmpHist> {
  @override
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
    );
  }

}