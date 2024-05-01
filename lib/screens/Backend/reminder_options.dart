class Reminder_Options {
  final String title;
  final String description;

  Reminder_Options({
    required this.title,
    required this.description,
  });

  Reminder_Options.fromJson(Map<String, Object?> json)
      : this(
          title: json['title']! as String,
          description: json['description']! as String,
        );

  Reminder_Options copyWith({
    String? title,
    bool? completed,
  }) {
    return Reminder_Options(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
