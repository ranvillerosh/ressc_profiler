import 'package:ressc_profiler/Data/trainee.dart';
import 'package:ressc_profiler/training_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'enum_library.dart';

class Training{
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

  //Named Constructor
  TrainingBatch.withDates({
    required this.training,
    required this.startDate,
    required this.endDate
  });

  // TODO
}

