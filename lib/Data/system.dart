import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../directory.dart';

class System {
  String systemName;
  BuildContext context;
  System (this.context, this.systemName);

  void navigateToSystem(BuildContext context, FirebaseFirestore db, Reference storageRef) {
    if (systemName.contains("Directory")) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RESSCDirectory(title: "RESSCDirectory", db: db, storageRef: storageRef)));
    }
  }
}