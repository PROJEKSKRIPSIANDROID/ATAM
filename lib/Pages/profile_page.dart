import 'package:flutter/material.dart';

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

          Container(),
          Container(
            width: 360,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              color: Colors.blue[600]
            ),
            child: Center(
              child: FlatButton(
                child: Text('Sign Out',style: TextStyle(color: Colors.white,fontSize: 20),),
                onPressed: (){
                  //authenticationBloc.dispatch(LoggedOut());
                },
              )
            )
            ,
          )
        ],
      ),
    );
  }
}

