import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursework_project/screens/Backend/reminder.dart';
import 'package:test/test.dart';

void main() {
  group('Reminder', () {
    final timestamp = Timestamp.fromDate(DateTime(2024, 5, 7, 1, 31, 56));
    test('creates a Reminder object', () {
      final reminder = Reminder(
          title: 'Test Reminder',
          completed: false,
          description: 'Description',
          dateTime: timestamp);

      expect(reminder.title, 'Test Reminder');
      expect(reminder.completed, false);
      expect(reminder.description, 'Description');
      expect(reminder.dateTime, timestamp);
    });

    test('converts a Reminder object to a Map', () {
      final reminder = Reminder(
          title: 'Test Reminder',
          completed: false,
          description: 'Description',
          dateTime: timestamp);
      final map = reminder.toJson();

      expect(map, {
        'title': 'Test Reminder',
        'completed': false,
        'description': 'Description',
        'dateTime': timestamp
      });
    });

    test('creates a Reminder object from a Map', () {
      final map = {
        'title': 'Test Reminder',
        'completed': false,
        'description': 'Description',
        'dateTime': timestamp
      };
      final reminder = Reminder.fromJson(map);

      expect(reminder.title, 'Test Reminder');
      expect(reminder.completed, false);
      expect(reminder.description, 'Description');
      expect(reminder.dateTime, timestamp);
    });

    test('copies a Reminder object', () {
      final reminder = Reminder(
          title: 'Test Reminder',
          completed: false,
          description: 'Description',
          dateTime: timestamp);
      final copiedReminder = reminder.copyWith();

      expect(copiedReminder.title, 'Test Reminder');
      expect(copiedReminder.completed, false);
      expect(copiedReminder.description, 'Description');
      expect(copiedReminder.dateTime, timestamp);
    });
  });
}
