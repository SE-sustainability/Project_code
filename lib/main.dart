// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'screens/ModePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize Firestore

  runApp(MyApp());
  // FirebaseFirestore.instance.settings =
  //     const Settings(persistenceEnabled: true);
}

class MyApp extends StatelessWidget {
  // final FirebaseFirestore
  //     firestore; // Declare a variable to hold FirebaseFirestore instance

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ModePage(), // Adjusted reference to HomeScreen
    );
  }
}
