import 'package:flutter/material.dart';
import 'package:mattendance/Pages/OfficeManagement/OfficeManagementServices.dart';
import 'file:///D:/Workspace/Skripsi/m_attendance/lib/Pages/OfficeManagement/add_edit_office.dart';

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
              onSelected: (choice) => handleClick(choice, context),
            ),
          ),
        ],
      ),
      body: Container(
        height: 500,
        child: listOffice.isEmpty
            ? Column(
          children: <Widget>[
            Text(
              'No Office Data!',
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                height: 200,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                )),
          ],
        )
            : ListView.builder(
          itemBuilder: (ctx, index) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5,
              ),
              child: ListTile(
                leading: Icon(
                  Icons.business_rounded
                ),
                title: Text(
                  listOffice[index].officeName,
                  style: Theme.of(context).textTheme.title,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                ),
              ),
            );
          },
          itemCount: listOffice.length,
        ),
      )
    );
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

  void handleClick(String value, BuildContext context) {
    setState((){
      String title;
      if (value == 'Add New Item') {
        title = 'Add New Office';
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddEditOffice())
        );
      }
    });
  }
}



