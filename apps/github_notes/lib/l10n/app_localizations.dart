import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'GitHub Notes'**
  String get appTitle;

  /// Note label
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// Notes label (plural)
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Button to add a new note
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// Button to edit note
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// Button to delete note
  ///
  /// In en, this message translates to:
  /// **'Delete Note'**
  String get deleteNote;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Test string for Copilot i18n setup verification
  ///
  /// In en, this message translates to:
  /// **'Copilot test string (en)'**
  String get copilotTest;

  /// Message shown after saving the token with sanitized length
  ///
  /// In en, this message translates to:
  /// **'GitHub token saved (secure) — {count} chars'**
  String tokenSaved(Object count);

  /// Error message when token saving fails
  ///
  /// In en, this message translates to:
  /// **'Error saving token: {error}'**
  String errorSavingToken(Object error);

  /// Confirmation of theme set
  ///
  /// In en, this message translates to:
  /// **'Theme set to {mode}'**
  String themeSet(Object mode);

  /// Confirmation of language set
  ///
  /// In en, this message translates to:
  /// **'Language set to {lang} (no translations yet)'**
  String languageSet(Object lang);

  /// No description provided for @tokenValid.
  ///
  /// In en, this message translates to:
  /// **'Token is valid!'**
  String get tokenValid;

  /// No description provided for @tokenInvalid.
  ///
  /// In en, this message translates to:
  /// **'Token is invalid'**
  String get tokenInvalid;

  /// No description provided for @addFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Add File to Track'**
  String get addFileTitle;

  /// No description provided for @ownerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerLabel;

  /// No description provided for @ownerHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., johndoe or my-org'**
  String get ownerHint;

  /// No description provided for @repoLabel.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get repoLabel;

  /// No description provided for @repoHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., myapp'**
  String get repoHint;

  /// No description provided for @pathLabel.
  ///
  /// In en, this message translates to:
  /// **'File Path'**
  String get pathLabel;

  /// No description provided for @pathHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., README.md or _docs/apps/myapp/PROMPT_USER.md'**
  String get pathHint;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @nicknameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., MyApp - User Prompt'**
  String get nicknameHint;

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields are required'**
  String get allFieldsRequired;

  /// No description provided for @duplicateTrackedPath.
  ///
  /// In en, this message translates to:
  /// **'This GitHub path ({owner}/{repo}/{path}) is already tracked. Change the path or filename to create a duplicate.'**
  String duplicateTrackedPath(Object owner, Object path, Object repo);

  /// No description provided for @fileImported.
  ///
  /// In en, this message translates to:
  /// **'File imported from GitHub'**
  String get fileImported;

  /// No description provided for @fileAddedLocal.
  ///
  /// In en, this message translates to:
  /// **'File added (local only)'**
  String get fileAddedLocal;

  /// No description provided for @invalidTokenPleaseUpdate.
  ///
  /// In en, this message translates to:
  /// **'Invalid GitHub token. Please update it in Settings.'**
  String get invalidTokenPleaseUpdate;

  /// GitHub error message with status code
  ///
  /// In en, this message translates to:
  /// **'GitHub error ({code}). Please try again later.'**
  String githubError(Object code);

  /// No description provided for @noNetworkFileAdded.
  ///
  /// In en, this message translates to:
  /// **'No network: file added locally. It will sync when online.'**
  String get noNetworkFileAdded;

  /// Error message when checking GitHub
  ///
  /// In en, this message translates to:
  /// **'Error checking GitHub: {error}'**
  String errorCheckingGitHub(Object error);

  /// No description provided for @fileAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'File added successfully'**
  String get fileAddedSuccessfully;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @editFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit File Settings'**
  String get editFileTitle;

  /// No description provided for @noFilesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No files configured'**
  String get noFilesConfigured;

  /// No description provided for @goToSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings to add files'**
  String get goToSettings;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Error message prefix with error text
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(Object error);

  /// No description provided for @ownerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner'**
  String get ownerRequired;

  /// No description provided for @repoRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter repository'**
  String get repoRequired;

  /// No description provided for @pathRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter file path'**
  String get pathRequired;

  /// No description provided for @nicknameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a nickname'**
  String get nicknameRequired;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @testToken.
  ///
  /// In en, this message translates to:
  /// **'Test Token'**
  String get testToken;

  /// No description provided for @saveToken.
  ///
  /// In en, this message translates to:
  /// **'Save Token'**
  String get saveToken;

  /// No description provided for @debugTokenTitle.
  ///
  /// In en, this message translates to:
  /// **'Debug: GitHub token'**
  String get debugTokenTitle;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @showTokenDebug.
  ///
  /// In en, this message translates to:
  /// **'Show token (debug)'**
  String get showTokenDebug;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageSystemDevice.
  ///
  /// In en, this message translates to:
  /// **'System (device)'**
  String get languageSystemDevice;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageFr.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFr;

  /// No description provided for @deleteFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete File?'**
  String get deleteFileTitle;

  /// Delete dialog content with nickname
  ///
  /// In en, this message translates to:
  /// **'Remove \"{nickname}\" from tracked files?'**
  String deleteFileContent(Object nickname);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Sync button
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// Settings label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Title label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Content label
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// Title for the conflict dialog
  ///
  /// In en, this message translates to:
  /// **'Conflict detected'**
  String get conflictDialogTitle;

  /// Description for the conflict dialog
  ///
  /// In en, this message translates to:
  /// **'A conflict was detected between your local file and GitHub.'**
  String get conflictDialogDescription;

  /// Header for add-file conflict when file exists remotely
  ///
  /// In en, this message translates to:
  /// **'This file already exists on GitHub. What would you like to do?'**
  String get conflictFileExistsHeader;

  /// Header for conflict when both local and remote have changes
  ///
  /// In en, this message translates to:
  /// **'Changes have been made both locally and on GitHub. How would you like to resolve this conflict?'**
  String get conflictBothModifiedHeader;

  /// Generic header for conflict dialog
  ///
  /// In en, this message translates to:
  /// **'A conflict was detected. Please choose how to proceed.'**
  String get conflictGenericHeader;

  /// Button label to fetch remote version
  ///
  /// In en, this message translates to:
  /// **'Fetch remote'**
  String get conflictFetchRemote;

  /// Button label to overwrite remote file
  ///
  /// In en, this message translates to:
  /// **'Overwrite GitHub'**
  String get conflictOverwriteRemote;

  /// Error message when trying to duplicate a file that is linked to GitHub
  ///
  /// In en, this message translates to:
  /// **'Cannot duplicate file linked to GitHub'**
  String get cannotDuplicateLinkedFile;

  /// Explanation for why a linked file cannot be duplicated
  ///
  /// In en, this message translates to:
  /// **'This file is already synced with GitHub. You can only have one local instance per GitHub file. Consider creating a new file instead.'**
  String get cannotDuplicateLinkedFileReason;

  /// Label for very recent events
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
