import 'package:crud_app/source/core/translations/language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension PriceExtension on num {
  String withCurrency(BuildContext context) {
    // This line gets the current locale of the app
    final locale = Localizations.localeOf(context).languageCode;

    // Always use English number formatting (e.g., 1,000)
    final formatter = NumberFormat.decimalPattern('en');
    final formatted = formatter.format(this);

    // Currency label with a space between number and symbol
    if (locale == Language.englishLocale) {
      return '$formatted IQD';
    } else if (locale == Language.kurdishLocale) {
      return '$formatted  د.ع';
    } else {
      return '$formatted  د.ع';
    }
  }

}
