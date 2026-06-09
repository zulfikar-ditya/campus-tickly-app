import '../models/task.dart';
import '../models/task_category.dart';

/// In-memory sample tasks mirroring the home screen in the design
/// (5 tasks, 3 completed). Frontend-only stand-in until real data exists.
List<Task> mockTasks() {
  final DateTime today = DateTime.now();
  DateTime at(int hour, int minute) =>
      DateTime(today.year, today.month, today.day, hour, minute);

  return <Task>[
    Task(
      id: '1',
      title: 'Finish API documentation',
      category: TaskCategory.work,
      start: at(14, 0),
      end: at(15, 0),
      description:
          'Complete the REST API reference including auth flows and examples.',
      isDone: true,
    ),
    Task(
      id: '2',
      title: 'Review pull requests',
      category: TaskCategory.work,
      start: at(16, 30),
      end: at(17, 0),
    ),
    Task(
      id: '3',
      title: 'Team standup meeting',
      category: TaskCategory.meeting,
      start: at(9, 0),
      end: at(9, 30),
      isDone: true,
    ),
    Task(
      id: '4',
      title: 'Update database schema',
      category: TaskCategory.backend,
      start: at(11, 0),
      end: at(12, 0),
      isDone: true,
    ),
    Task(
      id: '5',
      title: 'Reply to client email',
      category: TaskCategory.personal,
      start: at(18, 0),
      end: at(18, 30),
    ),
  ];
}
