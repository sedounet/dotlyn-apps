import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Helpers centralisés pour la localisation et le formatage
class I18nHelpers {
  I18nHelpers._();

  /// Formater une date selon la locale
  static String formatDate(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.yMMMd(locale).format(date);
  }

  /// Formater une date avec heure selon la locale
  static String formatDateTime(DateTime dateTime, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.yMMMd(locale).add_Hm().format(dateTime);
  }

  /// Formater un nombre avec séparateurs selon la locale
  static String formatNumber(num number, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return NumberFormat.decimalPattern(locale).format(number);
  }

  /// Formater un montant en devise
  static String formatCurrency(
    double amount,
    BuildContext context, {
    String symbol = '€',
  }) {
    final locale = Localizations.localeOf(context).languageCode;
    final formatter = NumberFormat.currency(locale: locale, symbol: symbol);
    return formatter.format(amount);
  }

  /// Formater un nombre entier avec séparateurs de milliers
  static String formatInteger(int number, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return NumberFormat.decimalPattern(locale).format(number);
  }

  /// Formater un pourcentage
  static String formatPercent(double percent, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return NumberFormat.percentPattern(locale).format(percent);
  }
}
