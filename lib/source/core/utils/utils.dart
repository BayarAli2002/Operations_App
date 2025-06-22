import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error, warning }

class Utils {
  static void showToast(String message, ToastType type) {
    Color backgroundColor;

    switch (type) {
      case ToastType.error:
        backgroundColor = const Color(0xFFD32F2F); // Red for error
        break;
      case ToastType.success:
        backgroundColor = const Color(0xFF388E3C); // Green for success
        break;
      case ToastType.warning:
        backgroundColor = const Color(0xFFFBC02D); // Amber/Yellow for warning
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor,
      textColor: const Color(0xFFFFFFFF),
      fontSize: 14.0,
    );
  }
}
