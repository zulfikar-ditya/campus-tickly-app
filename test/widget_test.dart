// Smoke test: the app builds and renders the foundation preview.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_tickly/app.dart';

void main() {
  testWidgets('TicklyApp builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(const TicklyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
