import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeLocation extends StatefulWidget {
  @override
  final DocumentSnapshot post;
  EmployeeLocation({this.post});
  _EmployeeLocation createState()=> _EmployeeLocation();
}


class _EmployeeLocation extends State<EmployeeLocation> {
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
              username + "'s Location",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

}