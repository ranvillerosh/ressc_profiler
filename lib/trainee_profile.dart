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
    const title = "Trainee Profile";
    MaterialApp(
        title: title,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
            useMaterial3: true
        ),
        home: Scaffold(
          appBar: AppBar(
              title: Text(title)
          ),
          resizeToAvoidBottomInset: true,
          body: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  children: [
                    FadeInImage.assetNetwork(
                        placeholder: "asset/media/profile_icon.gif",
                        image: "https://firebasestorage.googleapis.com/v0/b/doh-chd-car-portal-app.appspot.com/o/Placeholders%2FprofilePicturePlaceHolder.jpg?alt=media&token=7344d9d2-156d-4fde-88eb-d1253f8b14e2"),
                    Column(
                      children: [
                        // Outlined
                      ],
                    )
                  ],
                )
              ],
            )
          )
        )
    );
    throw UnimplementedError();
  }
}