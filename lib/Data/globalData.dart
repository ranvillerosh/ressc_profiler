import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ressc_profiler/Data/trainee.dart';
import 'package:ressc_profiler/Data/training.dart';

import 'office.dart';

class GlobalData with ChangeNotifier{
  static Map<String, Trainee> _traineeMap = {};
  static Map<String, Trainee> get traineeMap => _traineeMap;
  static Map<String, Office> _officeMap = {};
  static Map<String, Office> get officeMap => _officeMap;
  static Map<String, Training> _trainingMap = {};
  static Map<String, Training> get trainingMap => _trainingMap;

  // Get a non-default Storage bucket
  static final storageRef = FirebaseStorage.instanceFor(bucket: "gs://doh-chd-car-portal-app.appspot.com").ref();

  //Firebase Firestore Database
  static final db = FirebaseFirestore.instance;

  //One-time fetch all trainees
  static Future<void> fetchTrainees() async {
    try {
      final snapshot = await db.collection("trainee").get();
      snapshot.docs.forEach((result) {
        Trainee trainee = Trainee.fromFireStore(result);
        _traineeMap[trainee.id!] = trainee;
      });
    } catch (e) {
      print('Error getting trainees: $e');
    }
  }

  //fetch all trainees with realtime updates
  static Future<void> listenToAllTraineeUpdates() async {
    db.collection("trainee").snapshots().listen((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Trainee trainee = Trainee.fromFireStore(result);
        _traineeMap[trainee.id!] = trainee;
      });
    });
  }

  //One-time fetch all trainings
  static Future<void> fetchTrainings() async {
    try {
      final snapshot = await db.collection("training").get();
      snapshot.docs.forEach((result) {
        Training training = Training.fromFireStore(result);
        _trainingMap[training.id];
      });
    } catch (e) {
      print('Error getting trainees: $e');
    }
  }
}

