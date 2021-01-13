import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mattendance/Pages/OfficeManagement/OfficeManagementServices.dart';
import 'package:mattendance/model/officeDataModel.dart';

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
  final ValueChanged<ClientOffice> onChanged;
  const AddEditOffice({
    @required this.pageTitle,
    @required this.onChanged,
    Key key,
  })  : assert(pageTitle != null),
        assert(onChanged != null),
        super(key: key);

  @override
  AddEditOfficeState createState() => AddEditOfficeState();
}

class AddEditOfficeState extends State<AddEditOffice> {
  ClientOffice _clientOffice;
  GoogleMapController mapController;
  final Set<Marker> _markers = {};
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
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
              child: IconButton(
                icon: Text("Save",style: TextStyle(color: Colors.black),),
                onPressed: () {
                  widget.onChanged(_clientOffice);
                  Navigator.pop(context);
                },
              ),
            ),
          ],

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
      officeNameController.text = 'test';
      addressNameController.text = 'test';
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
              _clientOffice = _clientOffice.copyWith(clientOfficeName: value);
            });
          },
        ),
        AddressField(
          controller: addressNameController,
          onChanged: (value) {
            setState(() {
              _clientOffice = _clientOffice.copyWith(clientOfficeAddress: value);
            });
          },
        ),
        MapField(
          center: null,
          mapController: mapController,
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
        markerId: MarkerId(null),
        position: null,
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
