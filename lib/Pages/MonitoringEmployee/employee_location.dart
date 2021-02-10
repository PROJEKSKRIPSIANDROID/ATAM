import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class EmployeeLocation extends StatefulWidget {
  @override
  final DocumentSnapshot post;
  EmployeeLocation({this.post});
  _EmployeeLocation createState() => _EmployeeLocation();
}

class _EmployeeLocation extends State<EmployeeLocation> {
  @override
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  Set<Marker> allMarkers = {};
  var userLat;
  var userLong;


  Widget build(BuildContext context) {
    String currId = widget.post.data()['user_id'];
    String username = widget.post.data()['username'];
    var geoPoint = widget.post.data()['user_location'];
    userLat = geoPoint.latitude;
    userLong = geoPoint.longitude;

    LatLng _center = LatLng(userLat, userLong);

    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        onTap: (){
          print('Marker Tapped');
        },
        infoWindow: InfoWindow(
          title: username.toString(),
        ),
        position: LatLng(userLat, userLong)
    ));

    return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromRGBO(255, 240, 245, 10),
          title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                username + " Location",
                style: TextStyle(color: Colors.black),
              )
          ),
          /*title: Row(
            children: <Widget>[
              Text(
                username + "'s Location",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),*/
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
