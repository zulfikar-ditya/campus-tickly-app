// Pure unit tests for the reminder eligibility rule and id derivation.

import 'package:campus_tickly/core/notifications/reminder_scheduler.dart';
import 'package:campus_tickly/models/task.dart';
import 'package:campus_tickly/models/task_category.dart';
import 'package:flutter_test/flutter_test.dart';

Task _task({
  String id = 't1',
  bool emailReminder = true,
  bool isDone = false,
  required DateTime start,
}) {
  return Task(
    id: id,
    title: 'Task',
    category: TaskCategory.work,
    start: start,
    end: start.add(const Duration(hours: 1)),
    emailReminder: emailReminder,
    isDone: isDone,
  );
}

void main() {
  final DateTime now = DateTime(2026, 6, 30, 12, 0);

  test('eligible when reminder on, not done, and fire time is in the future', () {
    final Task task = _task(start: now.add(const Duration(hours: 1)));
    expect(isReminderEligible(task, now: now), isTrue);
  });

  test('not eligible when the reminder toggle is off', () {
    final Task task =
        _task(emailReminder: false, start: now.add(const Duration(hours: 1)));
    expect(isReminderEligible(task, now: now), isFalse);
  });

  test('not eligible when the task is already done', () {
    final Task task = _task(isDone: true, start: now.add(const Duration(hours: 1)));
    expect(isReminderEligible(task, now: now), isFalse);
  });

  test('not eligible when the fire time (start - 10m) is already past', () {
    // Starts in 5 minutes -> fire time is 5 minutes ago.
    final Task task = _task(start: now.add(const Duration(minutes: 5)));
    expect(isReminderEligible(task, now: now), isFalse);
  });

  test('notification id is stable and positive for a given task id', () {
    expect(reminderNotificationId('abc-123'), reminderNotificationId('abc-123'));
    expect(reminderNotificationId('abc-123'), greaterThanOrEqualTo(0));
  });
}
