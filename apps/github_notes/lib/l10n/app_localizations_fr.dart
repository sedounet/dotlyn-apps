// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'GitHub Notes';

  @override
  String get note => 'Note';

  @override
  String get notes => 'Notes';

  @override
  String get addNote => 'Ajouter une Note';

  @override
  String get editNote => 'Modifier la Note';

  @override
  String get deleteNote => 'Supprimer la Note';

  @override
  String get save => 'Enregistrer';

  @override
  String get copilotTest => 'Chaîne de test Copilot (fr)';

  @override
  String get cancel => 'Annuler';

  @override
  String get sync => 'Synchroniser';

  @override
  String get settings => 'Paramètres';

  @override
  String get title => 'Titre';

  @override
  String get content => 'Contenu';

  @override
  String get conflictDialogTitle => 'Conflit détecté';

  @override
  String get conflictDialogDescription =>
      'Un conflit a été détecté entre votre fichier local et GitHub.';

  @override
  String get conflictFileExistsHeader =>
      'Ce fichier existe déjà sur GitHub. Que souhaitez-vous faire ?';

  @override
  String get conflictBothModifiedHeader =>
      'Des modifications ont été apportées à la fois localement et sur GitHub. Que souhaitez-vous faire pour résoudre ce conflit ?';

  @override
  String get conflictGenericHeader =>
      'Un conflit a été détecté. Veuillez choisir comment procéder.';

  @override
  String get conflictFetchRemote => 'Importer depuis GitHub';

  @override
  String get conflictOverwriteRemote => 'Écraser sur GitHub';

  @override
  String get cannotDuplicateLinkedFile =>
      'Impossible de dupliquer un fichier lié à GitHub';

  @override
  String get cannotDuplicateLinkedFileReason =>
      'Ce fichier est déjà synchronisé avec GitHub. Vous ne pouvez avoir qu\'une seule instance locale par fichier GitHub. Envisagez de créer un nouveau fichier à la place.';
}
