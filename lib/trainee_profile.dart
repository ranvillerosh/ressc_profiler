import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ressc_profiler/Data/trainee.dart';

import 'Data/training.dart';

class TraineeProfile extends StatefulWidget {
  TraineeProfile({super.key, required this.trainee});

  Trainee trainee;

  @override
  State<TraineeProfile> createState() => _TraineeProfile();
}

class _TraineeProfile extends State<TraineeProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "${widget.trainee.nameFirst!} ${widget.trainee.nameMiddle!.substring(0, 1)}. ${widget.trainee.nameLast!}"),
          actions: [
            IconButton.filledTonal(
                onPressed: () {
                  _editTraineeProfileDialog(context, widget.trainee);
                },
                icon: Icon(Icons.edit_rounded)
            ),
            SizedBox(width: 10,)
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width/29),
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 8,
                      child: buildProfilePicture(widget.trainee)
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                      flex: 18,
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                buildNameRow(
                                    "First Name", widget.trainee.nameFirst),
                                SizedBox(width: 10),
                                buildNameRow(
                                    "Middle Name", widget.trainee.nameMiddle),
                                SizedBox(width: 10),
                                buildNameRow(
                                    "Last Name", widget.trainee.nameLast),
                              ],
                            ),
                            Row(
                              children: [
                                buildOccupationRow(
                                    "Position", widget.trainee.position),
                                SizedBox(width: 10),
                                buildOccupationRow(
                                    "Office", widget.trainee.office.name)
                              ],
                            ),
                            Row(
                              children: [
                                buildAgeReligionRow("Birthdate", DateFormat.yMMMMd().format(widget.trainee.birthdate!)),
                                const SizedBox(width: 10,),
                                buildAgeReligionRow("Age", "${DateTime.now().difference(widget.trainee.birthdate!).inDays/365.floor()}"),
                                const SizedBox(width: 10,),
                                buildAgeReligionRow("Religion", widget.trainee.religion)
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
              Row(
                children: [
                  buildContactRow("Personal Email", widget.trainee.emailPersonal),
                  SizedBox(width: 10,),
                  buildContactRow("Contact Number: Primary", widget.trainee.contactNumber1)
                ],
              ),
              Row(
                children: [
                  buildContactRow("Official Email", widget.trainee.emailOfficial),
                  SizedBox(width: 10,),
                  buildContactRow("Contact Number: Secondary", widget.trainee.contactNumber2)
                ],
              ),
              const SizedBox(height: 10,),
              buildTrainingsList(widget.trainee.trainings, context)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //code for new training dialog
          },
          child: const Icon(Icons.add),
        ),
    );
  }

  Widget buildProfilePicture(Trainee profilePicture){
    try {
      return
        FadeInImage.assetNetwork(
            placeholder: "assets/media/profile_icon.gif",
            image:
            "https://firebasestorage.googleapis.com/v0/b/doh-chd-car-portal-app.appspot.com/o/Placeholders%2FprofilePicturePlaceHolder.jpg?alt=media&token=7344d9d2-156d-4fde-88eb-d1253f8b14e2");
    } catch (e) {
      return
        Image.asset("assets/media/profile_icon.gif");
    }
  }

  Widget buildNameRow(String label, String? initialValue) {
    return Expanded(
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget buildOccupationRow(String label, String? initialValue) {
    return Expanded(
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget buildContactRow(String label, String? initialValue) {
    return Expanded(
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget buildAgeReligionRow(String label, String? initialValue) {
    return Expanded(
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget buildTrainingsList(List<TrainingBatch>? trainings, BuildContext context) {
    if(trainings!=null && trainings.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
            itemCount: widget.trainee.trainings!.length,
            itemBuilder: (context, index) {
              return Expanded(
                child: Card(
                  child: InkWell(
                    onTap: (){
                      _showTrainingDetailsDialog(trainings[index], context);
                    },
                    child: ListTile(
                      title: Text(widget.trainee.trainings![index].training.shortName),
                      subtitle: Text(widget.trainee.trainings![index].training.name),
                    ),
                  ),
                ),
              );
            }),
      );
    } else if(trainings == null){
      return const Expanded(
        child: Text("No Trainings added yet. Try adding the first one by clicking on the + button"),
      );
    } else {
      return const Expanded(
        child: Text("No Trainings added yet. Try adding the first one by clicking on the + button"),
      );
    }
  }

  Future<void> _showTrainingDetailsDialog(TrainingBatch trainingBatch, BuildContext context) async {
    var trainingDates = "No training dates set.";
    var trainingVenue = "No Training Venue specified.";
    if (trainingBatch.startDate!=null && trainingBatch.endDate!=null) {
      trainingDates = "${DateFormat.yMMMMd(trainingBatch.startDate)} - ${DateFormat.yMMMMd(trainingBatch.endDate)}";
    }
    if (trainingBatch.venue!=null) {
      trainingVenue = trainingBatch.venue!;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(trainingBatch.training.shortName),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(trainingBatch.training.name),
                Text(trainingDates),
                Text(trainingVenue)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editTraineeProfileDialog(BuildContext context, Trainee trainee) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Trainee Profile'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: buildProfilePicture(widget.trainee)
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                        flex: 18,
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  buildNameRow(
                                      "First Name", widget.trainee.nameFirst),
                                  SizedBox(width: 10),
                                  buildNameRow(
                                      "Middle Name", widget.trainee.nameMiddle),
                                  SizedBox(width: 10),
                                  buildNameRow(
                                      "Last Name", widget.trainee.nameLast),
                                ],
                              ),
                              Row(
                                children: [
                                  buildOccupationRow(
                                      "Position", widget.trainee.position),
                                  SizedBox(width: 10),
                                  buildOccupationRow(
                                      "Office", widget.trainee.office.name)
                                ],
                              ),
                              Row(
                                children: [
                                  buildAgeReligionRow("Birthdate", DateFormat.yMMMMd().format(widget.trainee.birthdate!)),
                                  const SizedBox(width: 10,),
                                  buildAgeReligionRow("Age", "${DateTime.now().difference(widget.trainee.birthdate!).inDays/365.floor()}"),
                                  const SizedBox(width: 10,),
                                  buildAgeReligionRow("Religion", widget.trainee.religion)
                                ],
                              )
                            ],
                          ),
                        )),
                  ],
                ),
                Row(
                  children: [
                    buildContactRow("Personal Email", widget.trainee.emailPersonal),
                    SizedBox(width: 10,),
                    buildContactRow("Contact Number: Primary", widget.trainee.contactNumber1)
                  ],
                ),
                Row(
                  children: [
                    buildContactRow("Official Email", widget.trainee.emailOfficial),
                    SizedBox(width: 10,),
                    buildContactRow("Contact Number: Secondary", widget.trainee.contactNumber2)
                  ],
                ),
                buildTrainingsList(trainee.trainings, context)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            OutlinedButton(
                onPressed: () {
                  //push changes to server
                },
                child: const Text("Save"))
          ],
        );
      },
    );
  }

}
