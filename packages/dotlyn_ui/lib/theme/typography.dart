import 'package:flutter/material.dart';

/// Typographie Dotlyn selon le styleguide
/// Titres: Satoshi
/// UI/Texte: Plus Jakarta Sans
class DotlynTypography {
  DotlynTypography._();

  static const String _satoshi = 'Satoshi';
  static const String _jakarta = 'PlusJakartaSans';

  // Display
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _satoshi,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _satoshi,
    fontSize: 45,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _satoshi,
    fontSize: 36,
    fontWeight: FontWeight.w700,
  );

  // Headlines
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _satoshi,
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _satoshi,
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _satoshi,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  // Titles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _jakarta,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _jakarta,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _jakarta,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _jakarta,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _jakarta,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _jakarta,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _jakarta,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _jakarta,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _jakarta,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}
