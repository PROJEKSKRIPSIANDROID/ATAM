import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mattendance/Pages/OfficeManagement/officeAddressSearchService.dart';
import 'package:mattendance/model/officeDataModel.dart';
import 'package:mattendance/services/location_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoder/geocoder.dart';


class AddEditOffice extends StatefulWidget {
  final String pageTitle;
  final String docId;

  const AddEditOffice({
    this.pageTitle,
    this.docId,
    Key key,
  })  : assert(pageTitle != null),
        super(key: key);

  @override
  AddEditOfficeState createState() => AddEditOfficeState();
}

var officeLong;
var officeLat;

class AddEditOfficeState extends State<AddEditOffice> {
  ClientOffice _clientOffice;
  GoogleMapController mapController;
  final TextEditingController officeNameController = TextEditingController();
  final TextEditingController addressNameController = TextEditingController();
  String _previewImageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromRGBO(255, 240, 245, 10),
          title: Row(
            children: <Widget>[
              Text(widget.pageTitle,
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
              child: IconButton(
                icon: Text("Save",style: TextStyle(color: Colors.black),),
                onPressed: _savePlace,
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

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }
  dynamic data;
  Future<dynamic> getData() async {
    final DocumentReference document = FirebaseFirestore.instance.collection("ref_office_location").doc(widget.docId);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
        data = snapshot.data;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('ref_office_location')
        .doc(widget.docId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      var sda = documentSnapshot.data();
      officeNameController.text = sda['office_name'].toString();
      addressNameController.text = sda['office_address'].toString();
      var geoPoint = sda['office_coordinates'];

      officeLat = geoPoint.latitude;
      officeLong = geoPoint.longitude;
      _showPreview(officeLat, officeLong);
    });
  }


  void _savePlace() {
    if (officeNameController.text.isEmpty ||
        addressNameController.text.isEmpty) {
      return;
    }

    //Check if dooId, then state = Edit Data
    if (widget.docId.isNotEmpty){
      FirebaseFirestore _db = FirebaseFirestore.instance;
      _db.collection("ref_office_location").doc(widget.docId).update({
        'office_name': officeNameController.text,
        'office_address': addressNameController.text,
        'office_coordinates': GeoPoint(officeLat, officeLong)
      });
    }
    //Add Data
    else
    {
      CollectionReference officeLoc = FirebaseFirestore.instance.collection(
          'ref_office_location');
      officeLoc.add({
        'office_name': officeNameController.text,
        'office_address': addressNameController.text,
        'office_coordinates': GeoPoint(officeLat, officeLong)
      });
    }
    Navigator.of(context).pop();
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
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Office Address',
              labelStyle: TextStyle(fontSize: 18),
            ),
            style: const TextStyle(fontSize: 20, color: Colors.black87),
            autocorrect: true,
            controller: addressNameController,
            readOnly: true,
            onTap: () async {
              // generate a new token here
              final sessionToken = Uuid().v4();
              final Suggestion result = await showSearch(
                context: context,
                delegate: AddressSearch(sessionToken),
              );
              if (result != null) {
                final placeDetails = await PlaceApiProvider(sessionToken)
                    .getPlaceDetailFromId(result.placeId);
                addressNameController.text = placeDetails.toString();
                var addresses = await Geocoder.local.findAddressesFromQuery(addressNameController.text);
                var first = addresses.first;
                officeLat = first.coordinates.latitude;
                officeLong = first.coordinates.longitude;
                _showPreview(officeLat, officeLong);
              }
            },
            onChanged: (value) {
              setState(() {
                _clientOffice = _clientOffice.copyWith(clientOfficeAddress: value);
              });
            },
          ),
        ),
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text(
            'No Location Chosen',
            textAlign: TextAlign.center,
          )
              : Image.network(
            _previewImageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        )
      ],
    );
  }
}

class LocationPreview extends StatefulWidget {

  final LocationPreviewState state = new LocationPreviewState();

  void update() {
    state.change();
  }

  @override
  LocationPreviewState createState() => state;
}

class LocationPreviewState extends State<LocationPreview> {

  String _previewImageUrl;

  void change() {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: officeLat,
      longitude: officeLong,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: _previewImageUrl == null
          ? Text(
        'No Location Chosen',
        textAlign: TextAlign.center,
      )
          : Image.network(
        _previewImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
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

class AddressSearch extends SearchDelegate<Suggestion> {
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }
  final sessionToken;
  PlaceApiProvider apiClient;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : apiClient.fetchSuggestions(
          query, Localizations.localeOf(context).languageCode),
      builder: (context, snapshot) => query == ''
          ? Container(
        padding: EdgeInsets.all(16.0),
        child: Text('Enter your address'),
      )
          : snapshot.hasData
          ? ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title:
          Text((snapshot.data[index] as Suggestion).description),
          onTap: () {
            close(context, snapshot.data[index] as Suggestion);
          },
        ),
        itemCount: snapshot.data.length,
      )
          : Container(child: Text('Loading...')),
    );
  }
}


