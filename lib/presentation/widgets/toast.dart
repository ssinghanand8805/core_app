import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static void show(
    String message, {
    ToastType type = ToastType.info,
  }) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: _getColor(type),
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static Color _getColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.red;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.info:
      default:
        return Colors.black87;
    }
  }
}

enum ToastType { success, error, warning, info }
