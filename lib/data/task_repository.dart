import '../core/network/api_client.dart';
import '../models/task.dart';

/// Data access for the `/tasks` endpoints. All requests are implicitly scoped
/// to the authenticated user by the backend.
class TaskRepository {
  TaskRepository(this._api);

  final ApiClient _api;

  /// Fetch the user's tasks. Filtering/sorting for the home view is done
  /// client-side, so we pull a generous page in one request.
  Future<List<Task>> fetchTasks() async {
    final dynamic data = await _api.get(
      '/tasks',
      query: <String, dynamic>{'perPage': 200, 'sort': 'start_at', 'sortDirection': 'asc'},
    );
    final List<dynamic> items = (data as Map<String, dynamic>)['data'] as List<dynamic>;
    return items
        .map((dynamic e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Task> create(Task draft) async {
    final dynamic data = await _api.post('/tasks', body: draft.toCreateJson());
    return Task.fromJson(data as Map<String, dynamic>);
  }

  Future<Task> update(String id, Task draft) async {
    final dynamic data = await _api.patch('/tasks/$id', body: draft.toCreateJson());
    return Task.fromJson(data as Map<String, dynamic>);
  }

  Future<Task> setDone(String id, bool isDone) async {
    final dynamic data = await _api.patch(
      '/tasks/$id/complete',
      body: <String, dynamic>{'is_done': isDone},
    );
    return Task.fromJson(data as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    await _api.delete('/tasks/$id');
  }
}
