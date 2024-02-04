import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ressc_profiler/Data/trainee.dart';

class TraineeProfile extends StatefulWidget {
  TraineeProfile({super.key, required this.trainee});
  Trainee trainee;

  @override
  State<TraineeProfile> createState() => _TraineeProfile();
}

class _TraineeProfile extends State<TraineeProfile>{

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.trainee.nameFirst!} ${widget.trainee.nameMiddle!.substring(0,1)}. ${widget.trainee.nameLast!}"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 5,
                  child: Image.asset("assets/media/profile_icon.gif")
              ),
              Expanded(
                  flex: 15,
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: "First Name",
                        ),
                      )
                    ],
                  )
              )
            ],
          )
        ],
      ),
    );
  }
}
