import 'package:flutter/material.dart';
import 'package:ressc_profiler/Data/trainee.dart';

class TraineeProfile extends StatefulWidget {
  final Trainee trainee;
  TraineeProfile({Key? key, required this.trainee}):super(key: key);

  @override
  State<TraineeProfile> createState() => _TraineeProfile();
}

class _TraineeProfile extends State<TraineeProfile> {

  @override
  Widget build(BuildContext context) {
    String traineeFullName = "${widget.trainee.nameFirst} ${widget.trainee.nameMiddle!.substring(0,1)}. ${widget.trainee.nameLast}";

    return Scaffold(
        appBar: AppBar(
            title: Text(traineeFullName)
        ),
        resizeToAvoidBottomInset: true,
        body: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(flex: 1,),
                    Expanded(
                        flex: 8,
                        child: FadeInImage.assetNetwork(
                            placeholder: "asset/media/profile_icon.gif",
                            image: "https://firebasestorage.googleapis.com/v0/b/doh-chd-car-portal-app.appspot.com/o/Placeholders%2FprofilePicturePlaceHolder.jpg?alt=media&token=7344d9d2-156d-4fde-88eb-d1253f8b14e2"
                        )
                    ),
                    Spacer(flex: 1,),
                    Expanded(
                        flex: 18,
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  buildNameRow("First Name", widget.trainee.nameFirst),
                                  SizedBox(width: 10),
                                  buildNameRow("Middle Name", widget.trainee.nameMiddle),
                                  SizedBox(width: 10),
                                  buildNameRow("Last Name", widget.trainee.nameLast),
                                ],
                              ),
                              Row(
                                children: [
                                  buildOccupationRow("Position", widget.trainee.position),
                                  SizedBox(width: 10),
                                  buildOccupationRow("Office", widget.trainee.position)
                                ],
                              )
                            ],
                          ),
                        )
                    ),
                    Spacer(flex: 1,)
                  ],
                )
              ],
            )
        )
    );

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