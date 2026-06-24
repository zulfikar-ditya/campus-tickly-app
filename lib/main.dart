import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/task_controller.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'data/auth_repository.dart';
import 'data/task_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Compose the layers once and inject them through Provider.
  final TokenStorage tokenStorage = TokenStorage();
  final ApiClient apiClient = ApiClient(tokenStorage);
  final AuthRepository authRepository = AuthRepository(apiClient);
  final TaskRepository taskRepository = TaskRepository(apiClient);

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
            onUnauthorized: () => context.read<AuthController>().logout(),
          ),
        ),
      ],
      child: const TicklyApp(),
    ),
  );
}
