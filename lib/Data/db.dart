import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


// Get a non-default Storage bucket
var storageRef = FirebaseStorage.instanceFor(bucket: "gs://doh-chd-car-portal-app.appspot.com").ref();

var database = FirebaseFirestore.instance;