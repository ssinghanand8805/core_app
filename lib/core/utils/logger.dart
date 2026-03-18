import 'package:flutter/foundation.dart';

class AppLogger {
  static void info(String msg) {
    if (kDebugMode) debugPrint('[INFO] $msg');
  }

  static void error(String msg) {
    if (kDebugMode) debugPrint('[ERROR] $msg');
  }

  static void warning(String msg) {
    if (kDebugMode) debugPrint('[WARN] $msg');
  }
}