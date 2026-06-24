// Verifies auth screen navigation and form validation.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_harness.dart';

void main() {
  testWidgets('Sign up link navigates to Create account', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, backend());

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('Sign In shows validation errors when empty', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, backend());

    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Forgot password link opens the reset-link screen', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, backend());

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    expect(
      find.widgetWithText(FilledButton, 'Send reset link'),
      findsOneWidget,
    );
  });
}
