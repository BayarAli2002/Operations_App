import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension FlushbarExtension on BuildContext {
  void showFlushbar(String message, {bool isError = false}) {
    Flushbar(
      message: message,
      backgroundColor: isError ? Colors.redAccent : Colors.teal,
      margin: EdgeInsets.all(8.w),
      borderRadius: BorderRadius.circular(12.r),
      duration: const Duration(seconds: 1),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: const Duration(milliseconds: 500),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
    ).show(this);
  }
}
