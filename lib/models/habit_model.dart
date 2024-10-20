class Habit {
  int? id;
  String name;
  String description;
  String frequency;
  String reminderTime;

  Habit({
    this.id,
    required this.name,
    required this.description,
    required this.frequency,
    required this.reminderTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'frequency': frequency,
      'reminder_time': reminderTime,
    };
  }
}
