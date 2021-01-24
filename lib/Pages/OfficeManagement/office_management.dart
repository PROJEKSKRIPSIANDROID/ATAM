import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mattendance/Pages/OfficeManagement/OfficeManagementServices.dart';
import 'package:mattendance/Pages/OfficeManagement/add_edit_office.dart';

class OfficeManagement extends StatefulWidget {
  final List<Offices> listOffice = [
    Offices(
       id: 't1',
       officeName: 'MPM Finance',
       officeAddress: 'Jl. Raya',
     ),
  ];
  @override
  _OfficeManagement createState() => _OfficeManagement(this.listOffice);
}

class _OfficeManagement extends State<OfficeManagement> {
  final List<Offices> listOffice;
  _OfficeManagement(this.listOffice);

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text("Office Management", style: TextStyle(color: Colors.black),);
  String docId = "";
  String officeName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromRGBO(255, 240, 245, 10),
        title: _appBarTitle,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: new IconButton(
                  icon: _searchIcon,
                  onPressed: _searchPressed,
                ),
              ),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return {'Add New Item'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              onSelected: (choice) => addOrEditOffice('Add', context),
            ),
          ),
        ],
      ),
      body: Container(
        height: 500,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('ref_office_location').snapshots(),
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
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
                    child: ListTile(
                        leading: Icon(
                            Icons.business_rounded
                        ),
                        title: Text(document['office_name'],
                          style: Theme.of(context).textTheme.title,
                        ),
                        trailing: Wrap(
                          spacing: -5,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.black,
                              onPressed: () {
                                officeName = document['office_name'].toString();
                                docId = document.id;
                                addOrEditOffice('Edit', context);
                              }
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: (){
                                officeName = document['office_name'].toString();
                                docId = document.id;
                                deleteConfirmDialog(context);
                              },
                            ),
                          ],
                        )
                    ),
                  );
                }).toList(),
              );
            }
        ),
      )
    );
  }

  deleteConfirmDialog(BuildContext context) {

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        docId = "";
        officeName = "";
        Navigator.of(context).pop();
        },
    );
    Widget deleteButton = FlatButton(
      child: Text("Delete"),
      onPressed:  () {
        deleteOffice(docId);
        Navigator.of(context).pop();
        },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Delete Confirmation"),
      content: Text("Are you sure you want to delete $officeName?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Future<void> deleteOffice(String docId) {
    CollectionReference officeLoc = FirebaseFirestore.instance.collection('ref_office_location');
    return officeLoc
        .doc(docId)
        .delete()
        .then((value) => print("Office Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon  == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text("Office Management", style: TextStyle(color: Colors.black),);
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void addOrEditOffice(String mode, BuildContext context) {
    setState((){
      String title;
      if (mode == 'Add') {
        title = 'Add New Office';
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditOffice(pageTitle: title,)));
      }

      if(mode == 'Edit') {
        title = 'Edit Office';
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditOffice(pageTitle: title,docId: docId,)));
      }
    });
  }
}



