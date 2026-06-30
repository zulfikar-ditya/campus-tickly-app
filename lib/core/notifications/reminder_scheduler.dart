import '../../models/task.dart';

/// How long before a task's start time the reminder notification fires.
const Duration kReminderLeadTime = Duration(minutes: 10);

/// Schedules / cancels on-device reminder notifications for tasks.
///
/// Abstracted so [TaskController] can be unit-tested with a fake, free of
/// platform channels. The concrete implementation is [LocalNotificationService].
abstract class ReminderScheduler {
  /// (Re)schedule the reminder for [task]. Implementations cancel any existing
  /// notification for the task first, then schedule a new one only if the task
  /// is eligible (see [isReminderEligible]); otherwise the task ends up with no
  /// pending notification.
  Future<void> schedule(Task task);

  /// Cancel any pending reminder for the task with [taskId].
  Future<void> cancel(String taskId);

  /// Reconcile the OS against [tasks]: drop everything, then schedule each
  /// eligible task. Idempotent — safe to call on every load.
  Future<void> syncAll(List<Task> tasks);

  /// Cancel every pending reminder (e.g. on sign-out).
  Future<void> cancelAll();
}

/// A task earns a reminder when its toggle is on, it isn't done, and its fire
/// time still lies in the future. [now] is injectable for tests.
bool isReminderEligible(Task task, {DateTime? now}) {
  if (!task.emailReminder || task.isDone) return false;
  final DateTime fireAt = task.start.subtract(kReminderLeadTime);
  return fireAt.isAfter(now ?? DateTime.now());
}

/// Stable, positive 31-bit notification id derived from a task's string id, so
/// the same task always maps to the same notification slot.
int reminderNotificationId(String taskId) => taskId.hashCode & 0x7fffffff;
