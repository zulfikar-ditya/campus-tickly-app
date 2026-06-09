import 'package:flutter/material.dart';

import 'foundation_preview.dart';
import 'theme/app_theme.dart';

/// Root of the Tickly app. Wires light/dark themes and follows the system
/// brightness. `home` is the temporary foundation preview for now; it will be
/// swapped for the Sign In screen (and named routes) as screens are built.
class TicklyApp extends StatelessWidget {
  const TicklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tickly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const FoundationPreview(),
    );
  }
}
