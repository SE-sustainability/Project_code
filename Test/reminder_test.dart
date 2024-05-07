import 'package:coursework_project/screens/Backend/reminder.dart';
import 'package:test/test.dart';

void main() {
  group('Reminder', () {
    test('creates a Reminder object', () {
      final reminder = Reminder(
          title: 'Test Reminder', completed: false, description: 'Description');

      expect(reminder.title, 'Test Reminder');
      expect(reminder.completed, false);
      expect(reminder.description, 'Description');
    });

    test('converts a Reminder object to a Map', () {
      final reminder = Reminder(
          title: 'Test Reminder', completed: false, description: 'Description');
      final map = reminder.toJson();

      expect(map, {
        'title': 'Test Reminder',
        'completed': false,
        'description': 'Description'
      });
    });

    test('creates a Reminder object from a Map', () {
      final map = {
        'title': 'Test Reminder',
        'completed': false,
        'description': 'Description'
      };
      final reminder = Reminder.fromJson(map);

      expect(reminder.title, 'Test Reminder');
      expect(reminder.completed, false);
      expect(reminder.description, 'Description');
    });

    test('copies a Reminder object', () {
      final reminder = Reminder(
          title: 'Test Reminder', completed: false, description: 'Description');
      final copiedReminder = reminder.copyWith();

      expect(copiedReminder.title, 'Test Reminder');
      expect(copiedReminder.completed, false);
      expect(copiedReminder.description, 'Description');
    });
  });
}
