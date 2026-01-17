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
