import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ressc_profiler/Data/trainee.dart';
import 'package:ressc_profiler/training_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'enum_library.dart';

class Training{
  String? id;
  String name;
  String shortName;
  String? rationale;
  String? background;
  List<String>? objectives;
  List<CompetencySkill>? competencySkill;
  List<Trainee>? graduatesList;
  String? logoURL;
  List<TrainingBatch>? batchList;

  Training(
      this.name,
      this.shortName
      );

  void showTraining(Training training, BuildContext context) {
    var training = Training("Sample Disease Surveillance and Data Management Training 3","SDSDMT 3");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TrainingDetails(training: training,)));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'shortName': shortName,
      'rationale': rationale,
      'background': background,
      'objectives': objectives,
      'competencySkill': competencySkill?.map((skill) => skill.toMap()).toList(),
      'graduatesList': graduatesList?.map((trainee) => trainee.toMap()).toList(),
      'logoURL': logoURL,
      'batchList': batchList?.map((batch) => batch.toMap()).toList(),
    }..removeWhere((key, value) => value == null);
  }

  Training.fromDB({
    required this.name,
    required this.shortName,
    this.rationale,
    this.background,
    this.objectives,
    this.competencySkill,
    this.graduatesList,
    this.logoURL,
    this.batchList
});

  //read data from firestore
  factory Training.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Training.fromDB(
      name: data?['name'],
      shortName: data?['shortName'],
      rationale: data?['rationale'],
      background: data?['background'],
      objectives: data?['objectives'] is Iterable
          ? List.from(data?['objectives']).map((objective) => objective.toString()).toList()
          : null,
      competencySkill: data?['competencySkill'] is Iterable
          ? List.from(data?['competencySkill'])
          .map((skill) => CompetencySkillExtension.fromString(skill.toString()))
          .toList()
          : null,
      graduatesList: data?['graduatesList'] is Iterable
          ? List.from(data?['graduatesList']).map((trainee) => Trainee.fromMap(trainee)).toList()
          : null,
      logoURL: data?['logoURL'],
      batchList: data?['batchList'] is Iterable
          ? List.from(data?['batchList']).map((batch) => TrainingBatch.fromMap(batch)).toList()
          : null,
    );
  }

  // Factory method to create Training from a Map
  factory Training.fromMap(Map<String, dynamic> map) {
    return Training.fromDB(
      name: map['name'],
      shortName: map['shortName'],
      rationale: map['rationale'],
      background: map['background'],
      objectives: map['objectives'] is Iterable
          ? List.from(map['objectives']).map((objective) => objective.toString()).toList()
          : null,
      competencySkill: map['competencySkill'] is Iterable
          ? List.from(map['competencySkill'])
          .map((skill) => CompetencySkillExtension.fromString(skill.toString()))
          .toList()
          : null,
      graduatesList: map['graduatesList'] is Iterable
          ? List.from(map['graduatesList']).map((trainee) => Trainee.fromMap(trainee)).toList()
          : null,
      logoURL: map['logoURL'],
      batchList: map['batchList'] is Iterable
          ? List.from(map['batchList']).map((batch) => TrainingBatch.fromMap(batch)).toList()
          : null,
    );
  }
}

class TrainingBatch {
  Training training;
  String? venue;
  DateTime? startDate;
  DateTime? endDate;
  List<Trainee>? mentorList;
  List<String>? photoDocumentation;

  TrainingBatch(
      this.training,
      );

  TrainingBatch.withDetails({
    required this.training,
    this.venue,
    this.startDate,
    this.endDate,
    this.mentorList,
    this.photoDocumentation,
  });

  //Named Constructor
  TrainingBatch.withDates({
    required this.training,
    required this.startDate,
    required this.endDate
  });

  Map<String, dynamic> toMap() {
    return {
      'training': training.toMap(),
      'venue': venue,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'mentorList': mentorList?.map((mentor) => mentor.toMap()).toList(),
      'photoDocumentation': photoDocumentation,
    }..removeWhere((key, value) => value == null);
  }


  // Factory method to create TrainingBatch from a Map
  factory TrainingBatch.fromMap(Map<String, dynamic> map) {
    return TrainingBatch.withDetails(
      training: Training.fromMap(map['training']),
      venue: map['venue'],
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      mentorList: map['mentorList'] is Iterable
          ? List.from(map['mentorList']).map((mentor) => Trainee.fromMap(mentor)).toList()
          : null,
      photoDocumentation: map['photoDocumentation'] is Iterable
          ? List.from(map['photoDocumentation']).map((photo) => photo.toString()).toList()
          : null,
    );
  }
}

