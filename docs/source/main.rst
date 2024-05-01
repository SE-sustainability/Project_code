Main
=======

The Main File is code that is only used to Launch the app and configure a few settings. On the app its used to Launch our 'Home Page' which is the 'Mode Page'. This allows users to choose a mode for the reminders or create a new mode. 

.. code-block:: console

   put some code here <3


Creating recipes
----------------

To retrieve a list of random ingredients,
you can use the ``lumache.get_random_ingredients()`` function:

.. autofunction:: lumache.get_random_ingredients

The ``kind`` parameter should be either ``"meat"``, ``"fish"``,
or ``"veggies"``. Otherwise, :py:func:`lumache.get_random_ingredients`
will raise an exception.

.. autoexception:: lumache.InvalidKindError

For example:

>>> import lumache
>>> lumache.get_random_ingredients()
['shells', 'gorgonzola', 'parsley']


Below is the Main.dart file in full.

.. code-block:: console
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
