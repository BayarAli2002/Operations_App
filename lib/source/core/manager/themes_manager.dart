import 'package:crud_app/source/core/manager/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppThemeMode { light, dark }

class ThemesManager {
  static ThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: ColorsManager.lightScaffoldBackground,
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.transparent,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ColorsManager.lightAppBarBackground,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: ColorsManager.lightAppBarBackground,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            backgroundColor: ColorsManager.lightAppBarBackground,
            iconTheme: IconThemeData(color: ColorsManager.lightIconColor),
            titleTextStyle: TextStyle(
              color: ColorsManager.lightTextColor,
              fontSize: 20,
            ),
          ),
          iconTheme: const IconThemeData(color: ColorsManager.lightIconColor),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: ColorsManager.lightTextColor),
            bodyMedium: TextStyle(color: ColorsManager.lightTextColor),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: ColorsManager.lightPrimary,
          ),
        );

      case AppThemeMode.dark:
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: ColorsManager.darkScaffoldBackground,
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.transparent,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ColorsManager.darkAppBarBackground,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: ColorsManager.darkAppBarBackground,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            backgroundColor: ColorsManager.darkAppBarBackground,
            iconTheme: IconThemeData(color: ColorsManager.darkIconColor),
            titleTextStyle: TextStyle(
              color: ColorsManager.darkTextColor,
              fontSize: 20,
            ),
          ),
          iconTheme: const IconThemeData(color: ColorsManager.darkIconColor),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: ColorsManager.darkTextColor),
            bodyMedium: TextStyle(color: ColorsManager.darkTextColor),
          ),
          colorScheme: ColorScheme.fromSwatch(
            brightness: Brightness.dark,
          ).copyWith(primary: ColorsManager.darkPrimary),
        );
    }
  }
}
