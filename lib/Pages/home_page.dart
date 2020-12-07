import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 240, 245, 10),
        title: Row(
          children: <Widget>[Image.asset('assets/Logo_AdIns2019_Colour.png',height: 50,)],
        )
      ),
      body: Column(children: <Widget>[
        Container(
          child: Column(children: <Widget>[
              Row(children: <Widget>[
              ],)
            ],
          ),
        )

      ],


      )
    );
  }
}