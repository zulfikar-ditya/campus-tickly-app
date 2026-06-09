// Verifies the Home screen renders tasks and the create-task flow opens.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_tickly/app.dart';
import 'package:campus_tickly/features/tasks/home_screen.dart';
import 'package:campus_tickly/theme/app_theme.dart';

Widget _wrap() => MaterialApp(theme: AppTheme.light, home: const HomeScreen());

void main() {
  testWidgets('Home shows the greeting and today\'s tasks', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap());

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Finish API documentation'), findsOneWidget);
    expect(find.text('Team standup meeting'), findsOneWidget);
  });

  testWidgets('FAB opens the Create Task screen', (WidgetTester tester) async {
    await tester.pumpWidget(_wrap());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Create Task'), findsWidgets);
    expect(find.widgetWithText(FilledButton, 'Create Task'), findsOneWidget);
  });

  testWidgets('Signing in navigates from Sign In to Home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TicklyApp());

    await tester.enterText(find.byType(TextFormField).first, 'user@email.com');
    await tester.enterText(find.byType(TextFormField).last, 'secret123');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Finish API documentation'), findsOneWidget);
  });
}
