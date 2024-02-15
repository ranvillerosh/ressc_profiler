import 'package:ressc_profiler/Data/trainee.dart';
import 'package:ressc_profiler/training_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'enum_library.dart';

class Training{
  String name;
  String shortName;
  String? venue;
  DateTime? startDate;
  DateTime? endDate;
  String? rationale;
  String? background;
  List<String>? objectives;
  List<CompetencySkill>? competencySkill;
  String? logo;
  List<String>? photoDocumentation;

  Training(
      this.name,
      this.shortName
      );

  void addTraining(Trainee trainee, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TrainingDetails(
              //
            )
        )
    );
  }
}

class TrainingBatch {

}