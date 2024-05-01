class Reminder {
  final String title;
  final bool completed;

  Reminder({
    required this.title,
    required this.completed,
  });

  Reminder.fromJson(Map<String, Object?> json)
      : this(
          title: json['title']! as String,
          completed: json['completed']! as bool,
        );

  Reminder copyWith({
    String? title,
    bool? completed,
  }) {
    return Reminder(
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'completed': completed,
    };
  }
}
