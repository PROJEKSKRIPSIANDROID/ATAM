import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///D:/Skripsi Ghifari/aplikasi/ATAM/lib/Pages/OfficeManagement/office_management.dart';
import 'package:mattendance/main.dart';

class ProfileScreen extends StatelessWidget {
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
                    child: Text('Profile',style: TextStyle(fontSize: 25)),
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
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0,0 ),
                    child: Text('Radhitya Dimas Purwanta',style: TextStyle(fontSize: 25)),
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
                  child: Text('Client Office Management',style: TextStyle(color: Colors.white,fontSize: 20),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OfficeManagement()));//authenticationBloc.dispatch(LoggedOut());
                  },
                )
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
                            child: Text("Yes"),
                          onPressed: () {
                            appAuth.logout().then(
                                    (_) => Navigator.of(context).pushReplacementNamed('/login'));
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

