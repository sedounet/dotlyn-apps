# I18N (Localization) Implementation Guide

> **Status**: ✅ Implemented & Integrated (v0.2-v0.3)  
> **Date**: 2026-01-01  
> **Scope**: All 4 Dotlyn Apps + Centralized Infrastructure

---

## 📋 Overview

Centralized i18n infrastructure implemented in `packages/dotlyn_core`, with localization support for **English (en)** and **French (fr)** across all apps.

### Architecture

```
packages/dotlyn_core/lib/i18n/
├── supported_locales.dart        ← Locale definitions (en, fr)
├── locale_service.dart           ← SharedPreferences persistence
├── locale_provider.dart          ← Riverpod StateNotifierProvider
└── i18n_helpers.dart             ← Format utilities (date, currency, numbers)

apps/[app]/lib/l10n/
├── app_en.arb                    ← English strings (source)
├── app_fr.arb                    ← French strings
└── app_localizations.dart        ← Generated (flutter gen-l10n)
```

---

## 🔧 Setup Checklist

### Phase 1: Infrastructure ✅
- [x] Created `packages/dotlyn_core/lib/i18n/` module
- [x] Implemented `DotlynLocales` class (en, fr)
- [x] Implemented `LocaleService` (SharedPreferences-backed)
- [x] Created `localeProvider` (Riverpod StateNotifierProvider)
- [x] Added formatting helpers (I18nHelpers)
- [x] Updated dotlyn_core exports

### Phase 2: App Configuration ✅
- [x] Created `lib/l10n/` directory per app
- [x] Created `app_en.arb` + `app_fr.arb` per app
- [x] Created `l10n.yaml` configuration per app
- [x] Updated all app `pubspec.yaml`:
  - [x] Added `flutter_localizations: sdk: flutter`
  - [x] Added `generate: true` in flutter section
  - [x] Dependency resolution (intl ^0.20.0)
- [x] Updated all `main.dart`:
  - [x] Import localization delegate
  - [x] Watch `localeProvider` for reactive updates
  - [x] Configure MaterialApp with localizationsDelegates + supportedLocales

### Phase 3: Code Generation ✅
- [x] Ran `flutter gen-l10n` for all apps
- [x] Generated `app_localizations.dart` + language variants
- [x] All apps compile without errors

### Phase 4: Monorepo Integration ✅
- [x] Fixed `melos.yaml` package paths
- [x] Resolved intl version conflicts (0.20.2)
- [x] `melos bootstrap` passes ✅

---

## 🚀 Usage

### Access Localized Strings in UI

```dart
import 'l10n/app_localizations.dart';

// In a build method:
Text(AppLocalizations.of(context)!.appTitle)
```

### Format Values by Locale

```dart
import 'package:dotlyn_core/dotlyn_core.dart';

// In a provider/service:
final formatted = I18nHelpers.formatCurrency(
  amount: 1234.56,
  locale: ref.watch(localeProvider),
);

// Dates, numbers, percents also supported
I18nHelpers.formatDate(DateTime.now(), context);
I18nHelpers.formatNumber(1000, context);
I18nHelpers.formatPercent(0.85, context);
```

### Switch Language Programmatically

```dart
final localeNotifier = ref.read(localeProvider.notifier);
localeNotifier.setLocale(const Locale('fr')); // Switch to French
```

### Persist Language Preference

Persistence is **automatic** via `LocaleService` (SharedPreferences).  
On app restart, the last selected locale is restored.

---

## 📝 Adding Localized Strings

### 1. Edit ARB File

**apps/[app]/lib/l10n/app_en.arb**:
```json
{
  "@@locale": "en",
  "appTitle": "Money Tracker",
  "addTransaction": "Add Transaction",
  "balance": "Balance",
  "amount": "Amount"
}
```

**apps/[app]/lib/l10n/app_fr.arb**:
```json
{
  "@@locale": "fr",
  "appTitle": "Suivi Financier",
  "addTransaction": "Ajouter une transaction",
  "balance": "Solde",
  "amount": "Montant"
}
```

### 2. Regenerate Code

```bash
cd apps/[app]
flutter gen-l10n
```

### 3. Use in Code

```dart
Text(AppLocalizations.of(context)!.appTitle)
```

---

## 📦 Apps Configured

| App | ARB Files | l10n.yaml | main.dart Updated | Status |
|-----|-----------|-----------|-------------------|--------|
| `money_tracker` | ✅ | ✅ | ✅ | Ready |
| `github_notes` | ✅ | ✅ | ✅ | Ready |
| `habit_tracker` | ✅ | ✅ | ✅ | Ready |
| `sc_loop_analyzer` | ✅ | ✅ | ✅ | Ready |

---

## 🔌 Integration Points

### dotlyn_core Export

```dart
// lib/dotlyn_core.dart
export 'i18n/supported_locales.dart';
export 'i18n/locale_service.dart';
export 'i18n/locale_provider.dart';
export 'i18n/i18n_helpers.dart';
```

### Main.dart Pattern

```dart
import 'package:dotlyn_core/dotlyn_core.dart';
import 'l10n/app_localizations.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // ...
    );
  }
}
```

---

## 🧪 Testing Localization

### 1. Manual Testing on Device

```bash
cd apps/money_tracker
flutter run
# In app: Switch language via Settings (when implemented)
```

### 2. Widget Test Example

```dart
testWidgets('Locale switching updates UI', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MyWidget(),
      ),
    ),
  );

  // Verify English text
  expect(find.text('Money Tracker'), findsOneWidget);

  // Switch locale and verify French text
  // (requires ProviderContainer manipulation)
});
```

---

## 🎯 Next Steps (Optional)

### High Priority
- [ ] Add comprehensive strings to ARB files (not just basic UI text)
- [ ] Create `LanguageSelector` widget for Settings screens
- [ ] Test language switching on real device/emulator

### Medium Priority
- [ ] Add date/time/number formatting tests
- [ ] Document string keys in API reference
- [ ] Add CI/CD validation for ARB file integrity

### Low Priority
- [ ] Add third language support (Spanish, German, etc.)
- [ ] Implement pluralization rules in ARB files
- [ ] Add context-specific string variants

---

## 📚 References

- **Flutter Localizations**: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
- **intl Package**: https://pub.dev/packages/intl
- **ARB Specification**: https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification

---

## 🔄 Troubleshooting

### Issue: `Target of URI doesn't exist: 'package:flutter_gen/...'`
**Solution**: Use relative import instead:
```dart
import 'l10n/app_localizations.dart';  // ✅ Correct
// instead of
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

### Issue: `melos bootstrap` fails with YAML error
**Solution**: Ensure all pubspec.yaml files have correct structure:
- No duplicate keys (`flutter:`, `generate:`)
- Consistent indentation (2 spaces)
- Proper version constraints (intl ^0.20.0)

### Issue: `AppLocalizations.of(context)` returns null
**Solution**: Ensure app is built with correct delegates:
```dart
localizationsDelegates: AppLocalizations.localizationsDelegates,
supportedLocales: AppLocalizations.supportedLocales,
```

---

**Version**: 1.0  
**Last Updated**: 2026-01-01  
**Maintainer**: @sedounet
