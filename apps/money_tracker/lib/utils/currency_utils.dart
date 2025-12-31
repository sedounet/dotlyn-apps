import 'package:intl/intl.dart';

/// Utilitaire pour le formatage des montants en devise
class CurrencyUtils {
  CurrencyUtils._();

  /// Formatter par défaut (euros, locale français)
  static final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

  /// Formate un montant en devise
  static String format(double amount) => formatter.format(amount);

  /// Formate un montant avec signe explicite (+/-)
  static String formatWithSign(double amount) {
    final sign = amount >= 0 ? '+' : '';
    return '$sign${formatter.format(amount)}';
  }

  /// Formate un montant compact (sans décimales si entier)
  static String formatCompact(double amount) {
    if (amount % 1 == 0) {
      return NumberFormat.currency(
        locale: 'fr_FR',
        symbol: '€',
        decimalDigits: 0,
      ).format(amount);
    }
    return formatter.format(amount);
  }
}
