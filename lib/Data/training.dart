import 'package:ressc_profiler/Data/trainee.dart';
import 'package:ressc_profiler/training_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'enum_library.dart';

class Training{
  String name;
  String shortName;
  DateTime? startDate;
  DateTime? endDate;
  CompetencySkill? competencySkill;

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