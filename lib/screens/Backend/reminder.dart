class Reminder {
  final String description;
  final bool completed;

  Reminder({
    required this.description,
    required this.completed,
  });

  Reminder.fromJson(Map<String, Object?> json)
      : this(
          description: json['description']! as String,
          completed: json['completed']! as bool,
        );

  Reminder copyWith({
    String? description,
    bool? completed,
  }) {
    return Reminder(
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'description': description,
      'completed': completed,
    };
  }
}
