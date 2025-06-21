import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


extension PriceExtension on num {
  String withCurrency(BuildContext context) {
    // This line gets the current locale of the app
    final locale = Localizations.localeOf(context).languageCode;

    // Always use English number formatting (e.g., 1,000)
    final formatter = NumberFormat.decimalPattern('en');
    final formatted = formatter.format(this);

    // Currency label with a space between number and symbol
    if (locale == 'en') {
      return '$formatted IQD';
    } else if (locale == 'fa') {
      return '$formatted  د.ع';
    } else {
      return '$formatted  د.ع';
    }
  }

}

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

