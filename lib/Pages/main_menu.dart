import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget{
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavBar>{
  final List screens = [
    Scaffold(),
    Scaffold(),
    Scaffold(),
    Scaffold()
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
        elevation: 0.0,
        items: [Icons.home, Icons.notifications_rounded, Icons.business_center, Icons.assignment_ind]
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
            child: Icon(value),
          ),
        ),
        )).values.toList(),
      ),
    );
  }
}