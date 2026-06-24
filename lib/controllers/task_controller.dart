import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../data/task_repository.dart';
import '../models/task.dart';

enum TaskListStatus { idle, loading, loaded, error }

/// Owns the authenticated user's task list and the CRUD actions against
/// [TaskRepository]. The home view observes [tasks] and applies its own
/// date/category/search filtering on top for an instant UI.
class TaskController extends ChangeNotifier {
  TaskController(this._repository, {this.onUnauthorized});

  final TaskRepository _repository;

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
    });
  }

  Future<bool> update(Task draft) async {
    return _mutate(() async {
      final Task updated = await _repository.update(draft.id, draft);
      _tasks = <Task>[
        for (final Task t in _tasks) t.id == updated.id ? updated : t,
      ];
    });
  }

  Future<bool> toggleDone(Task task, bool isDone) async {
    return _mutate(() async {
      final Task updated = await _repository.setDone(task.id, isDone);
      _tasks = <Task>[
        for (final Task t in _tasks) t.id == updated.id ? updated : t,
      ];
    });
  }

  Future<bool> delete(Task task) async {
    return _mutate(() async {
      await _repository.delete(task.id);
      _tasks = _tasks.where((Task t) => t.id != task.id).toList();
    });
  }

  /// Clear local state on sign-out.
  void reset() {
    _tasks = <Task>[];
    _status = TaskListStatus.idle;
    _error = null;
    _actionError = null;
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
