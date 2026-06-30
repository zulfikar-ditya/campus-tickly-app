# Local notification reminders — design

**Date:** 2026-06-30
**Status:** Approved (pending spec review)

## Summary

When a task's reminder toggle is ON, the device shows a **local notification 10 minutes
before** the task's start time. This reuses the existing reminder toggle on the Create/Edit
Task form — no new form field. The camera feature the user floated is dropped: it has no
design and no clear fit in a to-do app.

## Goals

- A scheduled, on-device notification fires 10 minutes before an eligible task starts.
- No backend changes; the existing `email_reminder` flag drives local scheduling too.
- Scheduling stays in sync with the task lifecycle (create / edit / complete / delete / reload).
- Controller scheduling logic is unit-testable without platform channels.

## Non-goals (YAGNI)

- Deep-linking from a tapped notification to the specific task (tap just opens the app).
- A separate, independent "notify on device" toggle.
- User-configurable lead time (fixed at 10 minutes).
- Recurring / repeating reminders.
- Desktop or web notifications.

## Platforms

Android and iOS only (the real phone targets). Windows / web / desktop are out of scope.

## Architecture

Fits the existing MVC + Provider layering. New code lives in `lib/core/notifications/`.

### 1. `ReminderScheduler` (abstract interface)

```dart
abstract class ReminderScheduler {
  Future<void> schedule(Task task);   // cancel + (re)schedule, or just cancel if ineligible
  Future<void> cancel(String taskId);
  Future<void> syncAll(List<Task> tasks);
}
```

Keeps `TaskController` testable with a fake; no platform channels in unit tests.

### 2. `LocalNotificationService implements ReminderScheduler`

Wraps `flutter_local_notifications`. Responsibilities:

- `init()` — initialize the plugin, initialize timezone data (`timezone` + `flutter_timezone`
  to resolve the device's IANA zone and set `tz.local`), and request permissions
  (Android 13+ `POST_NOTIFICATIONS`; iOS alert/badge/sound).
- `schedule(task)` — cancel the task's existing notification, then schedule a new one **only
  if eligible** (see rule below) via `zonedSchedule` at `start − 10 min`.
- `cancel(taskId)` — cancel by the task's derived notification id.
- `syncAll(tasks)` — `cancelAll()` then `schedule` every eligible task. Idempotent;
  reconciles after app launch, reinstall, or a cleared notification store.

### 3. `TaskController` wiring

Inject a `ReminderScheduler`. Keep the OS in sync after each mutation:

| Action        | Scheduling effect                                              |
|---------------|----------------------------------------------------------------|
| `create`      | `schedule(created)`                                            |
| `update`      | `schedule(updated)`                                            |
| `toggleDone`  | `schedule(updated)` — internally cancels because `isDone`      |
| `delete`      | `cancel(task.id)`                                              |
| `fetchTasks`  | `syncAll(tasks)` after a successful load                       |
| `reset`       | `cancelAll` (sign-out clears pending reminders)                |

Scheduling failures must not break a CRUD action — wrap scheduler calls so a notification
error is logged/swallowed and the task mutation still succeeds.

### 4. `main.dart` init

Construct `LocalNotificationService`, `await service.init()` before `runApp`, and inject it
into `TaskController`.

## Eligibility rule

Schedule a notification only if **all** hold:

- `task.emailReminder == true`
- `task.isDone == false`
- `start − 10 minutes` is in the future (cannot schedule in the past)

Otherwise the task's notification is cancelled.

The fire time is `start.subtract(const Duration(minutes: 10))`.

## Notification identity

`flutter_local_notifications` uses `int` ids, but `Task.id` is a server-generated `String`.
Derive a stable 31-bit positive int from the string id (e.g. `id.hashCode & 0x7fffffff`) so
the same task always maps to the same notification id and reschedules replace cleanly.

## Notification content

- Title: the task title.
- Body: a short "starts in 10 minutes" style line (include the start time).
- Android: a dedicated channel (id `task_reminders`, name "Task reminders").

## UI change

Relabel the form toggle from "Email reminder" to **"Reminder"**, subtitle
"Get a notification before this task starts." The model field remains `emailReminder` and
still serializes to the backend's `email_reminder`, so there is no API change.

## Native configuration

- **Dependencies:** `flutter_local_notifications`, `timezone`, `flutter_timezone`.
- **Android:** add `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM`, and
  `RECEIVE_BOOT_COMPLETED` permissions and the plugin's notification receivers to the
  manifest; enable core-library desugaring in the app Gradle config (plugin requirement).
- **iOS:** request alert/badge/sound permission at init.

## Testing

- Unit-test `TaskController` against a fake `ReminderScheduler`, asserting the right
  schedule/cancel calls on each transition:
  - create with reminder ON + future start → `schedule` called
  - toggleDone → reminder effectively cancelled (eligibility false)
  - delete → `cancel` called
  - fetchTasks → `syncAll` called with the loaded list
- The platform service is thin and verified by running on a physical device.

## Open questions

None.
