import 'package:flutter/foundation.dart';

class OfficeSvc {
  String get titleName {
    return titleName;
  }

  set titleName (String name) {
    this.titleName = name;
  }
}

class Offices {
  final String id;
  final String officeName;
  final String officeAddress;

  Offices({
    @required this.id,
    @required this.officeName,
    @required this.officeAddress,
  });
}