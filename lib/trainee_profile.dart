import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ressc_profiler/Data/trainee.dart';

class TraineeProfile extends StatefulWidget {
  Trainee? trainee;
  TraineeProfile(this.trainee);

  @override
  State<TraineeProfile> createState() {
    _TraineeProfile();
    throw UnimplementedError();
  }
}

class _TraineeProfile extends State<TraineeProfile>{
  late Trainee? trainee;
  _TraineeProfile(){
    trainee = widget.trainee;
  }
  @override
  Widget build(BuildContext context) {
    MaterialApp(
        title: "Trainee Information",
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
            useMaterial3: true
        ),
        home: Scaffold(
          appBar: AppBar(
            title
          ),
        )
    );
    throw UnimplementedError();
  }
}
