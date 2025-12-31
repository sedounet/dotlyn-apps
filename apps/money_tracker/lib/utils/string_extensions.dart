/// Extensions pour les chaînes de caractères
extension StringExtensions on String {
  /// Capitalise la première lettre
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Capitalise chaque mot (Title Case)
  String toTitleCase() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}
