import 'package:flutter/material.dart';
import 'app_theme_mode.dart';

class AppTheme {
  static ThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          colorScheme: const ColorScheme.light(
            primary: Colors.teal,
            onPrimary: Colors.white,
            secondary: Colors.tealAccent,
            onSecondary: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
            
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            bodySmall: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        );

      case AppThemeMode.dark:
        return ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: Colors.teal,
            onPrimary: Colors.black,
            secondary: Colors.tealAccent,
            onSecondary: Colors.black,
            surface: Colors.grey[900]!,
            onSurface: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
            bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
            bodySmall: TextStyle(fontSize: 14, color: Colors.white60),
          ),
        );

     
    }
  }
}
