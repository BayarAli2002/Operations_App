import 'package:crud_app/source/core/manager/themes_manager.dart';
import 'package:flutter/material.dart';


class ThemeProvider extends ChangeNotifier {

  AppThemeMode _currentThemeMode = AppThemeMode.light;

  AppThemeMode get currentThemeMode => _currentThemeMode;

  ThemeData get currentTheme => AppTheme.getTheme(_currentThemeMode);


  void setThemeMode(AppThemeMode mode) {
    _currentThemeMode = mode;
    notifyListeners();
  }


}