import 'package:crud_app/source/core/theme/app_theme_mode.dart';
import 'package:crud_app/source/core/theme/theme_provider.dart';
import 'package:crud_app/source/core/transations/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/transations/language.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor:
          theme.colorScheme.surface, // Use surface color from theme
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ), // Primary color
            child: Center(
              child: Text(
                LocaleKeys.appName.tr(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 35.h),
                _buildLanguageButton(
                  context,
                  label: LocaleKeys.english.tr(),
                  locale: const Locale(Language.englishLocale),
                  theme: theme,
                ),
                SizedBox(height: 12.h),
                _buildLanguageButton(
                  context,
                  label: LocaleKeys.arabic.tr(),
                  locale: const Locale(Language.arabicLocale),
                  theme: theme,
                ),
                SizedBox(height: 12.h),
                _buildLanguageButton(
                  context,
                  label: LocaleKeys.kurdish.tr(),
                  locale: const Locale(Language.kurdishLocale),
                  theme: theme,
                ),
                SizedBox(height: 12.h),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) => ListTile(
                    leading: Icon(
                      Icons.color_lens,
                      color: theme.colorScheme.onSurface,
                    ),
                    title: Text("Theme", style: theme.textTheme.bodyMedium),
                    trailing: PopupMenuButton<AppThemeMode>(
                      initialValue: themeProvider.currentThemeMode,
                      onSelected: (newMode) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          themeProvider.setThemeMode(newMode);
                          Navigator.pop(context);
                        });
                      },

                      itemBuilder: (context) => AppThemeMode.values.map((mode) {
                        return PopupMenuItem<AppThemeMode>(
                          value: mode,
                          child: Text(
                            mode.toString().split('.').last,
                            style: theme.textTheme.bodyMedium,
                          ),
                        );
                      }).toList(),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context, {
    required String label,
    required Locale locale,
    required ThemeData theme,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          foregroundColor: theme.colorScheme.onPrimary,
          textStyle: theme.textTheme.bodyMedium,
        ),
        onPressed: () {
          context.setLocale(locale);
        },
        child: Text(label),
      ),
    );
  }
}
