import 'dart:core';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ressc_profiler/Data/office.dart';
import 'Data/globalData.dart';
import 'Data/trainee.dart';
import 'Data/training.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RESSCDirectory extends StatefulWidget {
  RESSCDirectory({super.key, required this.title, required this.db, required this.storageRef});
  final String title;
  FirebaseFirestore db;
  Reference storageRef;

  @override
  State<RESSCDirectory> createState() => _RESSCDirectory();
}

class _RESSCDirectory extends State<RESSCDirectory> with TickerProviderStateMixin {
  bool shadowColor = false;
  double? scrolledUnderElevation;
  Trainee newTraineeProfile = Trainee(null, null,null, null, null, null, null, null, null, null, null, null, null);

  @override
  Widget build(BuildContext context) {
    List<Trainee> traineeList = [];
    GlobalData.getDirectoryData().whenComplete(() => traineeList = GlobalData.traineesList);

    // var sampleTraineeData = Trainee("nameFirst","nameMiddle", "nameLast", "SamplePosition", DateTime.now(), "contactNumber1", "contactNumber2", "emailPersonal", "emailOfficial", null, "religionChristian", Office("SampleOffice"),[TrainingBatch(Training("Sample Disease Surveillance and Data Management Training 1","SDSDMT 1")),TrainingBatch(Training("Sample Disease Surveillance and Data Management Training 2","SDSDMT 2")),TrainingBatch(Training("Sample Disease Surveillance and Data Management Training 3","SDSDMT 3")), TrainingBatch(Training("Sample Disease Surveillance and Data Management Training 3","SDSDMT 3")),TrainingBatch.withDates(training: Training("Sample Disease Surveillance and Data Management Training 3","SDSDMT 3"), startDate: null, endDate: null)]);
    // traineeList.add(sampleTraineeData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RESSC Directory'),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: ClipOval(
                  child: Image.asset("assets/media/profile_icon.gif"),
                ),
                title: Text("Add New Trainee Profile"),
                onTap: () {
                  _addNewTraineeProfileDialog(context);
                }, //TODO add new trainee
              ),
            ),
            Card(
              child: ListTile(
                leading: ClipOval(
                  child: Image.asset("assets/media/training_icon.png"),
                ),
                title: Text("Add New Training"),
                onTap: () {}, //TODO add new training
              ),
            )
          ],
        ),
      ),
      body: GridView.builder(
          padding: EdgeInsets.all(15.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2.0,
          ),
          itemCount: traineeList.length,
          itemBuilder: (BuildContext, index) {
            return Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  traineeList[index].showProfile(context);
                  debugPrint('Directory Card tapped.');
                },
                child: Center(
                  child: SizedBox.expand(
                      child: Row (
                      children: [
                        Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 4,
                          child:
                          buildProfilePicture(traineeList[index])
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Expanded(
                            flex: 9,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: AutoSizeText(
                                minFontSize: 12,
                                softWrap: true,
                                wrapWords: true,
                                "${traineeList[index].nameFirst} ${traineeList[index].nameMiddle?.substring(0,1)}. ${traineeList[index].nameLast}"
                              ),
                            )
                        ),
                      ],
                    )
                  ),
                ),
              ),
            );
          }),
    );
  }
  Future<Uri> _getProfilePic (String imageURL) async {
    var profilePicURL = Uri.parse(await widget.storageRef.child(imageURL).getDownloadURL());
    return profilePicURL;
  }

  Widget buildProfilePicture(Trainee profilePicture){
    try {
      return
        FadeInImage.assetNetwork(
            placeholder: "assets/media/profile_icon.gif",
            image:
            profilePicture.profilePicture!);
    } catch (e) {
      return
        Image.asset("assets/media/profile_icon.gif");
    }
  }

  Future<void> _addNewTraineeProfileDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog (
          title: Text('Add New Trainee Profile'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: addProfilePicture(newTraineeProfile)
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
                                  buildFirstName(
                                      "First Name", newTraineeProfile.nameFirst),
                                  SizedBox(width: 10),
                                  buildMiddleName(
                                      "Middle Name", newTraineeProfile.nameMiddle),
                                  SizedBox(width: 10),
                                  buildLastName(
                                      "Last Name", newTraineeProfile.nameLast),
                                ],
                              ),
                              Row(
                                children: [
                                  buildPosition(
                                      "Position", newTraineeProfile.position),
                                  SizedBox(width: 10),
                                  buildOffice(
                                      "Office", newTraineeProfile.office?.name)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildBirthdatePicker(context, newTraineeProfile.birthdate, newTraineeProfile),
                                  const SizedBox(width: 8,),
                                  ListenableBuilder(
                                    listenable: newTraineeProfile,
                                    builder: (BuildContext context, Widget? child) {
                                      return Expanded(
                                          flex: 3,
                                          child: Text("Age: ${newTraineeProfile.age}"));
                                    },
                                  ),
                                  const SizedBox(width: 20,),
                                  //
                                  buildReligion("Religion", newTraineeProfile.religion)
                                ],
                              )
                            ],
                          ),
                        )),
                  ],
                ),
                Row(
                  children: [
                    buildPersonalEmail("Personal Email", newTraineeProfile.emailPersonal),
                    SizedBox(width: 10,),
                    buildContactNumberPrimary("Contact Number: Primary", newTraineeProfile.contactNumber1)
                  ],
                ),
                Row(
                  children: [
                    buildOfficialEmail("Official Email", newTraineeProfile.emailOfficial),
                    SizedBox(width: 10,),
                    buildContactNumberSecondary("Contact Number: Secondary", newTraineeProfile.contactNumber2)
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
                  newTraineeProfile.id = await widget.db.collection("trainee").doc().id;
                  newTraineeProfile.saveToFirestore().whenComplete(() =>
                      Navigator.of(context).pop());

                  //TODO add to local list
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

  Widget buildFirstName(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
        return Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(labelText: label),
            onChanged: (String? newValue){
              setState(() {
                newTraineeProfile.nameFirst = newValue;
              });
            },

          ),
        );
      }
    );
  }

  Widget buildMiddleName(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
        return Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(labelText: label),
            onChanged: (String? newValue){
              setState(() {
                newTraineeProfile.nameMiddle = newValue;
              });
            },

          ),
        );
      }
    );
  }

  Widget buildLastName(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
        return Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(labelText: label),
            onChanged: (String? newValue){
              setState(() {
                newTraineeProfile.nameLast = newValue;
              });
            },

          ),
        );
      }
    );
  }

  Widget buildPosition(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
        return Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(labelText: label),
            onChanged: (String? newValue){
              setState(() {
                newTraineeProfile.position = newValue;
              });
            },

          ),
        );
      }
    );
  }

  Widget buildOffice(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
        return Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(labelText: label),
            onChanged: (String? newValue){
              setState(() {
                newTraineeProfile.office = Office(newValue);
              });
            },
          ),
        );
      }
    );
  }

  Widget buildBirthdatePicker(BuildContext context, DateTime? selectedBirthdate, Trainee trainee) {
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

  Widget buildReligion(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
        return Expanded(
          flex: 14,
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(labelText: label),
            onChanged: (String? newValue){
              setState(() {
                newTraineeProfile.religion = newValue;
              });
            },

          ),
        );
      }
    );
  }

  Widget buildPersonalEmail(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
        return Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(labelText: label),
            onChanged: (String? newValue){
              setState(() {
                newTraineeProfile.emailPersonal = newValue;
              });
            },
          ),
        );
      }
    );
  }

  Widget buildContactNumberPrimary(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
        return Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(labelText: label),
            onChanged: (String? newValue){
              setState(() {
                newTraineeProfile.contactNumber1 = newValue;
              });
            },
          ),
        );
      }
    );
  }

  Widget buildOfficialEmail(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
        return Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(labelText: label),
            onChanged: (String? newValue){
              setState(() {
                newTraineeProfile.emailOfficial = newValue;
              });
            },
          ),
        );
      }
    );
  }

  Widget buildContactNumberSecondary(String label, String? initialValue) {
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
        return Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(labelText: label),
            onChanged: (String? newValue){
              setState(() {
                newTraineeProfile.contactNumber2 = newValue;
              });
            },
          ),
        );
      }
    );
  }
}
