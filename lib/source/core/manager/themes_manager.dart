import 'package:crud_app/source/core/manager/colors_manager.dart';
import 'package:flutter/material.dart';


enum AppThemeMode { light, dark }

class AppTheme {
  static ThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.lightBackground,
          colorScheme: const ColorScheme.light(
            primary: AppColors.lightPrimary,
            onPrimary: AppColors.lightOnPrimary,
            secondary: AppColors.lightSecondary,
            onSecondary: AppColors.lightOnSecondary,
            surface: AppColors.lightSurface,
            onSurface: AppColors.lightOnSurface,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.lightAppBarBackground,
            foregroundColor: AppColors.lightAppBarForeground,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 20,
              color: AppColors.lightTextPrimary,
              fontWeight: FontWeight.w600,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: AppColors.lightTextSecondary,
              fontWeight: FontWeight.w500,
            ),
            bodySmall: TextStyle(
              fontSize: 14,
              color: AppColors.lightTextSecondary,
            ),
          ),
          cardColor: AppColors.lightSurface,
          dividerColor: Colors.black12,
          iconTheme: const IconThemeData(color: Colors.black87),
        );

      case AppThemeMode.dark:
        return ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.darkBackground,
          colorScheme: ColorScheme.dark(
            primary: AppColors.darkPrimary,
            onPrimary: AppColors.darkOnPrimary,
            secondary: AppColors.darkSecondary,
            onSecondary: AppColors.darkOnSecondary,
            surface: AppColors.darkSurface,
            onSurface: AppColors.darkOnSurface,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.darkAppBarBackground,
            foregroundColor: AppColors.darkAppBarForeground,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 20,
              color: AppColors.darkTextPrimary,
              fontWeight: FontWeight.w600,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: AppColors.darkTextSecondary,
              fontWeight: FontWeight.w500,
            ),
            bodySmall: TextStyle(
              fontSize: 14,
              color: AppColors.darkTextSecondary,
            ),
          ),
          cardColor: AppColors.darkSurface,
          dividerColor: Colors.white24,
          iconTheme: const IconThemeData(color: Colors.white),
        );
    }
  }
}
