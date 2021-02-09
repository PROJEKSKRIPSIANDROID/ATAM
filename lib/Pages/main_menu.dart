import 'package:flutter/material.dart';
import 'package:mattendance/Pages/assign_to_client_office.dart';
import 'package:mattendance/Pages/attendance_history_screen.dart';
import 'package:mattendance/Pages/home_page.dart';
import 'package:mattendance/Pages/profile_page.dart';
import 'Package:mattendance/Pages/RequestAbsence/request_absence_page.dart';
import 'Package:mattendance/Pages/notifications.dart';
import 'Package:mattendance/Pages/edit_assigned_office.dart';


class BottomNavBar extends StatefulWidget{
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavBar>{
  final List screens = [
    HomePage(),
    AbsenceApproval(),
    AssignToClientOffice(),
    ProfileScreen()
  ];

  int currIndex = 0;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: screens[currIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currIndex,
        onTap: (index) => setState(() => currIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 10,
        items: [Icons.home, Icons.approval, Icons.business_center, Icons.person]
            .asMap()
            .map((key, value) => MapEntry(
          key, BottomNavigationBarItem(
          title: Text(''),
          icon: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              color: currIndex == key ? Colors.blue[600] : Colors.transparent,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: <Widget>[
                Icon(value),
                if (key == 0)
                  Text("Home",
                  style: TextStyle(fontSize: 10,color: currIndex == 0 ? Colors.white : Colors.grey))
                else if (key == 1)
                  Text("Approval",
                      style: TextStyle(fontSize: 10,color: currIndex == 1 ? Colors.white : Colors.grey))
                else if (key == 2)
                  Text("Assign",
                      style: TextStyle(fontSize: 10,color: currIndex == 2 ? Colors.white : Colors.grey))
                else if (key == 3)
                  Text("Profile",
                      style: TextStyle(fontSize: 10,color: currIndex == 3 ? Colors.white : Colors.grey))
              ],
            ),
          ),
        ),
        )).values.toList(),
      ),
    );
  }

}