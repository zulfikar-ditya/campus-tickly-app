import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../core/notifications/reminder_scheduler.dart';
import '../data/task_repository.dart';
import '../models/task.dart';

enum TaskListStatus { idle, loading, loaded, error }

/// Owns the authenticated user's task list and the CRUD actions against
/// [TaskRepository]. The home view observes [tasks] and applies its own
/// date/category/search filtering on top for an instant UI.
class TaskController extends ChangeNotifier {
  TaskController(this._repository, {this.reminders, this.onUnauthorized});

  final TaskRepository _repository;

  /// Keeps on-device reminder notifications in sync with the task list.
  /// Optional so the controller can run without notifications (e.g. in tests).
  final ReminderScheduler? reminders;

  /// Invoked when a request fails with 401 so the app can sign the user out.
  final VoidCallback? onUnauthorized;

  List<Task> _tasks = <Task>[];
  List<Task> get tasks => List<Task>.unmodifiable(_tasks);

  TaskListStatus _status = TaskListStatus.idle;
  TaskListStatus get status => _status;

  String? _error;
  String? get error => _error;

  /// Set after a failed mutation so the view can surface a toast. Cleared on
  /// read so it isn't shown twice.
  String? _actionError;
  String? consumeActionError() {
    final String? e = _actionError;
    _actionError = null;
    return e;
  }

  Future<void> fetchTasks() async {
    _status = TaskListStatus.loading;
    _error = null;
    notifyListeners();
    try {
      _tasks = await _repository.fetchTasks();
      _status = TaskListStatus.loaded;
      await reminders?.syncAll(_tasks);
    } on ApiException catch (e) {
      _status = TaskListStatus.error;
      _error = e.message;
      _maybeUnauthorized(e);
    } catch (_) {
      _status = TaskListStatus.error;
      _error = 'Could not load your tasks.';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> create(Task draft) async {
    return _mutate(() async {
      final Task created = await _repository.create(draft);
      _tasks = <Task>[..._tasks, created];
      await reminders?.schedule(created);
    });
  }

  Future<bool> update(Task draft) async {
    return _mutate(() async {
      final Task updated = await _repository.update(draft.id, draft);
      _tasks = <Task>[
        for (final Task t in _tasks) t.id == updated.id ? updated : t,
      ];
      await reminders?.schedule(updated);
    });
  }

  Future<bool> toggleDone(Task task, bool isDone) async {
    return _mutate(() async {
      final Task updated = await _repository.setDone(task.id, isDone);
      _tasks = <Task>[
        for (final Task t in _tasks) t.id == updated.id ? updated : t,
      ];
      // Completing a task drops its reminder; un-completing re-schedules it.
      await reminders?.schedule(updated);
    });
  }

  Future<bool> delete(Task task) async {
    return _mutate(() async {
      await _repository.delete(task.id);
      _tasks = _tasks.where((Task t) => t.id != task.id).toList();
      await reminders?.cancel(task.id);
    });
  }

  /// Clear local state on sign-out.
  void reset() {
    _tasks = <Task>[];
    _status = TaskListStatus.idle;
    _error = null;
    _actionError = null;
    reminders?.cancelAll();
    notifyListeners();
  }

  Future<bool> _mutate(Future<void> Function() action) async {
    try {
      await action();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _actionError = e.message;
      _maybeUnauthorized(e);
      return false;
    } catch (_) {
      _actionError = 'Something went wrong. Please try again.';
      return false;
    }
  }

  void _maybeUnauthorized(ApiException e) {
    if (e.isUnauthorized) onUnauthorized?.call();
  }
}
