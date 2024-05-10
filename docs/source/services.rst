Services
=========

Mode Services
-------------
This file contains all of the create, read, update and delete operations for managing modes within a Firestore database, by providing methods for interacting with Firestoew to perform these operations within :samp:`mode` object. It also includes a placeholder method for navigating logic, which is implemented to store values when screens are being switched.

The file imports 2 packages. :samp:`cloud_firestore.dart` to allow Firestore interaction and :samp:`modes.dart` for the :samp:`mode` class.

The :samp:`ModeService` class initilises a reference to the Firestore collection named "modes". It configures this reference to use converters to serialise and deserialise :samp:`Mode` objects to and From Firestore documents.

There are 5 methods within this file, 4 of which are used to allow :samp:`Mode` objects to interact with Firestore and the final one is a navigation Placeholder. :samp:`getMode` Method fetches all the modes that are stored in Firebase and return a list of :samp:`Mode` objects. :samp:`addMode` method adds a new mode to the Firestore database. :samp:`updateMode` Method updates an existing mode by taking the id of the mode to be updated and updating it in the Firestore database. :samp:`deleteMode` method deletsd a mode from the Firestore database by taking the id of the mode to be deleted. The :samp:`navigateToModeOptions` method provides a placeholder for navigation logic to the mode options page.

Below is the code for the file:

.. code-block:: dart

    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:coursework_project/screens/Backend/modes.dart';

    const String Mode_Collection_Ref = "modes";

    class ModeService {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      late CollectionReference _modesRef = FirebaseFirestore.instance.collection('modes');

      ModeService() {
        _modesRef = _firestore.collection(Mode_Collection_Ref).withConverter<Mode>(
            fromFirestore: (snapshot, _) => Mode.fromJson(snapshot.data()!),
            toFirestore: (mode, _) => mode.toJson());
      }

      Future<List<Mode>> getModes() async {
        QuerySnapshot querySnapshot = await _firestore.collection('modes').get();
        List<Mode> modes = querySnapshot.docs.map((doc) => Mode.fromJson(doc.data() as Map<String, dynamic>)).toList();
        return modes;
      }

      // Add mode to database
      void addMode(Mode mode) async {
        _modesRef.add(mode);
      }

      // Update mode

      Future<void> updateMode(String modeId, Mode updatedMode) async {
        await _firestore.collection('modes').doc(modeId).set(updatedMode.toJson());
      }

      // Delete mode
      void deleteMode(String modeId) {
        _modesRef.doc(modeId).delete();
      }

      // Navigate to mode options page
      void navigateToModeOptions(String modeId) {
        // You can implement navigation logic here
      }
    }



Reminder Services
------------------
This file defines a :samp:`ReminderService` class which is responsible for managing reminders (Creating, reading, updating and deleting reminders) within a Firestore database. It provides methods to allow Firetore to perform these operations for :samp:`Reminder` object and also provides a placeholder for navigation logic. 

The file imports 2 packages. :samp:`cloud_firestore.dart` to allow Firestore interaction and :samp:`reminder.dart` for the :samp:`reminder` class.

The :samp:`ReminderService` class initilises a reference to the Firestore collection named "reminders". It configures this reference to use converters to serialise and deserialise :samp:`Reminder` objects to and From Firestore documents.

There are 5 methods within this file, 4 of which are used to allow :samp:`Reminder` objects to interact with Firestore and the final one is a navigation Placeholder. :samp:`getReminders` Method fetches all the reminders that are stored in Firebase and return a list of :samp:`Reminder` objects. :samp:`addReminder` method adds a new reminder to the Firestore database. :samp:`updateReminder` Method updates an existing reminder by taking the id of the reminder to be updated and updating it in the Firestore database. :samp:`deleteReminder` method deletes a reminder from the Firestore database by taking the id of the reminder to be deleted. The :samp:`navigateToReminderPage` method provides a placeholder for navigation logic to the reminder page.

Below is the code of the file:

.. code-block:: dart

    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:coursework_project/screens/Backend/reminder.dart';

    const String Reminder_Collection_Ref = "reminders";

    class ReminderService {
      final _firestore = FirebaseFirestore.instance;

      late final CollectionReference _remindersRef;

      ReminderService() {
        _remindersRef =
            _firestore.collection(Reminder_Collection_Ref).withConverter<Reminder>(
                fromFirestore: (snapshots, _) => Reminder.fromJson(
                      snapshots.data()!,
                    ),
                toFirestore: (reminder, _) => reminder.toJson());
      }

      // Get data from Firestore
      Stream<QuerySnapshot> getReminders() {
        return _remindersRef.snapshots();
      }

      // Add reminder to database
      Future<String> addReminder(Reminder reminder) async {
        try {
          DocumentReference reminderRef = await _remindersRef.add(reminder);
          return reminderRef.id;
        } catch (error) {
          print('Error adding reminder: $error');
          rethrow;
        }
      }

      // Update reminder
      void updateReminder(String reminderId, Reminder reminder) {
        _remindersRef.doc(reminderId).update(reminder.toJson());
      }

      // Delete reminder
      void deleteReminder(String reminderId) {
        _remindersRef.doc(reminderId).delete();
      }

      // Placeholder method for navigating to the reminder page
      void _navigateToReminderPage(String reminderId) {
        // You can implement navigation logic here
      }
    }


Reminder Provider
-----------------



Setting Services
----------------
