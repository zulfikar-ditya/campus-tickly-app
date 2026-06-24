import 'task_category.dart';

/// A single to-do item. Immutable; use [copyWith] to derive updated copies
/// (e.g. toggling [isDone]).
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.category,
    required this.start,
    required this.end,
    this.description = '',
    this.emailReminder = false,
    this.isDone = false,
  });

  final String id;
  final String title;
  final TaskCategory category;
  final DateTime start;
  final DateTime end;
  final String description;
  final bool emailReminder;
  final bool isDone;

  Task copyWith({
    String? id,
    String? title,
    TaskCategory? category,
    DateTime? start,
    DateTime? end,
    String? description,
    bool? emailReminder,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      start: start ?? this.start,
      end: end ?? this.end,
      description: description ?? this.description,
      emailReminder: emailReminder ?? this.emailReminder,
      isDone: isDone ?? this.isDone,
    );
  }

  /// Build a [Task] from the backend JSON shape. Timestamps come back as UTC
  /// ISO-8601 strings and are converted to local time for display.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: (json['title'] as String?) ?? '',
      category: TaskCategory.fromApi((json['category'] as String?) ?? 'personal'),
      start: DateTime.parse(json['start_at'] as String).toLocal(),
      end: DateTime.parse(json['end_at'] as String).toLocal(),
      description: (json['description'] as String?) ?? '',
      emailReminder: (json['email_reminder'] as bool?) ?? false,
      isDone: (json['is_done'] as bool?) ?? false,
    );
  }

  /// Payload for creating/updating a task. Times are sent as UTC ISO-8601.
  /// `id` and `is_done` are intentionally omitted (the server owns the id;
  /// completion is toggled via its own endpoint).
  Map<String, dynamic> toCreateJson() => <String, dynamic>{
    'title': title,
    'category': category.apiValue,
    'description': description,
    'start_at': start.toUtc().toIso8601String(),
    'end_at': end.toUtc().toIso8601String(),
    'email_reminder': emailReminder,
  };
}
