import 'package:flutter/material.dart';

/// Couleurs Dotlyn selon le styleguide
class DotlynColors {
  DotlynColors._();

  // ============ COULEURS PRIMAIRES (Styleguide) ============

  /// Orange Terre Cuite - Couleur principale de la marque
  static const Color primary = Color(0xFFE36C2D);
  static const Color primaryLight = Color(0xFFFF8D54); // Hover, états actifs
  static const Color primaryDark = Color(0xFFB84D15); // Pressed, focus
  static const Color primaryLightest = Color(0xFFFFF4EE); // Backgrounds légers
  static const Color primaryDarkest = Color(0xFF8A3510); // Texte sur fond clair
  static const Color primaryBright =
      Color(0xFFFF9A6C); // Mode sombre uniquement - meilleure visibilité

  /// Gris Anthracite - Couleur secondaire
  static const Color secondary = Color(0xFF2C2C2C);
  static const Color secondaryLight = Color(0xFF4A4A4A); // Texte secondaire
  static const Color secondaryDark = Color(0xFF1A1A1A); // Backgrounds sombres

  /// Blanc Cassé - Couleur tertiaire
  static const Color tertiary = Color(0xFFF8F8F8);

  /// Bleu Acier - Couleur d'accent
  static const Color accent = Color(0xFF3A6EA5);
  static const Color accentLight = Color(0xFF5A8EC5);
  static const Color accentDark = Color(0xFF2A5E95);

  /// Beige Sable - Variante douce
  static const Color soft = Color(0xFFEADAC0);
  static const Color softLight = Color(0xFFF5EAD8);
  static const Color softDark = Color(0xFFD5C5A8);

  // ============ COULEURS SÉMANTIQUES ============

  /// Success (Vert)
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);
  static const Color successLightest = Color(0xFFE8F5E9);

  /// Warning (Ambre)
  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFD54F);
  static const Color warningDark = Color(0xFFFFA000);
  static const Color warningLightest = Color(0xFFFFF8E1);

  /// Error (Rouge)
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);
  static const Color errorLightest = Color(0xFFFFEBEE);

  /// Info (Bleu)
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);
  static const Color infoLightest = Color(0xFFE3F2FD);

  // ============ ÉCHELLE DE GRIS (Neutre) ============

  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ============ SURFACES ET BACKGROUNDS ============

  /// Light mode
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8F8F8); // tertiary
  static const Color cardLight = Color(0xFFFFFFFF);

  /// Dark mode
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C); // secondary

  // ============ TEXTE ============

  /// Light mode
  static const Color textPrimaryLight = Color(0xFF2C2C2C); // secondary
  static const Color textSecondaryLight = Color(0xFF757575); // grey600
  static const Color textDisabledLight = Color(0xFFBDBDBD); // grey400

  /// Dark mode
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFBDBDBD); // grey400
  static const Color textDisabledDark = Color(0xFF757575); // grey600

  // ============ DIVIDERS & BORDERS ============

  static const Color dividerLight = Color(0xFFE0E0E0); // grey300
  static const Color dividerDark = Color(0xFF424242); // grey800

  static const Color borderLight = Color(0xFFBDBDBD); // grey400
  static const Color borderDark = Color(0xFF616161); // grey700
}
