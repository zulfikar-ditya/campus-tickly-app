// Pure unit tests for Task <-> backend JSON mapping.

import 'package:campus_tickly/models/task.dart';
import 'package:campus_tickly/models/task_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Task.fromJson maps backend fields and converts UTC to local', () {
    final Task task = Task.fromJson(<String, dynamic>{
      'id': 'abc-123',
      'title': 'Design review',
      'category': 'work',
      'description': 'Review the export',
      'start_at': '2026-06-25T09:00:00.000Z',
      'end_at': '2026-06-25T10:00:00.000Z',
      'email_reminder': true,
      'is_done': false,
    });

    expect(task.id, 'abc-123');
    expect(task.title, 'Design review');
    expect(task.category, TaskCategory.work);
    expect(task.emailReminder, isTrue);
    expect(task.isDone, isFalse);
    expect(task.start.toUtc(), DateTime.utc(2026, 6, 25, 9));
    expect(task.end.toUtc(), DateTime.utc(2026, 6, 25, 10));
  });

  test('Task.fromJson falls back to personal for an unknown category', () {
    final Task task = Task.fromJson(<String, dynamic>{
      'id': '1',
      'title': 't',
      'category': 'nonsense',
      'description': null,
      'start_at': '2026-06-25T09:00:00.000Z',
      'end_at': '2026-06-25T10:00:00.000Z',
      'email_reminder': false,
      'is_done': false,
    });

    expect(task.category, TaskCategory.personal);
    expect(task.description, '');
  });

  test('toCreateJson emits UTC ISO timestamps and the API category value', () {
    final Task task = Task(
      id: 'ignored',
      title: 'Standup',
      category: TaskCategory.meeting,
      start: DateTime.utc(2026, 12, 1, 9),
      end: DateTime.utc(2026, 12, 1, 9, 15),
      description: 'daily',
      emailReminder: true,
    );

    final Map<String, dynamic> json = task.toCreateJson();

    expect(json['title'], 'Standup');
    expect(json['category'], 'meeting');
    expect(json['email_reminder'], true);
    expect(json['start_at'], '2026-12-01T09:00:00.000Z');
    expect(json['end_at'], '2026-12-01T09:15:00.000Z');
    expect(json.containsKey('id'), isFalse);
    expect(json.containsKey('is_done'), isFalse);
  });
}
