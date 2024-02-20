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
        title: Text("Add New Training"),
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
      body: ListView(
        children: [
          buildTrainingHeader(context, training),
          //
        ],
      ),
    );
  }

  Widget buildTrainingHeader(BuildContext context, Training training){
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(MediaQuery.of(context).size.width * 0.5, 100),
                    bottomRight: Radius.elliptical(MediaQuery.of(context).size.width * 0.5, 100)
                )
            ),
            //TODO image carousel (photo doc)
            // image: ,  //Nada yet
          ),
          Align(
            alignment: Alignment.center,
            child: buildTrainingLogo(training.logoURL),
          ),
        ],
      ),
    );
  }

  Widget buildTrainingLogo(String? trainingLogoURL ) {
    if (trainingLogoURL != null) {
      return Stack(
        children: [
          FadeInImage.assetNetwork(
              placeholder: "assets/media/profile_icon.gif",
              image:
              "https://firebasestorage.googleapis.com/v0/b/doh-chd-car-portal-app.appspot.com/o/Placeholders%2FprofilePicturePlaceHolder.jpg?alt=media&token=7344d9d2-156d-4fde-88eb-d1253f8b14e2"),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.mode_edit_outlined),
              onPressed: () {  }, //TODO Uplaod Logo Function
            ),
          )
        ],
      );
    } else {
      return Stack(
        children: [
          // TODO change more appropriate image asset
          Image.asset("assets/media/profile_icon.gif"),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.mode_edit_outlined),
              onPressed: () {  }, //TODO Uplaod Logo Function
            ),
          )
        ],
      );
    }
  }

}