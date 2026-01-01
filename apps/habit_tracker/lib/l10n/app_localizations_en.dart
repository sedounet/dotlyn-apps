// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Habit Tracker';

  @override
  String get habit => 'Habit';

  @override
  String get habits => 'Habits';

  @override
  String get addHabit => 'Add Habit';

  @override
  String get editHabit => 'Edit Habit';

  @override
  String get deleteHabit => 'Delete Habit';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get settings => 'Settings';
}
