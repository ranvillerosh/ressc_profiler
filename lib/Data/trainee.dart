import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ressc_profiler/Data/training.dart';
import '../trainee_profile.dart';

class Trainee {
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
  List<Training> trainings;

  Trainee(this.nameFirst, this.nameMiddle, this.nameLast, this.birthdate, this.contactNumber1, this.contactNumber2, this.emailPersonal, this.emailOfficial, this.profilePicture, this.trainings);

  void showProfile(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TraineeProfile(trainee: this);}
    ));
  }
}