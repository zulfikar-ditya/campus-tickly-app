import 'package:flutter/material.dart';

/// Floating "+" button to add a task. Shape/colors come from
/// [FloatingActionButtonTheme].
class AppFab extends StatelessWidget {
  const AppFab({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.add, size: 28),
    );
  }
}
