import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ressc_profiler/Data/training.dart';
import '../trainee_profile.dart';
import 'office.dart';

class Trainee with ChangeNotifier {
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

  List<Trainee> _traineeList = [];
  List<Trainee> get traineeList => _traineeList;

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

  Trainee.fromDB({
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
    this.id,
    this.trainings});

  void showProfile(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TraineeProfile(
                  trainee: this,
                )));
  }

  // Method to save Trainee data to Firestore
  Future<void> saveToFirestore() async {
    try {
      // Get a reference to the Firestore collection
      DocumentReference trainees = FirebaseFirestore.instance.collection("trainee").doc(id);

      // Convert Trainee object to a Map
      Map<String, dynamic> traineeData = {
        'id':id,
        'nameFirst': nameFirst,
        'nameMiddle': nameMiddle,
        'nameLast': nameLast,
        'position': position,
        'birthdate': birthdate,
        'contactNumber1': contactNumber1,
        'contactNumber2': contactNumber2,
        'emailPersonal': emailPersonal,
        'emailOfficial': emailOfficial,
        'profilePicture': profilePicture,
        'religion': religion,
        'office': office?.toMap(), // Assuming Office has a toMap method
        'trainings': trainings?.map((training) => training.toMap()).toList(), // Assuming TrainingBatch has a toMap method
      };

      // Add the Trainee data to Firestore
      await trainees.set(traineeData, SetOptions(merge: true));
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }

  factory Trainee.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Trainee.fromDB(
      nameFirst: data?["nameFirst"],
      nameMiddle: data?["nameMiddle"],
      nameLast: data?["nameLast"],
      position: data?["position"],
      contactNumber1: data?["contactNumber1"],
      contactNumber2: data?["contactNumber2"],
      emailPersonal: data?["emailPersonal"],
      emailOfficial: data?["emailOfficial"],
      profilePicture: data?["profilePicture"],
      religion: data?["religion"],
      office: data?["office"] != null ? Office.fromMap(data?["office"]) : null,
      id: data?["id"],
      trainings: data?["trainings"] is Iterable
          ? List.from(data?["trainings"])
          .map((training) => TrainingBatch.fromMap(training))
          .toList()
          : null,
    );
  }

  //convert custom objects for pushing to firestore
  Map<String, dynamic> toMap() {
    return {
      'nameFirst': nameFirst,
      'nameMiddle': nameMiddle,
      'nameLast': nameLast,
      'position': position,
      'birthdate': birthdate?.toIso8601String(),
      'contactNumber1': contactNumber1,
      'contactNumber2': contactNumber2,
      'emailPersonal': emailPersonal,
      'emailOfficial': emailOfficial,
      'profilePicture': profilePicture,
      'religion': religion,
      'office': office?.toMap(),
      'trainings': trainings?.map((training) => training.toMap()).toList(),
    }..removeWhere((key, value) => value == null);
  }

  // Factory method to create Trainee from a Map
  factory Trainee.fromMap(Map<String, dynamic> map) {
    return Trainee.fromDB(
      nameFirst: map['nameFirst'],
      nameMiddle: map['nameMiddle'],
      nameLast: map['nameLast'],
      position: map['position'],
      birthdate: map['birthdate'] != null ? DateTime.parse(map['birthdate']) : null,
      contactNumber1: map['contactNumber1'],
      contactNumber2: map['contactNumber2'],
      emailPersonal: map['emailPersonal'],
      emailOfficial: map['emailOfficial'],
      profilePicture: map['profilePicture'],
      religion: map['religion'],
      office: map['office'] != null ? Office.fromMap(map['office']) : null,
      id: map['id'],
      trainings: map['trainings'] is Iterable
          ? List.from(map['trainings']).map((training) => TrainingBatch.fromMap(training)).toList()
          : null,
    );
  }

  computeAge() {
    try {
      var computedAge = DateTime.now().difference(birthdate!).inDays/365.floor();
      _age = computedAge.toInt();
      debugPrint("printing computed age ${age.toString()} ${_age.toString()}");
      notifyListeners();
    } catch (e) {
      debugPrint("age: ${age} ${_age} ${e.toString()} *some error happened");
      notifyListeners();
    }
  }
}
