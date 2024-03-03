import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ressc_profiler/Data/office.dart';
import 'package:ressc_profiler/Data/trainee.dart';

import 'Data/globalData.dart';
import 'Data/training.dart';

class TraineeProfile extends StatefulWidget {
  TraineeProfile({super.key, required this.trainee});
  Trainee trainee;

  @override
  State<TraineeProfile> createState() => _TraineeProfile();
}

class _TraineeProfile extends State<TraineeProfile> {
  Trainee get trainee => widget.trainee;

  //Trainee("nameFirst", "nameMiddle", "nameLast","Position", null, "contactNumber1", "contactNumber2", "emailPersonal", "emailOfficial",  "Placeholders/profilePicturePlaceHolder.jpg","Religion", null, null);

  @override
  void initState()
  {
    listenToTraineeProfile();
    debugPrint("Trainee ID: ${trainee.id}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          title: buildFullName(),
          actions: [
            IconButton.filledTonal(
                onPressed: () {
                  _editTraineeProfileDialog(context);
                },
                icon: Icon(Icons.edit_rounded)
            ),
            SizedBox(width: 10,)
          ],
        ),
        body: traineeProfileStream(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //TODO code for new training dialog
          },
          child: const Icon(Icons.add),
        ),
      );
    } catch (e) {
      return Center(
        child: Text(e.toString()),
      );
    }
  }

  Widget traineeProfileStream() {
    return StreamBuilder<DocumentSnapshot>(
        stream: GlobalData.db.collection('trainee').doc(widget.trainee.id).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildTraineeProfile();
          }
        }
    );
  }

  Widget buildTraineeProfile() {
    try {
      return Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width/29),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 8,
                    child: buildProfilePicture(trainee)
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
                                  "First Name", trainee.nameFirst),
                              SizedBox(width: 10),
                              buildNameRow(
                                  "Middle Name", trainee.nameMiddle),
                              SizedBox(width: 10),
                              buildNameRow(
                                  "Last Name", trainee.nameLast),
                            ],
                          ),
                          Row(
                            children: [
                              buildOccupationRow(
                                  "Position", trainee.position),
                              SizedBox(width: 10),
                              buildOccupationRow(
                                  "Office", trainee.office?.name)
                            ],
                          ),
                          Row(
                            children: [
                              buildBirthdayRow("Birthdate", trainee.birthdate),
                              const SizedBox(width: 10,),
                              buildAgeRow("Age", trainee.birthdate),
                              const SizedBox(width: 10,),
                              buildReligionRow("Religion", trainee.religion)
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
            Row(
              children: [
                buildContactRow("Personal Email", trainee.emailPersonal),
                SizedBox(width: 10,),
                buildContactRow("Contact Number: Primary", trainee.contactNumber1)
              ],
            ),
            Row(
              children: [
                buildContactRow("Official Email", trainee.emailOfficial),
                SizedBox(width: 10,),
                buildContactRow("Contact Number: Secondary", trainee.contactNumber2)
              ],
            ),
            const SizedBox(height: 10,),
            buildTrainingsList(trainee.trainings, context)
          ],
        ),
      );
    } catch (e) {
      debugPrint("Trainee Profile error: ${e.toString()}.");
      return Center(child: Text(e.toString()),);
    }
  }

  Widget buildFullName() {
    try {
      if (trainee.nameMiddle == null) {
        return Text("${trainee.nameFirst} ${trainee.nameLast}");
      } else {
        return Text("${trainee.nameFirst} ${trainee.nameMiddle!.substring(0, 1)}. ${trainee.nameLast}");
      }
    } catch (e) {
      debugPrint("buildFullName errer: ${e.toString()}.");
      return Text("Cannot build Full Name");
    }
  }

  Widget buildProfilePicture(Trainee profilePicture){
    try {
      return
        FadeInImage.assetNetwork(
            placeholder: "assets/media/profile_icon.gif",
            image:
            "https://firebasestorage.googleapis.com/v0/b/doh-chd-car-portal-app.appspot.com/o/Placeholders%2FprofilePicturePlaceHolder.jpg?alt=media&token=7344d9d2-156d-4fde-88eb-d1253f8b14e2");
    } catch (e) {
      debugPrint("buildProfilePicture error: ${e.toString()}.");
      return
        Image.asset("assets/media/profile_icon.gif");
    }
  }

  Widget buildNameRow(String label, String? initialValue) {
    try {
      return Expanded(
        child: TextFormField(
          readOnly: true,
          initialValue: initialValue,
          decoration: InputDecoration(labelText: label),
        ),
      );
    }catch (e) {
      debugPrint("buildNameRow error: ${e.toString()}.");
      return Expanded(
        child: TextFormField(
          initialValue: null,
          decoration: InputDecoration(labelText: label),
        ),
      );
    }
  }

  Widget buildOccupationRow(String label, String? initialValue) {
    try {
      return Expanded(
        child: TextFormField(
          readOnly: true,
          initialValue: initialValue,
          decoration: InputDecoration(labelText: label),
        ),
      );
    } catch (e) {
      debugPrint("buildOccupationRow error: ${e.toString()}.");
      return Expanded(
        child: TextFormField(
          initialValue: null,
          decoration: InputDecoration(labelText: label),
        ),
      );
    }
  }

  Widget buildContactRow(String label, String? initialValue) {
    try {
      return Expanded(
        child: TextFormField(
          readOnly: true,
          initialValue: initialValue,
          decoration: InputDecoration(labelText: label),
        ),
      );
    } catch (e) {
      debugPrint("buildContactRow error: ${e.toString()}.");
      return Expanded(
        child: TextFormField(
          initialValue: null,
          decoration: InputDecoration(labelText: label),
        ),
      );
    }
  }

  Widget buildBirthdayRow (String label, DateTime? birthdate) {
    try {
      return Expanded(
        child: TextFormField(
          readOnly: true,
          initialValue: DateFormat.yMMMMd().format(birthdate!),
          decoration: InputDecoration(labelText: label),
        ),
      );
    } catch (e) {
      debugPrint("buildBirthdayRow error: ${e.toString()}.");
      return Expanded(
        child: TextFormField(
          initialValue: "No Birthdate Set",
          decoration: InputDecoration(labelText: label),
        ),
      );
    }
  }

  Widget buildAgeRow (String label, DateTime? birthdate) {
    try {
      return Expanded(
        child: TextFormField(
          initialValue: "${DateTime.now().difference(birthdate!).inDays/365.floor()}",
          decoration: InputDecoration(labelText: label),
        ),
      );
    } catch (e) {
      debugPrint("buildAgeRow error: ${e.toString()}.");
      return Expanded(
        child: TextFormField(
          initialValue: "~",
          decoration: InputDecoration(labelText: label),
        ),
      );
    }
  }

  Widget buildReligionRow(String label, String? initialValue) {
    try {
      return Expanded(
        child: TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(labelText: label),
        ),
      );
    } catch (e) {
      debugPrint("buildReligionRow error: ${e.toString()}.");
      return Expanded(
        child: TextFormField(
          initialValue: null,
          decoration: InputDecoration(labelText: label),
        ),
      );
    }
  }

  Widget buildTrainingsList(List<TrainingBatch>? trainings, BuildContext context) {
    try {
      if(trainings!=null && trainings.isNotEmpty) {
        return Expanded(
          child: ListView.builder(
              itemCount: trainee.trainings!.length,
              itemBuilder: (context, index) {
                return Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: (){
                        _showTrainingDetailsDialog(trainings[index], context);
                      },
                      child: ListTile(
                        title: Text(trainee.trainings![index].training.shortName),
                        subtitle: Text(trainee.trainings![index].training.name),
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
    } catch (e) {
      debugPrint("buildTrainingsList error: ${e.toString()}.");
      return Expanded(
        child: Text("Cannot Build Trainings List: ${e.toString()}"),
      );
    }
  }

  Future<void> listenToTraineeProfile() async {
    GlobalData.db.collection("trainee").doc(widget.trainee.id).snapshots().listen((querySnapshot) {
      debugPrint("Now lisetning to: ${widget.trainee.id}");
      setState(() {
        widget.trainee = Trainee.fromFirestore(querySnapshot);
      });
    });
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
            TextButton(
              child: const Text('Show More'),
              onPressed: () {
                trainingBatch.training.showTraining(trainingBatch.training, context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editTraineeProfileDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog (
          title: Text('EditTrainee Profile'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: addProfilePicture(trainee)
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
                                  buildEditFirstName(
                                      "First Name", trainee.nameFirst),
                                  SizedBox(width: 10),
                                  buildEditMiddleName(
                                      "Middle Name", trainee.nameMiddle),
                                  SizedBox(width: 10),
                                  buildEditLastName(
                                      "Last Name", trainee.nameLast),
                                ],
                              ),
                              Row(
                                children: [
                                  buildEditPosition(
                                      "Position", trainee.position),
                                  SizedBox(width: 10),
                                  buildEditOffice(
                                      "Office", trainee.office?.name)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildEditBirthdatePicker(context, trainee.birthdate, trainee),
                                  const SizedBox(width: 8,),
                                  ListenableBuilder(
                                    listenable: trainee,
                                    builder: (BuildContext context, Widget? child) {
                                      return Expanded(
                                          flex: 3,
                                          child: Text("Age: ${trainee.age}"));
                                    },
                                  ),
                                  const SizedBox(width: 20,),
                                  //
                                  buildEditReligion("Religion", trainee.religion)
                                ],
                              )
                            ],
                          ),
                        )),
                  ],
                ),
                Row(
                  children: [
                    buildEditPersonalEmail("Personal Email", trainee.emailPersonal),
                    SizedBox(width: 10,),
                    buildEditContactNumberPrimary("Contact Number: Primary", trainee.contactNumber1)
                  ],
                ),
                Row(
                  children: [
                    buildEditOfficialEmail("Official Email", trainee.emailOfficial),
                    SizedBox(width: 10,),
                    buildEditContactNumberSecondary("Contact Number: Secondary", trainee.contactNumber2)
                  ],
                ),
                // buildTrainingsList(trainee.trainings, context)
              ],
            ),
          ),
          actions: <Widget>[
            Card(
              child: InkWell(
                onTap: () {
                  //TODO add training chooser
                },
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_sharp),
                      Text("Add Training(s)")
                    ],
                  ),
                ),
              ),

            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            OutlinedButton(
                onPressed: () async {
                  //save update to database
                  trainee.saveEditsToFireStore().whenComplete(() => Navigator.of(context).pop());
                },
                child: const Text("Save"))
          ],
        );
      },
    );
  }

  Widget addProfilePicture(Trainee? trainee){
    try {
      return
        FadeInImage.assetNetwork(
            placeholder: "assets/media/profile_icon.gif",
            image:
            trainee!.profilePicture!);
    } catch (e) {
      return
        Image.asset("assets/media/profile_icon.gif");
    }
  }

  Widget buildEditFirstName(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
          return Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(labelText: label),
              onChanged: (String? newValue){
                setState(() {
                  trainee.nameFirst = newValue;
                });
              },

            ),
          );
        }
    );
  }

  Widget buildEditMiddleName(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
          return Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(labelText: label),
              onChanged: (String? newValue){
                setState(() {
                  trainee.nameMiddle = newValue;
                });
              },

            ),
          );
        }
    );
  }

  Widget buildEditLastName(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
          return Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(labelText: label),
              onChanged: (String? newValue){
                setState(() {
                  trainee.nameLast = newValue;
                });
              },

            ),
          );
        }
    );
  }

  Widget buildEditPosition(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
          return Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(labelText: label),
              onChanged: (String? newValue){
                setState(() {
                  trainee.position = newValue;
                });
              },

            ),
          );
        }
    );
  }

  Widget buildEditOffice(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
          return Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(labelText: label),
              onChanged: (String? newValue){
                setState(() {
                  trainee.office = Office(newValue);
                });
              },
            ),
          );
        }
    );
  }

  Widget buildEditBirthdatePicker(BuildContext context, DateTime? selectedBirthdate, Trainee trainee) {
    late TextEditingController textEditingController = TextEditingController();
    try {
      var displayDate = DateFormat.yMMMMd().format(DateTime.now());
      return Expanded(
        flex: 10,
        child: TextFormField(
          controller: textEditingController,
          decoration: const InputDecoration(labelText: "Birthdate"),
          onTap: () async {
            await showDatePicker(context: context, firstDate: DateTime(1900),lastDate: DateTime.now())
                .then((value) => selectedBirthdate = value)
                .then((value) => displayDate = DateFormat.yMMMMd().format(selectedBirthdate!))
                .then((value) => debugPrint(displayDate))
                .then((value) => trainee.birthdate = selectedBirthdate)
                .then((value) => trainee.computeAge())
                .whenComplete(() => textEditingController.text = displayDate);
          },
        ),
      );
    } catch (e) {
      var displayDate = DateFormat.yMMMMd().format(DateTime.now());
      return Expanded(
        child: TextFormField(
          controller: textEditingController,
          decoration: const InputDecoration(labelText: "Birthdate"),
          onTap: () async {
            await showDatePicker(context: context, firstDate: DateTime(1900),lastDate: DateTime.now())
                .then((value) => selectedBirthdate = value)
                .then((value) => displayDate = DateFormat.yMMMMd().format(selectedBirthdate!))
                .then((value) => debugPrint("$displayDate ${e.toString()}"))
                .then((value) => trainee.birthdate = selectedBirthdate)
                .then((value) => trainee.computeAge())
                .whenComplete(() => textEditingController.text = displayDate);
          },
        ),
      );
    }
  }

  Widget buildEditReligion(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
          return Expanded(
            flex: 14,
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(labelText: label),
              onChanged: (String? newValue){
                setState(() {
                  trainee.religion = newValue;
                });
              },

            ),
          );
        }
    );
  }

  Widget buildEditPersonalEmail(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
          return Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(labelText: label),
              onChanged: (String? newValue){
                setState(() {
                  trainee.emailPersonal = newValue;
                });
              },
            ),
          );
        }
    );
  }

  Widget buildEditContactNumberPrimary(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
          return Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(labelText: label),
              onChanged: (String? newValue){
                setState(() {
                  trainee.contactNumber1 = newValue;
                });
              },
            ),
          );
        }
    );
  }

  Widget buildEditOfficialEmail(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
          return Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(labelText: label),
              onChanged: (String? newValue){
                setState(() {
                  trainee.emailOfficial = newValue;
                });
              },
            ),
          );
        }
    );
  }

  Widget buildEditContactNumberSecondary(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
          return Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(labelText: label),
              onChanged: (String? newValue){
                setState(() {
                  trainee.contactNumber2 = newValue;
                });
              },
            ),
          );
        }
    );
  }

  // Future<void> _editTraineeProfileDialog(BuildContext context, Trainee trainee) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Edit Trainee Profile'),
  //         content: SizedBox(
  //           height: MediaQuery.of(context).size.height,
  //           width: MediaQuery.of(context).size.width,
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Expanded(
  //                       flex: 8,
  //                       child: buildProfilePicture(trainee)
  //                   ),
  //                   Spacer(
  //                     flex: 1,
  //                   ),
  //                   Expanded(
  //                       flex: 18,
  //                       child: Container(
  //                         child: Column(
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 buildNameRow(
  //                                     "First Name", trainee.nameFirst),
  //                                 SizedBox(width: 10),
  //                                 buildNameRow(
  //                                     "Middle Name", trainee.nameMiddle),
  //                                 SizedBox(width: 10),
  //                                 buildNameRow(
  //                                     "Last Name", trainee.nameLast),
  //                               ],
  //                             ),
  //                             Row(
  //                               children: [
  //                                 buildOccupationRow(
  //                                     "Position", trainee.position),
  //                                 SizedBox(width: 10),
  //                                 buildOccupationRow(
  //                                     "Office", trainee.office?.name)
  //                               ],
  //                             ),
  //                             Row(
  //                               children: [
  //                                 buildBirthdayRow("Birthdate", trainee.birthdate),
  //                                 const SizedBox(width: 10,),
  //                                 buildAgeRow("Age", trainee.birthdate),
  //                                 const SizedBox(width: 10,),
  //                                 buildReligionRow("Religion", trainee.religion)
  //                               ],
  //                             )
  //                           ],
  //                         ),
  //                       )),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   buildContactRow("Personal Email", trainee.emailPersonal),
  //                   SizedBox(width: 10,),
  //                   buildContactRow("Contact Number: Primary", trainee.contactNumber1)
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   buildContactRow("Official Email", trainee.emailOfficial),
  //                   SizedBox(width: 10,),
  //                   buildContactRow("Contact Number: Secondary", trainee.contactNumber2)
  //                 ],
  //               ),
  //               buildTrainingsList(trainee.trainings, context)
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("Cancel"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           OutlinedButton(
  //               onPressed: () {
  //                 //push changes to server
  //               },
  //               child: const Text("Save"))
  //         ],
  //       );
  //     },
  //   );
  // }

}
