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
  String tokenSaved(Object count) {
    return 'Jeton GitHub enregistré (sécurisé) — $count caractères';
  }

  @override
  String errorSavingToken(Object error) {
    return 'Erreur lors de la sauvegarde du token : $error';
  }

  @override
  String themeSet(Object mode) {
    return 'Thème défini sur $mode';
  }

  @override
  String languageSet(Object lang) {
    return 'Langue définie sur $lang (pas encore de traductions)';
  }

  @override
  String get tokenValid => 'Le token est valide !';

  @override
  String get tokenInvalid => 'Le token est invalide';

  @override
  String get addFileTitle => 'Ajouter un fichier à suivre';

  @override
  String get ownerLabel => 'Propriétaire';

  @override
  String get ownerHint => 'ex: johndoe ou my-org';

  @override
  String get repoLabel => 'Dépôt';

  @override
  String get repoHint => 'ex: myapp';

  @override
  String get pathLabel => 'Chemin du fichier';

  @override
  String get pathHint => 'ex: README.md ou _docs/apps/myapp/PROMPT_USER.md';

  @override
  String get nicknameLabel => 'Surnom';

  @override
  String get nicknameHint => 'ex: MyApp - Prompt utilisateur';

  @override
  String get allFieldsRequired => 'Tous les champs sont obligatoires';

  @override
  String duplicateTrackedPath(Object owner, Object path, Object repo) {
    return 'Ce chemin GitHub ($owner/$repo/$path) est déjà suivi. Changez le chemin ou le nom du fichier pour créer un doublon.';
  }

  @override
  String get fileImported => 'Fichier importé depuis GitHub';

  @override
  String get fileAddedLocal => 'Fichier ajouté (local)';

  @override
  String get invalidTokenPleaseUpdate =>
      'Token GitHub invalide. Veuillez le mettre à jour dans les paramètres.';

  @override
  String githubError(Object code) {
    return 'Erreur GitHub ($code). Veuillez réessayer plus tard.';
  }

  @override
  String get noNetworkFileAdded =>
      'Pas de réseau : fichier ajouté localement. Il sera synchronisé quand en ligne.';

  @override
  String errorCheckingGitHub(Object error) {
    return 'Erreur lors de la vérification GitHub : $error';
  }

  @override
  String get fileAddedSuccessfully => 'Fichier ajouté avec succès';

  @override
  String get add => 'Ajouter';

  @override
  String get editFileTitle => 'Modifier les paramètres du fichier';

  @override
  String get noFilesConfigured => 'Aucun fichier configuré';

  @override
  String get goToSettings => 'Aller dans Paramètres pour ajouter des fichiers';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String errorMessage(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get ownerRequired => 'Veuillez saisir le propriétaire';

  @override
  String get repoRequired => 'Veuillez saisir le dépôt';

  @override
  String get pathRequired => 'Veuillez saisir le chemin du fichier';

  @override
  String get nicknameRequired => 'Veuillez saisir un surnom';

  @override
  String get duplicate => 'Dupliquer';

  @override
  String get edit => 'Modifier';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get testToken => 'Tester le token';

  @override
  String get saveToken => 'Enregistrer le token';

  @override
  String get debugTokenTitle => 'Debug : token GitHub';

  @override
  String get close => 'Fermer';

  @override
  String get copy => 'Copier';

  @override
  String get showTokenDebug => 'Afficher le token (debug)';

  @override
  String get themeTitle => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get languageTitle => 'Langue';

  @override
  String get languageSystem => 'Système';

  @override
  String get languageSystemDevice => 'Système (appareil)';

  @override
  String get languageEn => 'English';

  @override
  String get languageFr => 'Français';

  @override
  String get deleteFileTitle => 'Supprimer le fichier ?';

  @override
  String deleteFileContent(Object nickname) {
    return 'Supprimer \"$nickname\" des fichiers suivis ?';
  }

  @override
  String get delete => 'Supprimer';

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

  @override
  String get justNow => 'À l\'instant';
}
