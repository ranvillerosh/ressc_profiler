import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
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
    var sampleTraineeData = Trainee("nameFirst","nameMiddle", "nameLast", DateTime.now(), "contactNumber1", "contactNumber2", "emailPersonal", "emailOfficial", "Placeholders/profilePicturePlaceHolder.jpg", Training());
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
                  _showUserProfile(sampleTraineeData);
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
    var profilePicURL = Uri.parse(await storageRef.child(imageURL).getDownloadURL() as String);
    return profilePicURL;
  }

  Future<void> _showUserProfile(Trainee traineeData) async {
    // GifController _controller = GifController(vsync: vsync);
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.all(15),
            child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: Scaffold(
                  backgroundColor: Color(Theme.of(context).canvasColor.green),
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                    title: const Text("Trainee Information"),
                  ),
                  body: Column(
                    children: [
                      //Trainee Information Details || Bio-data
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child:
                            FadeInImage.assetNetwork(
                              placeholder: "assets/media/profile_icon.gif",
                              image: "https://firebasestorage.googleapis.com/v0/b/doh-chd-car-portal-app.appspot.com/o/Placeholders%2FprofilePicturePlaceHolder.jpg?alt=media&token=7344d9d2-156d-4fde-88eb-d1253f8b14e2",),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 11,
                            child:
                            Column(
                              children: [
                                Row(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "First Name"
                                      ),

                                    )
                                  ],
                                )
                              ],
                            )
                          )
                        ]
                      ),
                      //Trainee Contact Details
                      Row(),
                      //Training List
                      Column()
                    ],
                  )
                )
            ),
        );
      },
    );
  }
}