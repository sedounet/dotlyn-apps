import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class DotlynTheme {
  DotlynTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: DotlynColors.primary,
        secondary: DotlynColors.secondary,
        tertiary: DotlynColors.tertiary,
        error: DotlynColors.error,
        surface: DotlynColors.tertiary,
      ),
      textTheme: TextTheme(
        displayLarge: DotlynTypography.displayLarge,
        displayMedium: DotlynTypography.displayMedium,
        displaySmall: DotlynTypography.displaySmall,
        headlineLarge: DotlynTypography.headlineLarge,
        headlineMedium: DotlynTypography.headlineMedium,
        headlineSmall: DotlynTypography.headlineSmall,
        titleLarge: DotlynTypography.titleLarge,
        titleMedium: DotlynTypography.titleMedium,
        titleSmall: DotlynTypography.titleSmall,
        bodyLarge: DotlynTypography.bodyLarge,
        bodyMedium: DotlynTypography.bodyMedium,
        bodySmall: DotlynTypography.bodySmall,
        labelLarge: DotlynTypography.labelLarge,
        labelMedium: DotlynTypography.labelMedium,
        labelSmall: DotlynTypography.labelSmall,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DotlynColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DotlynColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      scaffoldBackgroundColor: DotlynColors.tertiary,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: DotlynColors.primary,
        secondary: DotlynColors.grey200,
        tertiary: DotlynColors.grey800,
        error: DotlynColors.error,
        surface: DotlynColors.grey900,
      ),
      scaffoldBackgroundColor: DotlynColors.grey900,
    );
  }
}
