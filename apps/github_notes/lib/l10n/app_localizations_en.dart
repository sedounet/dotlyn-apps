// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GitHub Notes';

  @override
  String get note => 'Note';

  @override
  String get notes => 'Notes';

  @override
  String get addNote => 'Add Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get deleteNote => 'Delete Note';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get sync => 'Sync';

  @override
  String get settings => 'Settings';

  @override
  String get title => 'Title';

  @override
  String get content => 'Content';

  @override
  String get conflictDialogTitle => 'Conflict detected';

  @override
  String get conflictDialogDescription =>
      'A conflict was detected between your local file and GitHub.';

  @override
  String get conflictFileExistsHeader =>
      'This file already exists on GitHub. What would you like to do?';

  @override
  String get conflictBothModifiedHeader =>
      'Changes have been made both locally and on GitHub. How would you like to resolve this conflict?';

  @override
  String get conflictGenericHeader =>
      'A conflict was detected. Please choose how to proceed.';

  @override
  String get conflictFetchRemote => 'Fetch remote';

  @override
  String get conflictOverwriteRemote => 'Overwrite GitHub';

  @override
  String get cannotDuplicateLinkedFile =>
      'Cannot duplicate file linked to GitHub';

  @override
  String get cannotDuplicateLinkedFileReason =>
      'This file is already synced with GitHub. You can only have one local instance per GitHub file. Consider creating a new file instead.';
}
