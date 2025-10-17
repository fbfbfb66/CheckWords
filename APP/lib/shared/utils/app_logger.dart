import 'package:flutter/foundation.dart';

/// Lightweight logger to keep console noise under control.
class AppLogger {
  AppLogger._();

  /// Toggle for verbose (high-volume) logs.
  static const bool enableVerboseLogs = false;

  static void verbose(String message) {
    if (enableVerboseLogs && kDebugMode) {
      debugPrint(message);
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint(message);
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }
}
