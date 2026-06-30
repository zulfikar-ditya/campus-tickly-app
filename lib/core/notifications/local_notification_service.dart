import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../models/task.dart';
import '../../utils/formatters.dart';
import 'reminder_scheduler.dart';

/// Real [ReminderScheduler] backed by `flutter_local_notifications`.
///
/// Call [init] once at startup (before scheduling anything). Scheduling calls
/// are tolerant: a no-op until [init] has completed, so a failure to set up
/// notifications never blocks the rest of the app.
class LocalNotificationService implements ReminderScheduler {
  LocalNotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _channelId = 'task_reminders';
  static const String _channelName = 'Task reminders';
  static const String _channelDescription =
      'Reminders that fire before a task starts.';

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;

  /// Initialize the plugin, timezone database, and request OS permissions.
  /// Safe to call once; swallows failures so startup can't be blocked.
  Future<void> init() async {
    try {
      tzdata.initializeTimeZones();
      final TimezoneInfo localZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localZone.identifier));

      const AndroidInitializationSettings android =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings darwin = DarwinInitializationSettings(
        // Permissions are requested explicitly below so we can also cover
        // Android 13+ in one place.
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      await _plugin.initialize(
        settings: const InitializationSettings(android: android, iOS: darwin),
      );

      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      _ready = true;
    } catch (e, st) {
      debugPrint('LocalNotificationService.init failed: $e\n$st');
    }
  }

  @override
  Future<void> schedule(Task task) async {
    if (!_ready) return;
    final int id = reminderNotificationId(task.id);
    // Always clear the old slot first so an edit doesn't leave a stale one.
    await _plugin.cancel(id: id);
    if (!isReminderEligible(task)) return;

    final tz.TZDateTime fireAt = tz.TZDateTime.from(
      task.start.subtract(kReminderLeadTime),
      tz.local,
    );

    try {
      await _plugin.zonedSchedule(
        id: id,
        title: task.title,
        body: 'Starts at ${formatClock(task.start)} — in 10 minutes.',
        scheduledDate: fireAt,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e, st) {
      debugPrint('Failed to schedule reminder for ${task.id}: $e\n$st');
    }
  }

  @override
  Future<void> cancel(String taskId) async {
    if (!_ready) return;
    await _plugin.cancel(id: reminderNotificationId(taskId));
  }

  @override
  Future<void> syncAll(List<Task> tasks) async {
    if (!_ready) return;
    await _plugin.cancelAll();
    for (final Task task in tasks) {
      await schedule(task);
    }
  }

  @override
  Future<void> cancelAll() async {
    if (!_ready) return;
    await _plugin.cancelAll();
  }
}
