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
}
