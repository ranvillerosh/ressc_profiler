import 'dart:core';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ressc_profiler/Data/office.dart';
import 'package:search_page/search_page.dart';
import 'Data/globalData.dart';
import 'Data/trainee.dart';
import 'Data/training.dart';

class RESSCDirectory extends StatefulWidget {
  RESSCDirectory({super.key, required this.title});
  final String title;


  @override
  State<RESSCDirectory> createState() => _RESSCDirectory();
}

class _RESSCDirectory extends State<RESSCDirectory> with TickerProviderStateMixin {
  bool shadowColor = false;
  double? scrolledUnderElevation;
  Trainee newTraineeProfile = Trainee(null, null,null, null, null, null, null, null, null, null, null, null, null);
  Map<String, Trainee> get traineeMap => GlobalData.traineeMap;
  List get traineeList => GlobalData.traineeMap.values.toList();
  Training newTraining  = Training("Short Title", "Full, Expanded Title");

  @override
  void initState()
  {
    GlobalData.fetchTrainees().whenComplete(() {
      setState(() {
        traineeMap.addAll(GlobalData.traineeMap);
      });
    });
    GlobalData.listenToAllTraineeUpdates().whenComplete(() {
      setState(() {
        // traineeMap;
        debugPrint("Global Data: Listening to updates.");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('RESSC Directory'),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton.outlined(
                onPressed: () => buildSearch(context),
                icon: const Icon(Icons.search)
            ),
          ),
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
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: ClipOval(
                  child: Image.asset("assets/media/training_icon.png"),
                ),
                title: Text("Add New Training"),
                onTap: () {
                  _addNewTrainingDialog();
                },
              ),
            )
          ],
        ),
      ),
      body: directoryStream(),
    );
  }

  Future buildSearch(BuildContext context) {
    return showSearch(
        context: context,
        delegate: SearchPage(
            builder: (trainee) => ListTile(
              title: Text("${trainee.nameFirst} ${trainee.nameMiddle!.substring(0, 1)}. ${trainee.nameLast}"),
              subtitle: Text("${trainee.position}"),
              onTap: () => trainee.showProfile(context),
            ),
            filter: (trainee) => [
              trainee?.nameFirst,
              trainee?.nameMiddle,
              trainee?.nameLast,
              trainee?.trainings?.join(),
            ],
            items: traineeList));
  }

  Widget directoryStream() {
    return StreamBuilder<QuerySnapshot>(
        stream: GlobalData.db.collection('trainee').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildDirectoryGrid();
          }
        }
    );
  }

  Widget buildDirectoryGrid() {
    if (traineeMap.isNotEmpty) {
      try {
        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState) {
            return GridView.builder(
              padding: EdgeInsets.all(15.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2.0,
              ),
              itemCount: traineeMap.length,
              itemBuilder: (BuildContext, index) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      traineeMap.values.elementAt(index).showProfile(context);
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
                                buildProfilePicture(traineeMap.values.elementAt(index))
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Expanded(
                            flex: 9,
                            child: AutoSizeText(
                              maxLines: 3,
                              minFontSize: 12,
                              softWrap: true,
                              wrapWords: true,
                              "${traineeMap.values.elementAt(index).nameFirst} ${traineeMap.values.elementAt(index).nameMiddle?.substring(0,1)}. ${traineeMap.values.elementAt(index).nameLast}"
                              )
                            ),
                          ],
                        )
                      ),
                    ),
                  ),
                );
            });
          }
        );

      } catch (e) {
        debugPrint(e.toString());
        return Expanded(child: Text("Grid Builder error occured"));
      }
    } else if (traineeMap.isEmpty){
      return  Expanded(child: Text("No trainee profiles added yet"));
    } else {
      return Expanded(child: Text("Error occured"));
    }
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
                buildTrainingsList(newTraineeProfile.trainings, context)
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
                  newTraineeProfile.id = await GlobalData.db.collection("trainee").doc().id;
                  newTraineeProfile.saveToFirestore().whenComplete(() =>
                      Navigator.of(context).pop()
                  );
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

  Widget buildTrainingsList(List<TrainingBatch>? trainings, BuildContext context) {
    try {
      if(trainings!=null && trainings.isNotEmpty) {
        return Expanded(
          child: ListView.builder(
              itemCount: newTraineeProfile.trainings!.length,
              itemBuilder: (context, index) {
                return Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: (){
                        _showTrainingDetailsDialog(trainings[index], context);
                      },
                      child: ListTile(
                        title: Text(newTraineeProfile.trainings![index].training.shortName),
                        subtitle: Text(newTraineeProfile.trainings![index].training.name),
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

  Future<void> _addNewTrainingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog (
          title: const Text('Add New Training'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildTrainingHeader(),
                  buildTrainingName(),
                  buildTrainingBackground(),
                  buildTrainingRationale(),
                  buildTrainingObjectives()
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Card(
              child: InkWell(
                onTap: () {
                  //TODO add Training Batch Details
                },
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_sharp),
                      Text("Add Batch Record(s)")
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
                  newTraining.id = await GlobalData.db.collection("training").doc().id;
                  newTraining.saveToFirestore().whenComplete(() =>
                      Navigator.of(context).pop()
                  );
                },
                child: const Text("Save"))
          ],
        );
      },
    );
  }

  Widget buildTrainingHeader(){
    return StatefulBuilder(
        builder:(BuildContext context, StateSetter setState) {
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
                child: buildTrainingLogo(newTraining.logoURL),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget buildTrainingName () {
    return  StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "Enter Full Training Title here",
                ),
                onChanged: (String? newValue){
                  setState(() {
                    newTraining.name = newValue.toString();
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Short Name",
                  hintText: "Enter Training Short Title here",
                ),
                onChanged: (String? newValue){
                  setState(() {
                    newTraining.shortName = newValue.toString();
                  });
                },
              ),
            ],
          );
        }
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

  Widget buildTrainingRationale() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: "Rationale",
              hintText: "Enter Training Rationale here",
            ),
            onChanged: (String? newValue){
              setState(() {
                newTraining.rationale = newValue.toString();
              });
            },
          );
        }
    );
  }

  Widget buildTrainingBackground() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: "Background",
              hintText: "Enter Training Background here",
            ),
            onChanged: (String? newValue){
              setState(() {
                newTraining.background = newValue.toString();
              });
            },
          );
        }
    );
  }

  Widget buildTrainingObjectives() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: "Objectives",
              hintText: "Enter Training Objective(s) here",
            ),
            onChanged: (String? newValue) {
              setState(() {
                newTraining.objectives?.add(newValue.toString());
              });
            },
          );
        }
    );
  }
}
