import 'package:mattendance/Pages/MonitoringEmployee/employee_location.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MonitoringEmployeeLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MonitoringEmployeeLocation();
}


class _MonitoringEmployeeLocation extends State<MonitoringEmployeeLocation> {
  navigateToDetail (DocumentSnapshot post){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeLocation(post: post,)));
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
              "Monitoring Employee Location",
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
