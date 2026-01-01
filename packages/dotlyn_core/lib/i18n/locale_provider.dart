import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'locale_service.dart';
import 'supported_locales.dart';

/// Provider pour le service de locale
final localeServiceProvider = Provider<LocaleService>((ref) => LocaleService());

/// Provider pour la locale actuelle (StateNotifier)
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.watch(localeServiceProvider));
});

/// StateNotifier pour gérer les changements de locale
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._service) : super(DotlynLocales.fallback) {
    _loadLocale();
  }

  final LocaleService _service;

  /// Charger la locale sauvegardée au démarrage
  Future<void> _loadLocale() async {
    final savedLocale = await _service.getSavedLocale();
    if (savedLocale != null) {
      state = savedLocale;
    }
  }

  /// Changer la locale et la sauvegarder
  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _service.setLocale(locale);
  }
}
