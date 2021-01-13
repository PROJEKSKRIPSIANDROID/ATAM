import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientOffice {
  final String clientOfficeId;
  final LatLng latLng;
  final String clientOfficeName;
  final String clientOfficeAddress;

  const ClientOffice({
    @required this.clientOfficeId,
    @required this.latLng,
    @required this.clientOfficeName,
    @required this.clientOfficeAddress,
  })  : assert(clientOfficeId != null),
        assert(latLng != null),
        assert(clientOfficeName != null),
        assert(clientOfficeAddress != null);

  double get latitude => latLng.latitude;

  double get longitude => latLng.longitude;

  ClientOffice copyWith({
    String clientOfficeId,
    LatLng latLng,
    String clientOfficeName,
    String clientOfficeAddress,
  }) {
    return ClientOffice(
      clientOfficeId: clientOfficeId ?? this.clientOfficeId,
      latLng: latLng ?? this.latLng,
      clientOfficeName: clientOfficeName ?? this.clientOfficeName,
      clientOfficeAddress: clientOfficeAddress ?? this.clientOfficeAddress,
    );
  }
}

enum PlaceCategory {
  favorite,
  visited,
  wantToGo,
}
