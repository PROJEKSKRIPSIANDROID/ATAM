import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GeneralSetting extends StatefulWidget {
  @override
  _GeneralSettingState createState() => _GeneralSettingState();
}

class _GeneralSettingState extends State<GeneralSetting> {

  String docId;

  Future<String> inputDialog(BuildContext context,String inputTitle){

    TextEditingController textController = TextEditingController();
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text(inputTitle),
        content: TextField(
          keyboardType: TextInputType.number,
          controller: textController,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Submit'),
            onPressed: (){
              FirebaseFirestore _db = FirebaseFirestore.instance;
              _db.collection("general_setting").doc(docId).update({
                'dtm_upd': DateTime.now(),
                'usr_crt': FirebaseAuth.instance.currentUser.uid,
                'setting_value': textController.text,
              });

              Navigator.of(context).pop();
            },
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromRGBO(255, 240, 245, 10),
          title: Text('General Setting',style: TextStyle(color: Colors.black),),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('general_setting').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData){
                return Container(
                    color: Colors.red,
                    height: 200,
                    width: 200,
                    child: Text("No Data"));
              }
              return ListView(
                children: snapshot.data.docs.map((document) {
                  return FlatButton(
                    onPressed: () {
                      docId = document.id;
                      inputDialog(context, document['setting_name'].toString());
                    },
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
                      child: ListTile(
                          title: Text(document['setting_name'].toString(),
                            style: Theme.of(context).textTheme.title,
                          ),
                          trailing: Text((() {
                            if(document['setting_name'].toString() == 'Set Circle Radius'){
                              return document['setting_value'].toString() + ' Meters';}

                            return document['setting_value'].toString();
                          })())
                      ),
                    ),
                  );
                }).toList(),
              );
            }
        ),
    );
  }
}
