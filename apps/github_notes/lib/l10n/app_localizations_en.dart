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
  String get copilotTest => 'Copilot test string (en)';

  @override
  String tokenSaved(Object count) {
    return 'GitHub token saved (secure) — $count chars';
  }

  @override
  String errorSavingToken(Object error) {
    return 'Error saving token: $error';
  }

  @override
  String themeSet(Object mode) {
    return 'Theme set to $mode';
  }

  @override
  String languageSet(Object lang) {
    return 'Language set to $lang (no translations yet)';
  }

  @override
  String get tokenValid => 'Token is valid!';

  @override
  String get tokenInvalid => 'Token is invalid';

  @override
  String get addFileTitle => 'Add File to Track';

  @override
  String get ownerLabel => 'Owner';

  @override
  String get ownerHint => 'e.g., johndoe or my-org';

  @override
  String get repoLabel => 'Repository';

  @override
  String get repoHint => 'e.g., myapp';

  @override
  String get pathLabel => 'File Path';

  @override
  String get pathHint => 'e.g., README.md or _docs/apps/myapp/PROMPT_USER.md';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknameHint => 'e.g., MyApp - User Prompt';

  @override
  String get allFieldsRequired => 'All fields are required';

  @override
  String duplicateTrackedPath(Object owner, Object path, Object repo) {
    return 'This GitHub path ($owner/$repo/$path) is already tracked. Change the path or filename to create a duplicate.';
  }

  @override
  String get fileImported => 'File imported from GitHub';

  @override
  String get fileAddedLocal => 'File added (local only)';

  @override
  String get invalidTokenPleaseUpdate =>
      'Invalid GitHub token. Please update it in Settings.';

  @override
  String githubError(Object code) {
    return 'GitHub error ($code). Please try again later.';
  }

  @override
  String get noNetworkFileAdded =>
      'No network: file added locally. It will sync when online.';

  @override
  String errorCheckingGitHub(Object error) {
    return 'Error checking GitHub: $error';
  }

  @override
  String get fileAddedSuccessfully => 'File added successfully';

  @override
  String get add => 'Add';

  @override
  String get editFileTitle => 'Edit File Settings';

  @override
  String get noFilesConfigured => 'No files configured';

  @override
  String get goToSettings => 'Go to Settings to add files';

  @override
  String get openSettings => 'Open Settings';

  @override
  String errorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get ownerRequired => 'Please enter owner';

  @override
  String get repoRequired => 'Please enter repository';

  @override
  String get pathRequired => 'Please enter file path';

  @override
  String get nicknameRequired => 'Please enter a nickname';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get testToken => 'Test Token';

  @override
  String get saveToken => 'Save Token';

  @override
  String get debugTokenTitle => 'Debug: GitHub token';

  @override
  String get close => 'Close';

  @override
  String get copy => 'Copy';

  @override
  String get showTokenDebug => 'Show token (debug)';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageSystemDevice => 'System (device)';

  @override
  String get languageEn => 'English';

  @override
  String get languageFr => 'Français';

  @override
  String get deleteFileTitle => 'Delete File?';

  @override
  String deleteFileContent(Object nickname) {
    return 'Remove \"$nickname\" from tracked files?';
  }

  @override
  String get delete => 'Delete';

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

  @override
  String get justNow => 'Just now';
}
