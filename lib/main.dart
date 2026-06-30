import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/task_controller.dart';
import 'core/network/api_client.dart';
import 'core/notifications/local_notification_service.dart';
import 'core/storage/token_storage.dart';
import 'data/auth_repository.dart';
import 'data/task_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Compose the layers once and inject them through Provider.
  final TokenStorage tokenStorage = TokenStorage();
  final ApiClient apiClient = ApiClient(tokenStorage);
  final AuthRepository authRepository = AuthRepository(apiClient);
  final TaskRepository taskRepository = TaskRepository(apiClient);

  // On-device reminder notifications. Init failures are swallowed inside the
  // service so they can't block startup.
  final LocalNotificationService notifications = LocalNotificationService();
  await notifications.init();

  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AuthController>(
          create: (_) {
            final AuthController controller = AuthController(
              authRepository,
              tokenStorage,
            );
            // Restore any persisted session before the first frame settles.
            controller.bootstrap();
            return controller;
          },
        ),
        ChangeNotifierProvider<TaskController>(
          create: (BuildContext context) => TaskController(
            taskRepository,
            reminders: notifications,
            onUnauthorized: () => context.read<AuthController>().logout(),
          ),
        ),
      ],
      child: const TicklyApp(),
    ),
  );
}
