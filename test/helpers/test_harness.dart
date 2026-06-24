// Shared test harness: builds the Provider tree over a fake (in-memory) backend
// so widget tests exercise the real controllers/repositories without a network.

import 'dart:convert';

import 'package:campus_tickly/app.dart';
import 'package:campus_tickly/controllers/auth_controller.dart';
import 'package:campus_tickly/controllers/task_controller.dart';
import 'package:campus_tickly/core/network/api_client.dart';
import 'package:campus_tickly/core/storage/token_storage.dart';
import 'package:campus_tickly/data/auth_repository.dart';
import 'package:campus_tickly/data/task_repository.dart';
import 'package:campus_tickly/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Build a task JSON map starting "now" so it lands under the home "Today" view.
Map<String, dynamic> fakeTask(String id, String title, {String category = 'work'}) {
  final DateTime start = DateTime.now();
  return <String, dynamic>{
    'id': id,
    'title': title,
    'category': category,
    'description': '',
    'start_at': start.toUtc().toIso8601String(),
    'end_at': start.add(const Duration(hours: 1)).toUtc().toIso8601String(),
    'email_reminder': false,
    'is_done': false,
  };
}

http.Response _json(Map<String, dynamic> body, int status) =>
    http.Response(jsonEncode(body), status, headers: <String, String>{'content-type': 'application/json'});

/// A MockClient that emulates the subset of the backend the widget tests touch.
MockClient backend({List<Map<String, dynamic>> tasks = const <Map<String, dynamic>>[]}) {
  return MockClient((http.Request request) async {
    final String path = request.url.path;
    final String method = request.method;

    if (path == '/auth/login' && method == 'POST') {
      return _json(<String, dynamic>{
        'status': 200,
        'success': true,
        'message': 'ok',
        'data': <String, dynamic>{
          'user': <String, dynamic>{
            'id': 'u1',
            'name': 'Tester',
            'email': 'user@email.com',
            'roles': <String>[],
          },
          'accessToken': 'test-token',
        },
      }, 200);
    }

    if (path == '/tasks' && method == 'GET') {
      return _json(<String, dynamic>{
        'status': 200,
        'success': true,
        'message': 'ok',
        'data': <String, dynamic>{
          'data': tasks,
          'meta': <String, dynamic>{'page': 1, 'limit': 200, 'totalCount': tasks.length},
        },
      }, 200);
    }

    return _json(<String, dynamic>{
      'status': 404,
      'success': false,
      'message': 'not found',
      'data': null,
    }, 404);
  });
}

/// Pump the full app (with the auth gate) wired to [client].
Future<void> pumpApp(WidgetTester tester, http.Client client) async {
  await _pump(tester, client, const TicklyApp());
}

/// Pump a single screen wired to [client] (skips the auth gate).
Future<void> pumpScreen(WidgetTester tester, http.Client client, Widget screen) async {
  await _pump(tester, client, MaterialApp(theme: AppTheme.light, home: screen));
}

Future<void> _pump(WidgetTester tester, http.Client client, Widget child) async {
  FlutterSecureStorage.setMockInitialValues(<String, String>{});
  final TokenStorage tokenStorage = TokenStorage();
  final ApiClient api = ApiClient(tokenStorage, httpClient: client);

  await tester.pumpWidget(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AuthController>(
          create: (_) {
            final AuthController c = AuthController(AuthRepository(api), tokenStorage);
            c.bootstrap();
            return c;
          },
        ),
        ChangeNotifierProvider<TaskController>(
          create: (_) => TaskController(TaskRepository(api)),
        ),
      ],
      child: child,
    ),
  );
  await tester.pumpAndSettle();
}
