import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  final String title;
  final bool completed;
  final String description;
  final Timestamp dateTime;

  Reminder(
      {required this.title,
      required this.completed,
      required this.description,
      required this.dateTime});

  Reminder.fromJson(Map<String, Object?> json)
      : this(
            title: json['title']! as String,
            completed: json['completed']! as bool,
            description: json['description'] as String,
            dateTime: json['dateTime'] as Timestamp);

  Reminder copyWith(
      {String? title,
      bool? completed,
      String? description,
      Timestamp? dateTime}) {
    return Reminder(
        title: title ?? this.title,
        completed: completed ?? this.completed,
        description: description ?? this.description,
        dateTime: dateTime ?? this.dateTime);
  }

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'completed': completed,
      'description': description,
      'dateTime': dateTime
    };
  }
}

