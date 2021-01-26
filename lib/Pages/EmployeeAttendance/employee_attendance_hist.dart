import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mattendance/Pages/EmployeeAttendance/selected_emp_hist.dart';


class EmployeeAttendanceHist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EmployeeAttendanceHist();
}


class _EmployeeAttendanceHist extends State<EmployeeAttendanceHist> {
  navigateToDetail (DocumentSnapshot post){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectedEmpHist(post: post,)));
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
              "Employee Attendance History",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),

      floatingActionButton: null,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').where('position', isEqualTo: 'employee').snapshots(),
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
                      // Expanded(child: Text(document['office'])),
                      Visibility(
                        child: Text(document['user_id']),
                        visible: false,
                      ),
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
