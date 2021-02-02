import 'package:flutter/material.dart';
import 'package:mattendance/Pages/attendance_history_screen.dart';
import 'package:mattendance/Pages/home_page.dart';
import 'Package:mattendance/Pages/RequestAbsence/request_absence_page.dart';
import 'package:mattendance/Pages/employee_profile.dart';

class EmployeeMainMenu extends StatefulWidget{
  @override
  _EmployeeMainMenu createState() => _EmployeeMainMenu();
}

class _EmployeeMainMenu extends State<EmployeeMainMenu>{
  final List screens = [
    HomePage(),
    RequestAbsencePage(),
    AttendanceHistory(),
    EmployeeProfile()
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
        items: [Icons.home, Icons.remove_from_queue_sharp, Icons.date_range_rounded, Icons.person]
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
                  Text("Request",
                      style: TextStyle(fontSize: 10,color: currIndex == 1 ? Colors.white : Colors.grey))
                else if (key == 2)
                    Text("History",
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

