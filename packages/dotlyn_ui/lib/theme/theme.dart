import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class DotlynTheme {
  DotlynTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ColorScheme complet avec toutes les nuances
      colorScheme: ColorScheme.light(
        primary: DotlynColors.primary,
        onPrimary: Colors.white,
        primaryContainer: DotlynColors.primaryLightest,
        onPrimaryContainer: DotlynColors.primaryDarkest,
        secondary: DotlynColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: DotlynColors.grey100,
        onSecondaryContainer: DotlynColors.secondaryDark,
        tertiary: DotlynColors.accent,
        onTertiary: Colors.white,
        tertiaryContainer: DotlynColors.infoLightest,
        onTertiaryContainer: DotlynColors.accentDark,
        error: DotlynColors.error,
        onError: Colors.white,
        errorContainer: DotlynColors.errorLightest,
        onErrorContainer: DotlynColors.errorDark,
        surface: DotlynColors.surfaceLight,
        onSurface: DotlynColors.textPrimaryLight,
        surfaceContainerHighest: DotlynColors.cardLight,
        outline: DotlynColors.borderLight,
        outlineVariant: DotlynColors.dividerLight,
        shadow: DotlynColors.grey300,
        scrim: DotlynColors.secondary.withOpacity(0.5),
        inverseSurface: DotlynColors.secondary,
        onInverseSurface: Colors.white,
        inversePrimary: DotlynColors.primaryLight,
      ),

      // Typographie
      textTheme: TextTheme(
        displayLarge: DotlynTypography.displayLarge.copyWith(color: DotlynColors.textPrimaryLight),
        displayMedium:
            DotlynTypography.displayMedium.copyWith(color: DotlynColors.textPrimaryLight),
        displaySmall: DotlynTypography.displaySmall.copyWith(color: DotlynColors.textPrimaryLight),
        headlineLarge:
            DotlynTypography.headlineLarge.copyWith(color: DotlynColors.textPrimaryLight),
        headlineMedium:
            DotlynTypography.headlineMedium.copyWith(color: DotlynColors.textPrimaryLight),
        headlineSmall:
            DotlynTypography.headlineSmall.copyWith(color: DotlynColors.textPrimaryLight),
        titleLarge: DotlynTypography.titleLarge.copyWith(color: DotlynColors.textPrimaryLight),
        titleMedium: DotlynTypography.titleMedium.copyWith(color: DotlynColors.textPrimaryLight),
        titleSmall: DotlynTypography.titleSmall.copyWith(color: DotlynColors.textPrimaryLight),
        bodyLarge: DotlynTypography.bodyLarge.copyWith(color: DotlynColors.textPrimaryLight),
        bodyMedium: DotlynTypography.bodyMedium.copyWith(color: DotlynColors.textSecondaryLight),
        bodySmall: DotlynTypography.bodySmall.copyWith(color: DotlynColors.textSecondaryLight),
        labelLarge: DotlynTypography.labelLarge.copyWith(color: DotlynColors.textPrimaryLight),
        labelMedium: DotlynTypography.labelMedium.copyWith(color: DotlynColors.textSecondaryLight),
        labelSmall: DotlynTypography.labelSmall.copyWith(color: DotlynColors.textSecondaryLight),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: DotlynColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DotlynColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: DotlynColors.grey300,
          disabledForegroundColor: DotlynColors.textDisabledLight,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed))
              return DotlynColors.primaryDark.withOpacity(0.2);
            if (states.contains(WidgetState.hovered))
              return DotlynColors.primaryLight.withOpacity(0.1);
            return null;
          }),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DotlynColors.primary,
          side: const BorderSide(color: DotlynColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return DotlynColors.primary.withOpacity(0.1);
            if (states.contains(WidgetState.hovered)) return DotlynColors.primary.withOpacity(0.05);
            return null;
          }),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DotlynColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return DotlynColors.primary.withOpacity(0.1);
            if (states.contains(WidgetState.hovered)) return DotlynColors.primary.withOpacity(0.05);
            return null;
          }),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: DotlynColors.cardLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DotlynColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DotlynColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DotlynColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DotlynColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DotlynColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DotlynColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: TextStyle(color: DotlynColors.textSecondaryLight),
        hintStyle: TextStyle(color: DotlynColors.textDisabledLight),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: DotlynColors.dividerLight,
        thickness: 1,
        space: 1,
      ),

      // Scaffold
      scaffoldBackgroundColor: DotlynColors.backgroundLight,

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: DotlynColors.cardLight,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // BottomSheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: DotlynColors.cardLight,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DotlynColors.secondary,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // ColorScheme complet pour dark mode
      colorScheme: ColorScheme.dark(
        primary: DotlynColors.primary,
        onPrimary: Colors.white,
        primaryContainer: DotlynColors.primaryDark,
        onPrimaryContainer: DotlynColors.primaryLight,
        secondary: DotlynColors.grey300,
        onSecondary: DotlynColors.secondary,
        secondaryContainer: DotlynColors.grey800,
        onSecondaryContainer: DotlynColors.grey200,
        tertiary: DotlynColors.accentLight,
        onTertiary: Colors.white,
        tertiaryContainer: DotlynColors.accentDark,
        onTertiaryContainer: DotlynColors.accentLight,
        error: DotlynColors.errorLight,
        onError: DotlynColors.errorDark,
        errorContainer: DotlynColors.errorDark,
        onErrorContainer: DotlynColors.errorLight,
        surface: DotlynColors.surfaceDark,
        onSurface: DotlynColors.textPrimaryDark,
        surfaceContainerHighest: DotlynColors.cardDark,
        outline: DotlynColors.borderDark,
        outlineVariant: DotlynColors.dividerDark,
        shadow: Colors.black,
        scrim: Colors.black.withOpacity(0.5),
        inverseSurface: DotlynColors.grey100,
        onInverseSurface: DotlynColors.secondary,
        inversePrimary: DotlynColors.primaryDark,
      ),

      // Typographie
      textTheme: TextTheme(
        displayLarge: DotlynTypography.displayLarge.copyWith(color: DotlynColors.textPrimaryDark),
        displayMedium: DotlynTypography.displayMedium.copyWith(color: DotlynColors.textPrimaryDark),
        displaySmall: DotlynTypography.displaySmall.copyWith(color: DotlynColors.textPrimaryDark),
        headlineLarge: DotlynTypography.headlineLarge.copyWith(color: DotlynColors.textPrimaryDark),
        headlineMedium:
            DotlynTypography.headlineMedium.copyWith(color: DotlynColors.textPrimaryDark),
        headlineSmall: DotlynTypography.headlineSmall.copyWith(color: DotlynColors.textPrimaryDark),
        titleLarge: DotlynTypography.titleLarge.copyWith(color: DotlynColors.textPrimaryDark),
        titleMedium: DotlynTypography.titleMedium.copyWith(color: DotlynColors.textPrimaryDark),
        titleSmall: DotlynTypography.titleSmall.copyWith(color: DotlynColors.textPrimaryDark),
        bodyLarge: DotlynTypography.bodyLarge.copyWith(color: DotlynColors.textPrimaryDark),
        bodyMedium: DotlynTypography.bodyMedium.copyWith(color: DotlynColors.textSecondaryDark),
        bodySmall: DotlynTypography.bodySmall.copyWith(color: DotlynColors.textSecondaryDark),
        labelLarge: DotlynTypography.labelLarge.copyWith(color: DotlynColors.textPrimaryDark),
        labelMedium: DotlynTypography.labelMedium.copyWith(color: DotlynColors.textSecondaryDark),
        labelSmall: DotlynTypography.labelSmall.copyWith(color: DotlynColors.textSecondaryDark),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: DotlynColors.cardDark,
        foregroundColor: DotlynColors.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: DotlynColors.textPrimaryDark),
        actionsIconTheme: IconThemeData(color: DotlynColors.textPrimaryDark),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DotlynColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: DotlynColors.grey700,
          disabledForegroundColor: DotlynColors.textDisabledDark,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed))
              return DotlynColors.primaryDark.withOpacity(0.3);
            if (states.contains(WidgetState.hovered))
              return DotlynColors.primaryLight.withOpacity(0.2);
            return null;
          }),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DotlynColors.primary,
          side: const BorderSide(color: DotlynColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return DotlynColors.primary.withOpacity(0.2);
            if (states.contains(WidgetState.hovered)) return DotlynColors.primary.withOpacity(0.1);
            return null;
          }),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DotlynColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return DotlynColors.primary.withOpacity(0.2);
            if (states.contains(WidgetState.hovered)) return DotlynColors.primary.withOpacity(0.1);
            return null;
          }),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: DotlynColors.cardDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DotlynColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DotlynColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DotlynColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DotlynColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DotlynColors.errorLight),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DotlynColors.errorLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: TextStyle(color: DotlynColors.textSecondaryDark),
        hintStyle: TextStyle(color: DotlynColors.textDisabledDark),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: DotlynColors.dividerDark,
        thickness: 1,
        space: 1,
      ),

      // Scaffold
      scaffoldBackgroundColor: DotlynColors.backgroundDark,

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: DotlynColors.cardDark,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // BottomSheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: DotlynColors.cardDark,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DotlynColors.grey700,
        contentTextStyle: TextStyle(color: DotlynColors.textPrimaryDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
