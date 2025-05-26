class Task {
  final int? id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  DateTime? reminderDateTime;
  DateTime createdAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.reminderDateTime,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'reminderDateTime': reminderDateTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      reminderDateTime: map['reminderDateTime'] != null
          ? DateTime.parse(map['reminderDateTime'])
          : null,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
} 