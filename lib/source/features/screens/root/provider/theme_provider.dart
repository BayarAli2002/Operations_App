import 'dart:developer';

import 'package:crud_app/source/core/manager/themes_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _themePrefKey = 'theme_mode';

  AppThemeMode _currentThemeMode = AppThemeMode.light;
  AppThemeMode get currentThemeMode => _currentThemeMode;
  ThemeData get currentTheme => AppTheme.getTheme(_currentThemeMode);

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themePrefKey);

      if (savedTheme != null) {
        _currentThemeMode = AppThemeMode.values.firstWhere(
          (e) => e.toString() == savedTheme,
          orElse: () => AppThemeMode.light,
        );
        notifyListeners();
      }
    } catch (e) {
      log('Error loading theme from prefs: $e');
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _currentThemeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePrefKey, mode.toString());
    } catch (e) {
      // optionally log or handle error gracefully
      log('Error saving theme to prefs: $e');
    }
  }
}
