import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainingDetails extends StatefulWidget {

  @override
  State<TrainingDetails> createState() => _TrainingDetails();
}

class _TrainingDetails extends State<TrainingDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Training"),
      ),
    );
  }
}