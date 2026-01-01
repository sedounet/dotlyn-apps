// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Habit Tracker';

  @override
  String get habit => 'Habitude';

  @override
  String get habits => 'Habitudes';

  @override
  String get addHabit => 'Ajouter une Habitude';

  @override
  String get editHabit => 'Modifier l\'Habitude';

  @override
  String get deleteHabit => 'Supprimer l\'Habitude';

  @override
  String get name => 'Nom';

  @override
  String get description => 'Description';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get settings => 'Paramètres';
}
