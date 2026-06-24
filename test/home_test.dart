// Verifies the Home screen renders tasks from the backend and the create-task
// flow opens, and that signing in lands on Home with the user's tasks.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_tickly/features/tasks/home_screen.dart';

import 'helpers/test_harness.dart';

void main() {
  testWidgets('Home shows the greeting and today\'s tasks', (
    WidgetTester tester,
  ) async {
    await pumpScreen(
      tester,
      backend(
        tasks: <Map<String, dynamic>>[
          fakeTask('1', 'Finish API documentation', category: 'backend'),
          fakeTask('2', 'Team standup meeting', category: 'meeting'),
        ],
      ),
      const HomeScreen(),
    );

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Finish API documentation'), findsOneWidget);
    expect(find.text('Team standup meeting'), findsOneWidget);
  });

  testWidgets('FAB opens the Create Task screen', (WidgetTester tester) async {
    await pumpScreen(tester, backend(), const HomeScreen());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Create Task'), findsWidgets);
    expect(find.widgetWithText(FilledButton, 'Create Task'), findsOneWidget);
  });

  testWidgets('Signing in navigates from Sign In to Home', (
    WidgetTester tester,
  ) async {
    await pumpApp(
      tester,
      backend(
        tasks: <Map<String, dynamic>>[
          fakeTask('1', 'Finish API documentation', category: 'backend'),
        ],
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'user@email.com');
    await tester.enterText(find.byType(TextFormField).last, 'secret123');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Finish API documentation'), findsOneWidget);
  });
}
