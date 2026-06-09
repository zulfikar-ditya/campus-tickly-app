/// Named routes for the app. Wired into `MaterialApp` as screens are built;
/// kept here so navigation targets are referenced by constant, not string.
abstract final class AppRoutes {
  static const String signIn = '/sign-in';
  static const String createAccount = '/create-account';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String createTask = '/create-task';
  static const String editTask = '/edit-task';
}
