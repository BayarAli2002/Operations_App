import 'package:crud_app/source/core/manager/colors_manager.dart';
import 'package:flutter/material.dart';


enum AppThemeMode { light, dark }

class ThemesManager {
  static ThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          scaffoldBackgroundColor: ColorsManager.lightBackground,
          colorScheme: const ColorScheme.light(
            primary: ColorsManager.lightPrimary,
            onPrimary: ColorsManager.lightOnPrimary,
            secondary: ColorsManager.lightSecondary,
            onSecondary: ColorsManager.lightOnSecondary,
            surface: ColorsManager.lightSurface,
            onSurface: ColorsManager.lightOnSurface,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorsManager.lightAppBarBackground,
            foregroundColor: ColorsManager.lightAppBarForeground,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 20,
              color: ColorsManager.lightTextPrimary,
              fontWeight: FontWeight.w600,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: ColorsManager.lightTextSecondary,
              fontWeight: FontWeight.w500,
            ),
            bodySmall: TextStyle(
              fontSize: 14,
              color: ColorsManager.lightTextSecondary,
            ),
          ),
          cardColor: ColorsManager.lightSurface,
          dividerColor: Colors.black12,
          iconTheme: const IconThemeData(color: Colors.black87),
        );

      case AppThemeMode.dark:
        return ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          scaffoldBackgroundColor: ColorsManager.darkBackground,
          colorScheme: ColorScheme.dark(
            primary: ColorsManager.darkPrimary,
            onPrimary: ColorsManager.darkOnPrimary,
            secondary: ColorsManager.darkSecondary,
            onSecondary: ColorsManager.darkOnSecondary,
            surface: ColorsManager.darkSurface,
            onSurface: ColorsManager.darkOnSurface,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorsManager.darkAppBarBackground,
            foregroundColor: ColorsManager.darkAppBarForeground,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 20,
              color: ColorsManager.darkTextPrimary,
              fontWeight: FontWeight.w600,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: ColorsManager.darkTextSecondary,
              fontWeight: FontWeight.w500,
            ),
            bodySmall: TextStyle(
              fontSize: 14,
              color: ColorsManager.darkTextSecondary,
            ),
          ),
          cardColor: ColorsManager.darkSurface,
          dividerColor: Colors.white24,
          iconTheme: const IconThemeData(color: Colors.white),
        );
    }
  }
}
