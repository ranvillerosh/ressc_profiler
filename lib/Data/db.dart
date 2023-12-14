import 'package:firebase_storage/firebase_storage.dart';


// Get a non-default Storage bucket
final storageRef = FirebaseStorage.instanceFor(bucket: "gs://doh-chd-car-portal-app.appspot.com").ref();