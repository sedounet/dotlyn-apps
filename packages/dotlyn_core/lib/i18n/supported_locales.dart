import 'package:flutter/material.dart';

/// Configuration centralisée des locales supportées
class DotlynLocales {
  DotlynLocales._();

  /// Liste des locales supportées
  static const List<Locale> supported = [
    Locale('en', ''), // Anglais
    Locale('fr', ''), // Français
  ];

  /// Locale par défaut (fallback)
  static const Locale fallback = Locale('en', '');
}
