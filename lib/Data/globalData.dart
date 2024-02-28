import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:ressc_profiler/Data/trainee.dart';
import 'package:ressc_profiler/Data/training.dart';

import 'office.dart';

class GlobalData with ChangeNotifier{
  static List<Trainee> traineesList = [];
  static List<Office> officeList = [];
  static List<Training> trainingList = [];

  // Get a non-default Storage bucket
  static final storageRef = FirebaseStorage.instanceFor(bucket: "gs://doh-chd-car-portal-app.appspot.com").ref();

  //Firebase Firestore Database
  static final db = FirebaseFirestore.instance;

  static Future<void> getDirectoryData() async {
    try {
      db.collection("trainee").get().then(
            (querySnapshot) {
          print("Successfully completed");
          for (var docSnapshot in querySnapshot.docs) {
            traineesList.add(Trainee.fromFirestore(docSnapshot, SnapshotOptions()));
          }
        },
        onError: (e) => debugPrint("(trainee) Error completing: $e"),
      );
      // db.collection("office").get().then(
      //       (querySnapshot) {
      //     print("Successfully completed");
      //     for (var docSnapshot in querySnapshot.docs) {
      //       officeList.add(Office.fromFirestore(docSnapshot, SnapshotOptions()));
      //     }
      //   },
      //   onError: (e) => debugPrint("(office) Error completing: $e"),
      // );
      // db.collection("training").get().then(
      //       (querySnapshot) {
      //     print("Successfully completed");
      //     for (var docSnapshot in querySnapshot.docs) {
      //       trainingList.add(Training.fromFirestore(docSnapshot, SnapshotOptions()));
      //     }
      //   },
      //   onError: (e) => debugPrint("(training) Error completing: $e"),
      // );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> listenToChanges() async {
    try {
      db.collection("trainee").snapshots().listen(
          (event) => ,
        onError: (error) => (debugPrint("Listen on Trainee collection Failed"))
      );
    } catch (e) {

    }
  }
}