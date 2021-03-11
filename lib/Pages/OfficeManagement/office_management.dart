import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mattendance/Pages/OfficeManagement/add_edit_office.dart';
import 'package:mattendance/model/officeDataModel.dart';

class OfficeManagement extends StatefulWidget {
  @override
  _OfficeManagement createState() => _OfficeManagement();
}

class _OfficeManagement extends State<OfficeManagement> {
  final TextEditingController _filter = new TextEditingController();
  List<QueryDocumentSnapshot> listOffice;
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text("Office Management", style: TextStyle(color: Colors.black),);
  String docId = "";
  String officeName = "";

  _OfficeManagement() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = listOffice;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

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
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: getOfficeData(),
          builder: (context, snapshot) {
            if(listOffice == null){
              return Container(
                  color: Colors.red,
                  height: 200,
                  width: 200,
                  child: Text("Loading .. "));
            }else if(listOffice.isEmpty){
              return Container(
                  color: Colors.red,
                  height: 200,
                  width: 200,
                  child: Text("No Data"));
            }

            if (_searchText.isNotEmpty) {
              List tempList = new List();
              for (int i = 0; i < listOffice.length; i++) {
                if (listOffice[i]['office_name'].toLowerCase().contains(_searchText.toLowerCase())) {
                  tempList.add(listOffice[i]);
                }
              }
              filteredNames = tempList;
            }
            return ListView(
              children: filteredNames.map((document) {
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
          ,
        )
      )
    );
  }

  Widget bodyWidget(){
    if(listOffice.isEmpty){
      return Container(
          color: Colors.red,
          height: 200,
          width: 200,
          child: Text("No Data"));
    }

    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < listOffice.length; i++) {
        if (listOffice[i]['office_name'].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(listOffice[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView(
      children: filteredNames.map((document) {
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


  Future<void> deleteOffice(String docId) async {

    //Validate if office still assigned to user
    var docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('office', isEqualTo: officeName)
        .get();

    if(docSnapshot.docs.isEmpty || docSnapshot.docs == null){
      CollectionReference officeLoc = FirebaseFirestore.instance.collection('ref_office_location');
      return officeLoc
          .doc(docId)
          .delete()
          .then((value) => print("Office Deleted"))
          .catchError((error) => print("Failed to delete Office Data: $error"));
    }else{
      EasyLoading.showError('Failed to delete office\n Unassign users from office first',);
      return null;
    }
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

  Future<List<QueryDocumentSnapshot>> getOfficeData() async {
    var dataCollection = FirebaseFirestore.instance;
    QuerySnapshot officeSnapshot;
    if(listOffice == null){
      officeSnapshot = await dataCollection
          .collection("ref_office_location")
          .get();
    }

    listOffice = officeSnapshot.docs.toList();
    filteredNames = listOffice;
    return listOffice;
  }

  void addOrEditOffice(String mode, BuildContext context) async {
    String title;
    if (mode == 'Add') {
      title = 'Add New Office';
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditOffice(pageTitle: title,)));
    }

    if(mode == 'Edit') {
      title = 'Edit Office';
      dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditOffice(pageTitle: title,docId: docId,)));
      if(result != null) {
        setState(() {
          listOffice = null;
        });
      }
    }
  }
}



