import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('MOBILE ATTENDANCE'),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Holding on"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('click'),
      ),
    )
));