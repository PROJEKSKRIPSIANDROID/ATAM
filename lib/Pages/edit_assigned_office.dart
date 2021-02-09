import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cool_alert/cool_alert.dart';

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
                .collection('ref_office_location').orderBy('office_name')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              }
              var length = snapshot.data.docs.length;
              DocumentSnapshot ds = snapshot.data.docs[length - 1];
              _queryCat = snapshot.data.docs;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.building,
                        size: 25.0,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 50.0,
                      ),
                      Expanded(
                        child: new DropdownButtonFormField(
                          //value: _chooseOffice,
                          isDense: true,
                          hint: Text(
                            'Choose Office',
                          ),
                          validator: (value) =>
                              value == null ? 'field required' : null,
                          onChanged: (String newValue) {
                            setState(() {
                              _chooseOffice = newValue.toString();
                              print(_chooseOffice);
                            });
                          },
                          items: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return new DropdownMenuItem<String>(
                              value: document.data()['office_name'],
                              child: new Container(
                                decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                                //height: 18.0,
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
                                child: new Text(
                                  document.data()[
                                      'office_name'], /*style: textStyle*/
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      /*decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Theme.of(context).dividerColor),
                          )),*/
                    ),
                  ),
                  RaisedButton(
                    child: Text('Update'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        update();
                        Navigator.pop(
                            context
                        );
                        _formKey.currentState
                            .save(); //save once fields are valid, onSaved method invoked for every form fields
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          text: "You successful update " + widget.post.data()['username'] + " Office to " + _chooseOffice.toString() + "!"
                        );
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
