import 'package:flutter/material.dart';
import 'app_theme_mode.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _currentThemeMode = AppThemeMode.light;

  AppThemeMode get currentThemeMode => _currentThemeMode;

  ThemeData get currentTheme => AppTheme.getTheme(_currentThemeMode);

  void setThemeMode(AppThemeMode mode) {
    _currentThemeMode = mode;
    notifyListeners();
  }
}