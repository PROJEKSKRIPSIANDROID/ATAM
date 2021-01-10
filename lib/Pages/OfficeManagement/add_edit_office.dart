import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mattendance/Pages/OfficeManagement/OfficeManagementServices.dart';

//class AddEditOffice extends StatefulWidget {
//  final String pageTitle;
//
//  AddEditOffice ({Key key, @required this.pageTitle}) : super(key: key);
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//          iconTheme: IconThemeData(color: Colors.black),
//          backgroundColor: Color.fromRGBO(255, 240, 245, 10),
//          title: Row(
//            children: <Widget>[
//              Text(pageTitle,
//                style: TextStyle(color: Colors.black),
//              )
//            ],
//          )
//      ),
//    );
//  }
//}

class AddEditOffice extends StatefulWidget {
  final String pageTitle;

  const AddEditOffice({
    @required this.pageTitle,
    Key key,
  })  : assert(pageTitle != null),
        super(key: key);

  @override
  AddEditOfficeState createState() => AddEditOfficeState();
}

class AddEditOfficeState extends State<AddEditOffice> {
  GoogleMapController mapController;

  final TextEditingController officeNameController = TextEditingController();
  final TextEditingController addressNameController = TextEditingController();
  String testing = 'AddOffice';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromRGBO(255, 240, 245, 10),
          title: Row(
            children: <Widget>[
              Text('Add Office',
                style: TextStyle(color: Colors.black),
              )
            ],
          )
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: addEditOfficeBody(),
      ),
    );
  }


  @override
  void initState() {
    if(testing == 'AddOffice'){
      officeNameController.text = _place.name;
      addressNameController.text = _place.description;
    }

    return super.initState();
  }

  Widget addEditOfficeBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
      children: [
        OfficeNameField(
          controller: officeNameController,
          onChanged: (value) {
            setState(() {
              _place = _place.copyWith(name: value);
            });
          },
        ),
        AddressField(
          controller: addressNameController,
          onChanged: (value) {
            setState(() {
              _place = _place.copyWith(description: value);
            });
          },
        ),
        MapField(
          center: LatLng(position.latitude,  position.longitude),
          mapController: _mapController,
          onMapCreated: _onMapCreated,
          markers: _markers,
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_place.latLng.toString()),
        position: _place.latLng,
      ));
    });
  }
}

class OfficeNameField extends StatelessWidget {
  final TextEditingController controller;

  final ValueChanged<String> onChanged;
  const OfficeNameField({
    @required this.controller,
    @required this.onChanged,
    Key key,
  })  : assert(controller != null),
        assert(onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Office Name',
          labelStyle: TextStyle(fontSize: 18),
        ),
        style: const TextStyle(fontSize: 20, color: Colors.black87),
        autocorrect: true,
        controller: controller,
        onChanged: (value) {
          onChanged(value);
        },
      ),
    );
  }
}

class AddressField extends StatelessWidget {
  final TextEditingController controller;

  final ValueChanged<String> onChanged;
  const AddressField({
    @required this.controller,
    @required this.onChanged,
    Key key,
  })  : assert(controller != null),
        assert(onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Description',
          labelStyle: TextStyle(fontSize: 18.0),
        ),
        style: const TextStyle(fontSize: 20.0, color: Colors.black87),
        maxLines: null,
        autocorrect: true,
        controller: controller,
        onChanged: (value) {
          onChanged(value);
        },
      ),
    );
  }
}

class MapField extends StatelessWidget {
  final LatLng center;

  final GoogleMapController mapController;
  final ArgumentCallback<GoogleMapController> onMapCreated;
  final Set<Marker> markers;
  const MapField({
    @required this.center,
    @required this.mapController,
    @required this.onMapCreated,
    @required this.markers,
    Key key,
  })  : assert(center != null),
        assert(onMapCreated != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      elevation: 4,
      child: SizedBox(
        width: 340,
        height: 240,
        child: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            target: center,
            zoom: 16,
          ),
          markers: markers,
          zoomGesturesEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          scrollGesturesEnabled: false,
        ),
      ),
    );
  }
}
