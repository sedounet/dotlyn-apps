import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Service pour gérer la persistence de la locale
class LocaleService {
  static const String _key = 'app_locale';

  /// Récupérer la locale sauvegardée (ou null si aucune)
  Future<Locale?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_key);
    if (languageCode != null) {
      return Locale(languageCode);
    }
    return null;
  }

  /// Sauvegarder la locale choisie
  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }
}
