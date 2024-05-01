import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursework_project/screens/Backend/reminder.dart';

const String Reminder_Collection_Ref = "reminders";
//Doing this as it will be easier to reference this collection

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

  //Get data from firestore
  Stream<QuerySnapshot> getReminders() {
    return _remindersRef.snapshots();
  }

  //add reminder to database
  Future<String> addReminder(Reminder reminder) async {
    try {
      DocumentReference reminderRef = await _remindersRef.add(reminder);
      return reminderRef.id;
      // _remindersRef.add(reminder);
    } catch (error) {
      print('Error adding reminder: $error');
      rethrow;
    }
  }

  // update reminder
  void updateReminder(String reminderId, Reminder reminder) {
    _remindersRef.doc(reminderId).update(reminder.toJson());
  }

  // delete reminder
  void deleteReminder(String reminderId) {
    _remindersRef.doc(reminderId).delete();
  }

  void _navigateToReminderPage(String reminderId) {
    _navigateToReminderPage(reminderId);
  }
}
