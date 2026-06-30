// Verifies TaskController keeps the reminder scheduler in sync across the
// task lifecycle, using a fake scheduler and a fake repository (no network).

import 'package:campus_tickly/controllers/task_controller.dart';
import 'package:campus_tickly/core/network/api_client.dart';
import 'package:campus_tickly/core/notifications/reminder_scheduler.dart';
import 'package:campus_tickly/core/storage/token_storage.dart';
import 'package:campus_tickly/data/task_repository.dart';
import 'package:campus_tickly/models/task.dart';
import 'package:campus_tickly/models/task_category.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeScheduler implements ReminderScheduler {
  final List<String> scheduledIds = <String>[];
  final List<String> cancelledIds = <String>[];
  int syncAllCount = 0;
  int cancelAllCount = 0;
  Task? lastScheduled;
  List<Task> lastSynced = const <Task>[];

  @override
  Future<void> schedule(Task task) async {
    scheduledIds.add(task.id);
    lastScheduled = task;
  }

  @override
  Future<void> cancel(String taskId) async => cancelledIds.add(taskId);

  @override
  Future<void> syncAll(List<Task> tasks) async {
    syncAllCount++;
    lastSynced = tasks;
  }

  @override
  Future<void> cancelAll() async => cancelAllCount++;
}

/// In-memory repository. Echoes drafts back and tracks them so [setDone] can
/// return an updated copy, mirroring the real backend's behaviour.
class _FakeRepo extends TaskRepository {
  _FakeRepo() : super(ApiClient(TokenStorage()));

  final Map<String, Task> _store = <String, Task>{};
  List<Task> seed = <Task>[];

  @override
  Future<List<Task>> fetchTasks() async => seed;

  @override
  Future<Task> create(Task draft) async {
    _store[draft.id] = draft;
    return draft;
  }

  @override
  Future<Task> update(String id, Task draft) async {
    _store[id] = draft;
    return draft;
  }

  @override
  Future<Task> setDone(String id, bool isDone) async {
    final Task updated = _store[id]!.copyWith(isDone: isDone);
    _store[id] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async => _store.remove(id);
}

Task _task({String id = 't1', bool isDone = false}) => Task(
  id: id,
  title: 'Task $id',
  category: TaskCategory.work,
  start: DateTime(2026, 7, 1, 9),
  end: DateTime(2026, 7, 1, 10),
  emailReminder: true,
  isDone: isDone,
);

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues(<String, String>{}));

  late _FakeRepo repo;
  late _FakeScheduler scheduler;
  late TaskController controller;

  setUp(() {
    repo = _FakeRepo();
    scheduler = _FakeScheduler();
    controller = TaskController(repo, reminders: scheduler);
  });

  test('create schedules the new task', () async {
    await controller.create(_task());
    expect(scheduler.scheduledIds, <String>['t1']);
  });

  test('update re-schedules the task', () async {
    await controller.create(_task());
    await controller.update(_task());
    expect(scheduler.scheduledIds, <String>['t1', 't1']);
  });

  test('toggleDone re-schedules with the now-completed task', () async {
    await controller.create(_task());
    scheduler.scheduledIds.clear();

    await controller.toggleDone(_task(), true);

    expect(scheduler.scheduledIds, <String>['t1']);
    expect(scheduler.lastScheduled!.isDone, isTrue);
  });

  test('delete cancels the task reminder', () async {
    await controller.create(_task());
    await controller.delete(_task());
    expect(scheduler.cancelledIds, <String>['t1']);
  });

  test('fetchTasks reconciles all reminders', () async {
    repo.seed = <Task>[_task(id: 'a'), _task(id: 'b')];
    await controller.fetchTasks();
    expect(scheduler.syncAllCount, 1);
    expect(scheduler.lastSynced.map((Task t) => t.id), <String>['a', 'b']);
  });

  test('reset cancels every reminder on sign-out', () {
    controller.reset();
    expect(scheduler.cancelAllCount, 1);
  });
}
