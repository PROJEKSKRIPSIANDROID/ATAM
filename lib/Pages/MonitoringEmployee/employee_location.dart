import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class EmployeeLocation extends StatefulWidget {
  @override
  final DocumentSnapshot post;
  EmployeeLocation({this.post});
  _EmployeeLocation createState() => _EmployeeLocation();
}

class _EmployeeLocation extends State<EmployeeLocation> {
  @override
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(-6.283890, 106.918980);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  Set<Marker> allMarkers = {};

  void initState(){
    String currId = widget.post.data()['user_id'];
    String username = widget.post.data()['username'];
    var userLat;
    var userLong;

    FirebaseFirestore.instance
        .collection('users')
        .doc(currId.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      var data = documentSnapshot.data();
      var geoPoint = data['user_location'];

      userLat = geoPoint.latitude;
      userLong = geoPoint.longitude;
    });

    super.initState();
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        onTap: (){
          print('Marker Tapped');
        },
        position: LatLng(-6.283890, 106.918980)
    ));
  }

  Widget build(BuildContext context) {
    String currId = widget.post.data()['user_id'];
    String username = widget.post.data()['username'];

    return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromRGBO(255, 240, 245, 10),
          title: Row(
            children: <Widget>[
              Text(
                username + "'s Location",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            new GoogleMap(
              //onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
              //myLocationEnabled: false,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              markers: Set.from(allMarkers),
              //onCameraMove: _onCameraMove,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
              },
              //markers: Set<Marker>.of(markers.values),
            ),
          ],
        ));
  }
}
