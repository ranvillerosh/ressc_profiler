import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ressc_profiler/Data/training.dart';
import '../trainee_profile.dart';
import 'office.dart';

class Trainee {
  String? id;
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

  int? computeAge() {
    try{
      var computedAge = DateTime.now().difference(birthdate!).inDays/365.floor() as int;
      return computedAge;
    } catch (e) {
      return null;
    }
  }
}
