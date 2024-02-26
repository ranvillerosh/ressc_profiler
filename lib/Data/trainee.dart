import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ressc_profiler/Data/training.dart';
import '../trainee_profile.dart';
import 'office.dart';

class Trainee with ChangeNotifier{
  String? id;
  int _age = 0;
  int get age => _age;
  String? nameFirst;
  String? nameMiddle;
  String? nameLast;
  String? position;
  DateTime? birthdate;
  String? contactNumber1;
  String? contactNumber2;
  String? emailPersonal;
  String? emailOfficial;
  String? profilePicture;
  String? religion;
  Office? office;
  List<TrainingBatch>? trainings;

  Trainee(
      this.nameFirst,
      this.nameMiddle,
      this.nameLast,
      this.position,
      this.birthdate,
      this.contactNumber1,
      this.contactNumber2,
      this.emailPersonal,
      this.emailOfficial,
      this.profilePicture,
      this.religion,
      this.office,
      this.trainings);

  void showProfile(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TraineeProfile(
                  trainee: this,
                )));
  }

  void addTrainee(BuildContext context, FirebaseFirestore db) {

  }

  computeAge() {
    try {
      var computedAge = DateTime.now().difference(birthdate!).inDays/365.floor();
      _age = computedAge.toInt();
      debugPrint("printing computed age ${age.toString()} ${_age.toString()}");
      notifyListeners();
    } catch (e) {
      debugPrint("age: ${age} ${_age} ${e.toString()} *some error happened");
      _age = 45;
      notifyListeners();
    }
    notifyListeners();
  }
}
