import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Data/training.dart';

class TrainingDetails extends StatefulWidget {
  TrainingDetails({super.key, required this.training});

  Training training;

  @override
  State<TrainingDetails> createState() => _TrainingDetails();
}

class _TrainingDetails extends State<TrainingDetails> {
  @override
  Widget build(BuildContext context) {
    var training = widget.training;
    return Scaffold(
      appBar: AppBar(
        title: Text(training.name),
        actions: [
          IconButton.filledTonal(
            onPressed: () {
            // TODO edit Training Details
            },
            icon: Icon(Icons.edit_rounded)
          ),
          SizedBox(width: 10,)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              buildTrainingHeader(context, training),
              buildTrainingBackground(training),
              buildTrainingRationale(training),
              ListTile(
                title: Text("Objectives"),
                subtitle: buildTrainingObjectives(training),
              ),
            ],
        ),
      ),
    );
  }

  Widget buildTrainingHeader(BuildContext context, Training training){
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(MediaQuery.of(context).size.width * 0.5, 100),
                    bottomRight: Radius.elliptical(MediaQuery.of(context).size.width * 0.5, 100)
                )
            ),
            //TODO image carousel (photo doc)
            // image: ,  //Nada yet
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: buildTrainingLogo(training.logoURL),
          ),
        ],
      ),
    );
  }

  Widget buildTrainingLogo(String? trainingLogoURL ) {
    if (trainingLogoURL != null) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.3,
        child: Expanded(
          child: Stack(
            children: [
              // TODO change more appropriate image asset
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.25,
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                      placeholder: "assets/media/training_icon.png",
                      image:
                      trainingLogoURL),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.mode_edit_outlined),
                  onPressed: () {  }, //TODO Uplaod Logo Function
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.3,
        child: Expanded(
          child: Stack(
            children: [
              // TODO change more appropriate image asset
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.25,
                child: ClipOval(
                  child: Image.asset("assets/media/training_icon.png"),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.mode_edit_outlined),
                  onPressed: () {  }, //TODO Uplaod Logo Function
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget buildTrainingRationale(Training training) {
    var rationale = "No training rationale set.";
    if (training.rationale != null) {
      rationale = training.rationale!;
    }
    
    return ListTile(
      title: const Text("Rationale"),
      subtitle: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(rationale),
        ),
      ),
    );
  }

  Widget buildTrainingBackground(Training training) {
    var background = "No training background set.";
    if (training.background != null) {
      background = training.background!;
    }

    return ListTile(
      title: const Text("Background"),
      subtitle: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(background),
        ),
      ),
    );
  }

  Widget buildTrainingObjectives(Training training) {

    if (training.objectives != null && training.objectives!.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: training.objectives!.length,
          itemBuilder: (context, index) {
            return Expanded(
                child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(training.objectives![index]),
                    ),
                  ),
            );
          },
        ),
      );
    } else {
      return const Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Text("No objectives set."),
            ),
          )
      );

    }


  }
}