import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ressc_profiler/Data/office.dart';
import 'package:transparent_image/transparent_image.dart';
import 'Data/trainee.dart';
import 'Data/training.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RESSCDirectory extends StatefulWidget {
  const RESSCDirectory({super.key, required this.title});
  final String title;

  @override
  State<RESSCDirectory> createState() => _RESSCDirectory();
}

class _RESSCDirectory extends State<RESSCDirectory> with TickerProviderStateMixin {
  bool shadowColor = false;
  double? scrolledUnderElevation;

  // Get a non-default Storage bucket
  final storageRef = FirebaseStorage.instanceFor(bucket: "gs://doh-chd-car-portal-app.appspot.com").ref();

  
  @override
  Widget build(BuildContext context) {
    List<Trainee> traineeList = [];
    var sampleTraineeData = Trainee("nameFirst","nameMiddle", "nameLast", DateTime.now(), "contactNumber1", "contactNumber2", "emailPersonal", "emailOfficial", "https://firebasestorage.googleapis.com/v0/b/doh-chd-car-portal-app.appspot.com/o/Placeholders%2FprofilePicturePlaceHolder.jpg?alt=media&token=7344d9d2-156d-4fde-88eb-d1253f8b14e2", "religionChristian", Office("SampleOffice"),Training("Sample Disease Surveillance and Data Management Training","SDSDMT"));
    traineeList.add(sampleTraineeData);

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
                  sampleTraineeData.showProfile(context);
                  debugPrint('Card tapped.');
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
                          FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: "https://firebasestorage.googleapis.com/v0/b/doh-chd-car-portal-app.appspot.com/o/Placeholders%2FprofilePicturePlaceHolder.jpg?alt=media&token=7344d9d2-156d-4fde-88eb-d1253f8b14e2"
                          )
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
                                  "A card that can be tapped"
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
    var profilePicURL = Uri.parse(await storageRef.child(imageURL).getDownloadURL());
    return profilePicURL;
  }
}