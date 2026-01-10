# Standards Techniques — Apps Dotlyn

> **Objectif** : Standards obligatoires à intégrer dès les premières versions de toute app Dotlyn  
> **Principe** : Ne pas réinventer la roue ; intégrer localization, analytics et ads placeholder dès le MVP+1

---

## 🎯 Philosophie

**Les 3 piliers techniques à intégrer early (v0.2-v0.3 max)** :
1. **Localization (i18n)** : Pas de strings hardcodés, support multi-langues dès le début
2. **Analytics** : Tracking events + privacy opt-in/opt-out dès le début
3. **Ads Placeholder** : Layout préparé pour bannières publicitaires (même si pas activées en prod)

**Pourquoi early ?**
- Refactoring i18n après MVP = technique debt massive
- Analytics sans historique = perte d'insights early adopters
- Layout sans safe area ads = redesign coûteux plus tard

---

## 📱 1. Localization (i18n)

### Quand intégrer
**v0.2-v0.3 maximum** (avant toute beta publique)

### Stack technique
- **Package** : `flutter_localizations` + `intl` + **dotlyn_core/i18n**
- **Format** : ARB files (`l10n/app_en.arb`, `l10n/app_fr.arb`)
- **Langues minimum** : Français (fr) + Anglais (en)
- **Infrastructure centralisée** : `packages/dotlyn_core/lib/i18n/` (localeProvider, LocaleService, I18nHelpers)

### Architecture

```
packages/dotlyn_core/lib/i18n/
├── supported_locales.dart        ← Locale definitions (DotlynLocales.en, .fr)
├── locale_service.dart           ← SharedPreferences persistence
├── locale_provider.dart          ← Riverpod StateNotifierProvider
└── i18n_helpers.dart             ← Format utilities (date, currency, numbers)

apps/[app]/lib/l10n/
├── app_en.arb                    ← English strings (source)
├── app_fr.arb                    ← French strings
└── app_localizations.dart        ← Generated (flutter gen-l10n)
```

### Configuration pubspec.yaml
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.0
  dotlyn_core:
    path: ../../packages/dotlyn_core

flutter:
  generate: true # Active la génération automatique
```

### Configuration l10n.yaml
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### Structure fichiers
```
apps/[nom]/
├── lib/
│   └── l10n/
│       ├── app_en.arb  ← Anglais (défaut)
│       ├── app_fr.arb  ← Français
│       └── app_localizations.dart ← Généré
└── l10n.yaml           ← Configuration génération
```

### Exemple ARB (app_en.arb)
```json
{
  "@@locale": "en",
  "appTitle": "My App",
  "@appTitle": {
    "description": "The title of the application"
  },
  "welcomeMessage": "Welcome to {appName}!",
  "@welcomeMessage": {
    "description": "Welcome message with app name",
    "placeholders": {
      "appName": {
        "type": "String"
      }
    }
  }
}
```

### Générer les localisations
```bash
cd apps/[app]
flutter gen-l10n
```

### Usage dans le code

#### Import correct
```dart
// ✅ Correct: relative import
import 'l10n/app_localizations.dart';

// ❌ Incorrect: package import
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

#### Dans un widget
```dart
Text(AppLocalizations.of(context)!.appTitle)
```

#### Configuration MaterialApp avec Riverpod
```dart
import 'package:dotlyn_core/dotlyn_core.dart';
import 'l10n/app_localizations.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider); // Reactive locale

    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // ...
    );
  }
}
```

#### Changer la langue programmatiquement
```dart
import 'package:dotlyn_core/dotlyn_core.dart';

// Dans un Settings screen
final localeNotifier = ref.read(localeProvider.notifier);
localeNotifier.setLocale(const Locale('fr')); // Switch to French
```

#### Formater dates/nombres/currency selon locale
```dart
import 'package:dotlyn_core/dotlyn_core.dart';

// Format currency
final formatted = I18nHelpers.formatCurrency(
  amount: 1234.56,
  locale: ref.watch(localeProvider),
);

// Format date
I18nHelpers.formatDate(DateTime.now(), context);

// Format number
I18nHelpers.formatNumber(1000, context);

// Format percentage
I18nHelpers.formatPercent(0.85, context);
```

### Checklist i18n
- [ ] Tous les strings UI dans ARB files (0 hardcodés)
- [ ] Supporte en + fr minimum
- [ ] Plurals gérés (ex: "1 item" vs "2 items")
- [ ] Dates/nombres formatés selon locale via I18nHelpers
- [ ] Changement langue fonctionne sans redémarrage (reactive via localeProvider)
- [ ] Locale persiste entre redémarrages (automatique via LocaleService)
- [ ] MaterialApp watch localeProvider pour réactivité

---

## 📊 2. Analytics

### Quand intégrer
**v0.3 maximum** (dès que l'app a des utilisateurs réels)

### Stack technique recommandée
- **Option A** : Firebase Analytics (gratuit, complet, bien intégré Flutter)
- **Option B** : Posthog (open-source, self-hosted possible)
- **Option C** : Custom (API backend propre)

### Architecture
```
lib/services/
├── analytics_service.dart       ← Interface abstraite
└── firebase_analytics_impl.dart ← Implémentation concrète
```

### Interface abstraite (analytics_service.dart)
```dart
abstract class AnalyticsService {
  Future<void> initialize();
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String? value);
  Future<void> logScreenView(String screenName);
}
```

### Implémentation Firebase (firebase_analytics_impl.dart)
```dart
class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> initialize() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  // ... autres méthodes
}
```

### Provider Riverpod
```dart
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return FirebaseAnalyticsService();
});
```

### Events standards à tracker
- **App lifecycle** :
  - `app_open` : App lancée
  - `app_background` : App mise en arrière-plan
  
- **Navigation** :
  - `screen_view` : Changement d'écran (automatique via observer)
  
- **Actions utilisateur** :
  - `button_clicked` : Bouton cliqué (+ param `button_name`)
  - `feature_used` : Feature spécifique utilisée
  
- **Business events** (spécifiques à l'app) :
  - Exemple GitHub Notes : `file_opened`, `file_saved`, `sync_success`, `sync_conflict`

### Privacy & Opt-out
**OBLIGATOIRE** : Ajouter un toggle dans Settings

```dart
// Dans settings_screen.dart
SwitchListTile(
  title: Text(AppLocalizations.of(context)!.analyticsTitle),
  subtitle: Text(AppLocalizations.of(context)!.analyticsSubtitle),
  value: _analyticsEnabled,
  onChanged: (bool value) async {
    await _updateAnalyticsPreference(value);
  },
)

// Respecter le choix utilisateur
if (_analyticsEnabled) {
  await ref.read(analyticsServiceProvider).logEvent('my_event');
}
```

### Checklist Analytics
- [ ] Service abstraction créée
- [ ] Events clés définis et trackés
- [ ] Opt-in/opt-out dans Settings
- [ ] Privacy policy mentionne analytics
- [ ] Logs en dev mode (console output)

---

## 💰 3. Ads Placeholder

### Quand intégrer
**v0.3-v0.4** (avant release publique)

### Principe
- Intégrer le **layout** et le **placeholder** dès le début
- SDK ads réel (AdMob, etc.) ajouté plus tard (v0.5+)
- Feature flag pour activer/désactiver

### Widget placeholder (lib/widgets/ad_banner_placeholder.dart)
```dart
class AdBannerPlaceholder extends StatelessWidget {
  final bool showAd;
  
  const AdBannerPlaceholder({
    super.key,
    this.showAd = false, // Feature flag
  });

  @override
  Widget build(BuildContext context) {
    if (!showAd) return const SizedBox.shrink();
    
    return Container(
      height: 60, // Hauteur standard banner
      color: Theme.of(context).colorScheme.surfaceVariant,
      alignment: Alignment.center,
      child: Text(
        'Ad Space',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
```

### Intégration dans les screens
```dart
// Exemple: files_list_screen.dart
Scaffold(
  body: Column(
    children: [
      Expanded(
        child: ListView(...), // Contenu principal
      ),
      AdBannerPlaceholder(showAd: _showAds), // Banner en bas
    ],
  ),
)
```

### SafeArea + Bottom padding
```dart
// Toujours wraper dans SafeArea
SafeArea(
  child: Column(
    children: [
      Expanded(child: content),
      AdBannerPlaceholder(),
    ],
  ),
)
```

### Feature flag (DB ou Settings)
```dart
// Dans app_database.dart
class AppSettings extends Table {
  // ...
  BoolColumn get showAds => boolean().withDefault(const Constant(false))();
}

// Dans settings_screen.dart
SwitchListTile(
  title: Text('Show Ads (Dev)'),
  value: _showAds,
  onChanged: (value) => _updateShowAds(value),
)
```

### Migration vers SDK réel (v0.5+)
```dart
// Remplacer AdBannerPlaceholder par AdBannerWidget
class AdBannerWidget extends StatefulWidget {
  // Intégration Google AdMob, etc.
}
```

### Checklist Ads
- [ ] Placeholder widget créé
- [ ] Layout adaptable (safe area respected)
- [ ] Feature flag implémenté
- [ ] Pas de crash si placeholder affiché
- [ ] UI reste utilisable avec banner visible

---

## 🎨 4. Theming (Bonus)

### Standards Dotlyn Theme
- **Light theme** : `DotlynTheme.lightTheme`
- **Dark theme** : `DotlynTheme.darkTheme`
- **Mode** : `ThemeMode.system` (suit le système par défaut)

### Persistance préférence utilisateur
```dart
// Dans app_database.dart
class AppSettings extends Table {
  TextColumn get themeMode => text().withDefault(const Constant('system'))(); // 'light', 'dark', 'system'
}

// MaterialApp
MaterialApp(
  theme: DotlynTheme.lightTheme,
  darkTheme: DotlynTheme.darkTheme,
  themeMode: _getThemeMode(), // Depuis DB
)
```

---

## 📋 Checklist Nouvelle App

Avant de merger une app en `main`, vérifier :

### MVP (v0.1)
- [ ] Fonctionnalités core implémentées
- [ ] Tests unitaires (DB + logique métier)
- [ ] Docs : APP.md + PITCH.md + USER-NOTES.md + CHANGELOG.md

### Standards Early (v0.2-v0.3)
- [ ] **Localization** : ARB files en/fr, 0 strings hardcodés
- [ ] **Analytics** : Service abstraction + events clés + opt-out UI
- [ ] **Ads Placeholder** : Widget créé + layout safe area
- [ ] **Theming** : Dark theme complet + switcher persistant

### Pre-release (v0.5-v1.0)
- [ ] Tests d'intégration
- [ ] CI/CD (analyze + test + build)
- [ ] Privacy policy
- [ ] Store assets (screenshots, description)

---

## 🔗 Références

- **State Management (Riverpod)** : [`STATE_MANAGEMENT_CONVENTIONS.md`](STATE_MANAGEMENT_CONVENTIONS.md)
- **Guide tests** : [`GUIDE_TDD_TESTS.md`](GUIDE_TDD_TESTS.md)
- **Secure storage** : [`SECURE_STORAGE_PATTERN.md`](SECURE_STORAGE_PATTERN.md)
- **Styleguide** : [`dotlyn/STYLEGUIDE.md`](dotlyn/STYLEGUIDE.md)
- **Icon Workflow** : [`dotlyn/WORKFLOW_ICONS.md`](dotlyn/WORKFLOW_ICONS.md)

---

**Version** : 1.1  
**Dernière mise à jour** : 2026-01-01  
**Maintainer** : @sedounet
