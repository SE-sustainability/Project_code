Main
=======

The Main File is code that is only used to Launch the app and configure a few settings. On the app its used to Launch our 'Home Page' which is the 'Mode Page'. This allows users to choose a mode for the reminders or create a new mode.

Below is the Main.dart file in full.

.. code-block:: dart


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










.. autosummary::
   :toctree: generated

   lumache
