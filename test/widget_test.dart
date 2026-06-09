// Smoke test: the app builds and shows the Sign In screen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_tickly/app.dart';

void main() {
  testWidgets('TicklyApp opens on the Sign In screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TicklyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
