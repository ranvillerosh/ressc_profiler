import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'Data/trainee.dart';
import 'Data/training.dart';

class RESSCDirectory extends StatefulWidget {
  const RESSCDirectory({super.key, required this.title});

  final String title;

  @override
  State<RESSCDirectory> createState() => _RESSCDirectory();
}

class _RESSCDirectory extends State<RESSCDirectory> {
  bool shadowColor = false;
  double? scrolledUnderElevation;

  @override
  Widget build(BuildContext context) {

    List<Trainee> traineeList = [];

    var sampleTraineeData = Trainee("nameFirst","nameMiddle", "nameLast", DateTime.now(), "contactNumber1", "contactNumber2", "emailPersonal", "emailOfficial", "https://i.pinimg.com/originals/25/78/61/25786134576ce0344893b33a051160b1.jpg", Training());
    traineeList.add(sampleTraineeData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RESSC Directory'),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
      ),
      body: GridView.builder(
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
                  debugPrint('Card tapped.');
                },
                child: Center(
                  child: SizedBox.expand(
                    child: Row (
                      children: [
                      Expanded(
                          flex: 4,
                          child:
                          FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            fit: BoxFit.fill,
                            imageScale: 1.0,
                            image: traineeList[index].profilePicture!,
                          )
                      ),
                        Spacer(
                          flex: 1,
                        ),
                        Expanded(
                            flex: 9,
                            child:
                            AutoSizeText(
                              'A card that can be tapped'
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


}