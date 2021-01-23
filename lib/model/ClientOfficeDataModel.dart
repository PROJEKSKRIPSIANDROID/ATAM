import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ClientOfficeModel {
  final String docId;
  ClientOfficeModel({this.docId});

  final CollectionReference officeCollection = FirebaseFirestore.instance.collection("client_office");

  Stream<DocumentSnapshot> get userData{
    return officeCollection.doc(docId).snapshots();
  }
}