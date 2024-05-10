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
This file defines the class :samp:`ReminderProvider` which extends the :samp:`ChangeNotifier` class. This class is responsible for managing reminders. This lass contains the logic for managing reminders within the Flutter application for adding, updating and deleting reminders. It ensures that the UI components respond to any changes made. This is different to "Reminder Services" as it does not connect to the Firestore Database directly.

This file imports 3 packages, :samp:`flutter/material.dart` for the Flutter UI components, :samp:`reminder.services` and `cloud_firestore.dart` for Firestore interaction

The properties that it uses is :samp:`_reminders` which is a list to hold reminder. It also uses a Getter method called :samp:`reminders` which is used to access that list.

There are 3 methods in this file. :samp:`addReminder` which adds a new reminder to the :samp:`_reminders' list and notifies listeners about the change. :samp:`updateReminder` which updates an existing reminder in the :samp:`_reminders` list with the provided reminder data and notifies listeners about the change. :samp:`deleteReminder` which deletes a reminder from the :samp:`_reminder` list and notifies listeners of the change.

Below is the code for this file:

.. code-block:: dart

    import 'package:flutter/material.dart';
    import 'reminder.services';
    import 'package:cloud_firestore/cloud_firestore.dart';

    class ReminderProvider extends ChangeNotifier {
      List<Reminder> _reminders = [];

      List<Reminder> get reminders => _reminders;

      void addReminder(Reminder reminder) {
        _reminders.add(reminder);
        notifyListeners();
      }

      void updateReminder(String reminderId, Reminder reminder) {
        final index = _reminders.indexWhere((r) => reminder.id == reminderId);
        if (index != -1) {
          _reminders[index] = reminder;
          notifyListeners();
        }
      }

      void deleteReminder(String reminderId) {
        _reminders.removeWhere((r) => r.id == reminderId);
        notifyListeners();
      }
    }



Setting Services
----------------
This file defines the :samp:`SettingService` class which is responsible for managing the settings within a Firestore database in a Flutter application. It contains the functionality for fetching settings ensuring that all UI components that are listening for changes are notified.

This file imports 2 necessary packages, :samp:`cloud_firestore.dart` for Firestore database interaction and :samp:`settings.dart` for the `AppSettings` class.

The file contains the constant :samp:`Settings_Collection_Ref` which defines the collection reference name in Firestore. Allowing more interaction with the setting in Firestore.

There are 2 properties of the defining class. :samp:`_firestore` which is an instance of :samp:`FirebaseFirestore` for Firestore operations. :samp:`_settingRef` which references to the collections of settings in Firestore.

The Constructor of this class initialises the :samp:`SettingService` by configuring :samp:`_settingRef` which uses converters for sterilisation and destabilisation of :samp:`AppSettings` objects to and from Firestore documents.

There are 2 methods in this class. :samp:`getSettings` method which retrieves all the settings from Firestore as a stream of :samp:`QuerySnapshot`. :samp:`updatingSetting` Method updates an existing setting within the Firestore database with the given setting ID and updated setting data.

Below is the code for this file:

.. code-block:: dart

    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:coursework_project/screens/Backend/settings.dart';

    const String Settings_Collection_Ref = "settings";
    // Doing this as it will be easier to reference this collection

    class SettingsService {
      final _firestore = FirebaseFirestore.instance;

      late final CollectionReference _settingsRef;

      SettingsService() {
        _settingsRef =
            _firestore.collection(Settings_Collection_Ref).withConverter<AppSettings>(
                fromFirestore: (snapshots, _) => AppSettings.fromJson(
                  snapshots.data()!,
                ),
                toFirestore: (settings, _) => settings.toJson());
      }

      Stream<QuerySnapshot> getSettings() {
        return _settingsRef.snapshots();
      }

      void updateSetting(String settingID, AppSettings setting) {
        _settingsRef.doc(settingID).update(setting.toJson());
      }

    }




