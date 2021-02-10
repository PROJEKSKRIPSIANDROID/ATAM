import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mattendance/Pages/OfficeManagement/office_management.dart';
import 'package:mattendance/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue[600],
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10 ),
                    child: Text('Profile',style: TextStyle(fontSize: 25, color: Colors.black)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/Logo_AdIns2019_Colour.png'),
                    ),
                    SizedBox(width: 10)
                  ],
                ),
                Align(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').where('user_id', isEqualTo: FirebaseAuth.instance.currentUser.uid).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(!snapshot.hasData){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListBody(
                          children: snapshot.data.docs.map((document){
                            return Center(
                              //padding: EdgeInsets.fromLTRB(0, 10, 0,0 ),
                              child: Text(document['username'],style: TextStyle(fontSize: 25)),
                            );
                          }).toList(),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 360,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: FlatButton(
                  color: Colors.blue[600],
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                  child: Text('Sign Out',style: TextStyle(color: Colors.white,fontSize: 20),),
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text("Sign Out?"),
                          content: Text("Are you sure you want to sign out?"),
                          actions: [
                            CupertinoDialogAction(
                              child: Text("No"),
                              onPressed: () {Navigator.of(context).pop();},),
                            CupertinoDialogAction(
                                child: Text("Yes",style: TextStyle(color: Colors.red),),
                                onPressed: () {
                                  FirebaseAuth.instance.signOut().then(
                                          (_) => Navigator.popUntil(context, ModalRoute.withName("/")));
                                })
                          ],
                        )
                    );                   //authenticationBloc.dispatch(LoggedOut());
                  },
                )
            ),
          )
        ],
      ),
    );
  }
}

