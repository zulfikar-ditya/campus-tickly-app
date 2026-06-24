// Smoke test: with no stored session, the app opens on the Sign In screen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_harness.dart';

void main() {
  testWidgets('TicklyApp opens on the Sign In screen when signed out', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, backend());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
