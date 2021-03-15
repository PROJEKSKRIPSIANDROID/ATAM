import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart' as a;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'dart:math' show cos, sqrt, asin;


class HomePage extends StatefulWidget{
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{

  //region Properties
  List<Marker> markers = [];
  StreamSubscription streamSubscription;
  Location _locationTracker = Location();
  DateTime todayDate = DateTime.now();
  String clockIn = '-';
  String clockOut = '-';
  String officeName;
  var officeLong;
  var officeLat;
  String formattedDate;
  //variable to check todayData
  DocumentSnapshot todayData;
  final user = FirebaseAuth.instance.currentUser.uid;
  DateTime _myTime;
  Timer periodicTime;
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(-6.283890, 106.918980);
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  Set<Circle> radiusCircle = HashSet<Circle>();
  double radius;
  //endregion

  //region State
  @override
  void initState() {
    initiateData();
    getTodayData();
    realtimeDate();
    getCurrentLocation();
    super.initState();
  }

  @override
  void dispose(){
    if(streamSubscription != null){
      streamSubscription.cancel();
    }
    periodicTime.cancel();
    super.dispose();
  }
  //endregion

  //region DateTime function

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy kk:mm').format(dateTime);
  }

  void realtimeDate() {
    periodicTime = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      _myTime = await NTP.now();
      formattedDate = _formatDateTime(_myTime);
      setState(() {
        formattedDate = formattedDate;
      });
    });
  }
  //endregion

  //region Location function
  void initiateData() {
    if(todayDate.weekday == 6 || todayDate.weekday == 7){
      clockIn = 'OFF';
      clockOut = 'OFF';
    }else{
      initiateLocation();
    }
  }

  //Initiate Assigned Office Marker
  Future<void> initiateLocation() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .get()
        .then((DocumentSnapshot documentSnapshot) {

      var userData = documentSnapshot.data();
      officeName = userData['office'].toString();

      if(officeName != null){
        FirebaseFirestore.instance
            .collection('ref_office_location')
            .where('office_name', isEqualTo: officeName)
            .get()
            .then((QuerySnapshot documentSnapshot) {
          documentSnapshot.docs.forEach((item) {
            officeName = item['office_name'].toString();
            var geoPoint = item['office_coordinates'];
            officeLat = geoPoint.latitude;
            officeLong = geoPoint.longitude;
            setState(() {
              markers.add(Marker(
                  markerId: MarkerId('officeMarker'),
                  draggable: false,
                  position: LatLng(officeLat,officeLong),
                  visible: true,
                  infoWindow: InfoWindow(
                      title: officeName
                  )
              ));
              setRadiusCircle(LatLng(officeLat,officeLong));
            });
          });
        });
      }
    });

    //Get device location
    var location = await _locationTracker.getLocation();
    LatLng latLongPosition = LatLng(location.latitude, location.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLongPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<void> getTodayData() async {
    var _db = FirebaseFirestore.instance;

    QuerySnapshot reqA = await _db
        .collection("attendance_history")
        .where('attendance_date', isEqualTo: DateTime(todayDate.year, todayDate.month, todayDate.day))
        .where('user_id', isEqualTo: user)
        .get();
    List<QueryDocumentSnapshot> listData = reqA.docs.toList();
    if(listData.isNotEmpty){
      todayData = listData.where((element) => element['user_id'].toString() == user).first;
      if(todayData != null){
        setState(() {
          Timestamp clockInTimestamp = todayData['clock_in'];
          clockIn = DateFormat('HH:mm').format(clockInTimestamp.toDate()).toString();

          //Jika sudah clock-out
          if(todayData['clock_out'] != ""){
            Timestamp clockOutTimestamp = todayData['clock_out'];
            clockOut = DateFormat('HH:mm').format(clockOutTimestamp.toDate()).toString();
          }

        });
      }
    }
  }

  //Calculate between user and office location
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  //function to get current location of user
  void getCurrentLocation() async {
    try {

      //Uint8List imageData = await getMarker();
      //var location = await _locationTracker.getLocation();

      //updateMarkerAndCircle(location, imageData);

      if (streamSubscription != null) {
        streamSubscription.cancel();
      }

      streamSubscription = await _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          //newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
          //    bearing: 192.8334901395799,
          //    target: LatLng(newLocalData.latitude, newLocalData.longitude),
          //    tilt: 0,
          //    zoom: 18.00)));
          //updateMarkerAndCircle(newLocalData, imageData);

          //Calculate Distance between user and office
          double totalDistance = 0;
          totalDistance = calculateDistance(officeLat, officeLong, newLocalData.latitude, newLocalData.longitude);

          var timeNow = DateTime.now();
          var clockInRangeStart = new DateTime(timeNow.year, timeNow.month, timeNow.day, 6, 0, 0, 0, 0);
          var clockInRangeEnd = new DateTime(timeNow.year, timeNow.month, timeNow.day, 13, 0, 0, 0, 0);
          var clockOutRange1Start = new DateTime(timeNow.year, timeNow.month, timeNow.day, 15, 0, 0, 0, 0);
          var clockOutRange1End =new DateTime(timeNow.year, timeNow.month, timeNow.day, 24, 0, 0, 0, 0);
          var clockOutRange2Start = new DateTime(timeNow.year, timeNow.month, timeNow.day, 0, 0, 0, 0, 0);
          var clockOutRange2End =new DateTime(timeNow.year, timeNow.month, timeNow.day, 6, 0, 0, 0, 0);
          var clockInRadius = radius / 1000;
          int flag = 0;
          //Validate user distance from office
          //Clock-in
          if(totalDistance < clockInRadius && todayData == null && (timeNow.compareTo(clockInRangeStart) > 0 && timeNow.compareTo(clockInRangeEnd) < 0)){

            CollectionReference attendanceHist = FirebaseFirestore.instance.collection(
                'attendance_history');
             attendanceHist.add({
              'attendance_date': new DateTime(timeNow.year, timeNow.month, timeNow.day, 0, 0, 0, 0, 0), // 0 = format to date only
              'clock_in': DateTime.parse(timeNow.toString()),
              'clock_out': '',
              'status': 'Work',
              'user_id': user
            });
             flag = 1;
            //Clock-out
          }else if (totalDistance > clockInRadius && todayData != null
                && ((timeNow.compareTo(clockOutRange1Start) > 0 && timeNow.compareTo(clockOutRange1End) < 0) || (timeNow.compareTo(clockOutRange2Start) > 0 && timeNow.compareTo(clockOutRange2End) < 0))
                && clockOut == "-"){
            FirebaseFirestore _db = FirebaseFirestore.instance;
            _db.collection("attendance_history").doc(todayData.id).update({
              'clock_out': DateTime.parse(timeNow.toString()),
            });
            flag = 1;
          }

          if(flag == 1)
            getTodayData();
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  //get user location
  Future<void> getUserLocation() async {
    a.Position currentPosition;
    a.Position position = await a.Geolocator.getCurrentPosition(desiredAccuracy: a.LocationAccuracy.high);
    currentPosition = position;
    LatLng latLongPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
    new CameraPosition(target: latLongPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String uId = FirebaseAuth.instance.currentUser.uid.toString();
    FirebaseFirestore.instance.collection('users').doc(uId).update({
      'user_location': GeoPoint(position.latitude, position.longitude),
    });
  }

  //set radius circle to office location
  void setRadiusCircle(LatLng point) {
    FirebaseFirestore.instance
        .collection('general_setting')
        .where('setting_name', isEqualTo: 'Set Circle Radius')
        .get()
        .then((QuerySnapshot documentSnapshot) {
      documentSnapshot.docs.forEach((item) {
        radius = double.parse(item['setting_value'].toString());
        String circleId = 'officeRadius';
        
        radiusCircle.add(Circle(
            circleId: CircleId(circleId),
            center: LatLng(officeLat,officeLong),
            radius: radius,
            visible: true,
            fillColor: Colors.redAccent.withOpacity(0.5),
            strokeWidth: 3,
            strokeColor: Colors.redAccent));
      });
    });
  }
  //endregion

  //region Widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 240, 245, 10),
        title: Row(
          children: <Widget>[Image.asset('assets/Logo_AdIns2019_Colour.png',height: 50,)],
        )
      ),
      body: Stack(
        children: <Widget>[
         Listener(
           child: new GoogleMap(
              initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
              zoomControlsEnabled: true,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              markers: Set.from(markers),
              circles: radiusCircle,
              onMapCreated: (GoogleMapController controller){
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
                getUserLocation();
              },
            ),
         ),
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 6, 8, 0),
                  child: Container(
                    height: 60,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0),
                        bottomLeft: const Radius.circular(20.0),
                        bottomRight: const Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                      child: new Center(
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: new Column(
                            children: <Widget>[
                              Text("Date"),
                              if(formattedDate != null)
                                Text(formattedDate)
                            ],
                          ),
                        ),
                      )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 60,
                        width: 150,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0),
                            bottomLeft: const Radius.circular(20.0),
                            bottomRight: const Radius.circular(20.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: new Center(
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: new Column(
                              children: <Widget>[
                                Text("Clock In"),
                                Text(clockIn)
                              ],
                            ),
                          ),
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 60,
                        width: 150,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0),
                            bottomLeft: const Radius.circular(20.0),
                            bottomRight: const Radius.circular(20.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: new Center(
                            child: new Column(
                              children: <Widget>[
                                Text("Clock Out"),
                                Text(clockOut)
                              ],
                            ),
                          ),
                        )
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  //endregion
}