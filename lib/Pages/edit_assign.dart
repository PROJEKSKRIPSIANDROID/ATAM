import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAssign extends StatefulWidget {
  @override
  final DocumentSnapshot post;

  EditAssign({this.post});

  _EditAssign createState() => _EditAssign();
// State<StatefulWidget> createState() => new _EditAssign();
}

class _EditAssign extends State<EditAssign> {
  var _chooseOffice;
  var newLat;
  var _queryCat;
  CalendarController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    String currId = widget.post.data()['user_id'];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromRGBO(255, 240, 245, 10),
        title: Row(
          children: <Widget>[
            Text(
              "Edit Assign to Client Office",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: new StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('ref_office_location')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              }
              var length = snapshot.data.docs.length;
              DocumentSnapshot ds = snapshot.data.docs[length - 1];
              _queryCat = snapshot.data.docs;
              return Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(
                      "Client Office",
                      style: TextStyle(
                          fontSize: 16.0), /*,style: textStyleBlueBold,*/
                    ),
                  ),
                  new Expanded(
                    child: new InputDecorator(
                      decoration: const InputDecoration(
                        hintText: 'Choose Office',
                        hintStyle: TextStyle(
                          // color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      isEmpty: _chooseOffice == null,
                      child: new DropdownButtonFormField(
                        //value: _chooseOffice,
                        isDense: true,
                        validator: (value) =>
                        value == null ? 'field required' : null,
                        onChanged: (String newValue) {
                          setState(() {
                            _chooseOffice = newValue.toString();
                            print(_chooseOffice);
                          });
                        },
                        items: snapshot.data.docs.map((DocumentSnapshot document) {
                          return new DropdownMenuItem<String>(
                            value: document.data()['office_name'],
                            child: new Container(
                              decoration: new BoxDecoration(
                                /*                           color: primaryColor,*/
                                  borderRadius: new BorderRadius.circular(5.0)),
                              //height: 18.0,
                              padding:
                                    EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
                              //color: primaryColor,
                              child: new Text(
                                document
                                    .data()['office_name'], /*style: textStyle*/
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Update'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        update();
                        Navigator.of(context).pop();
                        _formKey.currentState
                            .save(); //save once fields are valid, onSaved method invoked for every form fields

                      } else {
                        setState(() {
                          _autovalidate = true; //enable realtime validation
                        });
                      }
                    },
                  )
                ],
              );
            }),
      ),
    );
  }

  void update() {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    FirebaseFirestore _db2 = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    String currId = widget.post.data()['user_id'];

    String selectedOffice = _chooseOffice.toString();
    String lat = newLat.toString();

    _db2.collection("users").doc(currId).update({
      'office': selectedOffice,
    });
  }
}
