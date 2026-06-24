import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// App-wide configuration. The API base URL can be overridden at build/run time
/// with `--dart-define=API_BASE_URL=...`; otherwise a sensible per-platform
/// default is used (Android emulators reach the host machine via 10.0.2.2).
abstract final class AppConfig {
  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }
}
