# Instructions GitHub Copilot — Dotlyn Apps Monorepo

## 🎯 Contexte Projet

**Type** : Monorepo Flutter pour mini-apps Dotlyn  
**Structure** : Melos-based monorepo  
**Convention** : Apps indépendantes + packages partagés

**Organisation des chats** : Chaque conversation/chat doit être dédiée à une app spécifique ou un point technique particulier pour maintenir le contexte et la clarté.

**Apps actives** :
- `design_lab` — Outil interne pour tester le design system
- `money_tracker` — App de gestion financière (Drift + Riverpod)
- `github_notes` — Notes markdown synchro GitHub (mobile Android/iOS)
- `habit_tracker` — Tracker d'habitudes (en conception)
- `sc_loop_analyzer` — Analyseur de boucles Starcraft

**Standards techniques** : Voir [`_docs/APP_STANDARDS.md`](../_docs/APP_STANDARDS.md) pour les exigences i18n, analytics, ads à intégrer dès v0.2-v0.3.

---

## 📁 Structure Monorepo

```
dotlyn-apps/
├── _docs/              ← Documentation (apps + brand)
│   ├── apps/           ← Doc par app (APP.md + PITCH.md + ROADMAP.md + USER-NOTES.md)
│   ├── dotlyn/         ← Brand (STYLEGUIDE.md, polices)
│   ├── APP_STANDARDS.md ← Standards techniques (i18n, analytics, ads) ⭐
│   ├── DASHBOARD.md    ← Vue d'ensemble globale
│   └── GUIDE_TDD_TESTS.md ← Guide testing Flutter
├── apps/               ← Mini-apps Flutter indépendantes
│   └── [app]/
│       ├── lib/
│       │   ├── main.dart
│       │   ├── l10n/           ← Localization ARB files (v0.2+)
│       │   ├── data/database/  ← DB schemas (Drift)
│       │   ├── models/         ← Data models
│       │   ├── providers/      ← Riverpod providers
│       │   ├── screens/        ← UI screens
│       │   ├── services/       ← Business logic (analytics, etc.)
│       │   └── widgets/        ← Reusable widgets (+ ad placeholder)
│       └── pubspec.yaml
├── packages/           ← Code partagé (dotlyn_ui, dotlyn_core)
│   ├── dotlyn_ui/      ← Thème, couleurs, typography, widgets
│   └── dotlyn_core/    ← Services, providers, utils
└── melos.yaml          ← Config monorepo
```

---

## ⚙️ Architecture & Stack Technique

### Stack Standard (Money Tracker)
- **State Management** : Riverpod 2.4+ (StreamProvider, Provider, NotifierProvider) — Voir [`_docs/STATE_MANAGEMENT_CONVENTIONS.md`](../_docs/STATE_MANAGEMENT_CONVENTIONS.md) pour les patterns et conventions
- **Database** : Drift (SQLite) avec migrations versionnées
- **Code Generation** : build_runner (pour Drift schemas)
- **Patterns** : Repository pattern pour accès DB
- **Secure Storage** : flutter_secure_storage pour tokens/credentials — Voir [`_docs/SECURE_STORAGE_PATTERN.md`](../_docs/SECURE_STORAGE_PATTERN.md)
- **Testing** : Riverpod overrides + Drift mocks — Voir [`_docs/GUIDE_TDD_TESTS.md`](../_docs/GUIDE_TDD_TESTS.md)

### Structure Data Layer (exemple Money Tracker)
```dart
// 1. Schema DB avec Drift
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  RealColumn get amount => real()();
  // ... migrations via schemaVersion
}

// 2. Provider DB singleton
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

// 3. Repository avec métiers
class TransactionsRepository {
  Future<int> addTransaction({...}) => _database.into(...).insert(...);
}

// 4. Stream provider pour UI réactive
final transactionsProvider = StreamProvider.autoDispose.family<List<Transaction>, int>(
  (ref, accountId) => database.select(...).watch()
);
```

### Packages Partagés
- **dotlyn_ui** : Exports `theme/{colors,typography,theme}.dart` + widgets
  - Couleurs : `DotlynColors.primary` (E36C2D), `.secondary` (2C2C2C)
  - Import : `import 'package:dotlyn_ui/dotlyn_ui.dart';`
- **dotlyn_core** : Utils, constants, providers communs
  - Import : `import 'package:dotlyn_core/dotlyn_core.dart';`

### Melos Scripts Clés
```bash
melos bootstrap           # Init tous les packages
melos run analyze         # flutter analyze sur tout
melos run format          # dart format
melos run test            # flutter test
melos run build:runner    # Code generation (Drift, etc.)
```
### Workflows de Développement

**Lancer une app spécifique** :
```bash
# Méthode 1 : Depuis le dossier de l'app
cd apps/money_tracker
flutter run

# Méthode 2 : Spécifier le device
cd apps/money_tracker
flutter run -d chrome           # Web
flutter run -d windows          # Desktop Windows
flutter run -d <device-id>      # Device Android/iOS
```

**Après modification DB (Drift)** :
```bash
# Depuis le dossier de l'app (recommandé pour app isolée)
cd apps/money_tracker
flutter pub run build_runner build --delete-conflicting-outputs

# OU depuis la racine avec Melos (pour regénérer tout le monorepo)
melos run build:runner

# Puis hot restart (R dans terminal flutter run, pas hot reload r)
```

**Melos vs Flutter Pub** :
- **Melos** (`melos run ...`) : Commandes monorepo-wide (analyze, format, test sur toutes apps)
- **Flutter Pub** (`flutter pub ...`) : Commandes app-specific (run, build_runner sur une app)
- **Règle** : Utiliser `flutter pub` depuis `apps/[app]/` pour travailler sur une app, `melos` depuis racine pour CI/audit global

**Debug & Hot Reload** :
- Hot reload (`r`) : OK pour changements UI uniquement
- Hot restart (`R`) : REQUIS après modif DB, providers, ou structure
- DevTools : `flutter pub global activate devtools` puis `flutter pub global run devtools`

**Bootstrap après git pull** :
```bash
melos bootstrap          # Récupère les dépendances de tous les packages
```
---

## �🎯 Règles de Travail

### 1. Gestion Multi-Apps

**Quand l'utilisateur dit** : "On travaille sur Timer"  
**Tu dois** :
- Considérer que TOUTES les actions concernent l'app Timer
- Code → `apps/timer/`
- Doc → `_docs/apps/timer/APP.md`
- Issues → Label `timer` sur GitHub

**Quand l'utilisateur dit** : "Update la TODO"  
**Tu dois** :
- Éditer `_docs/apps/[app-active]/APP.md` section TODO
- NE PAS créer de fichier TODO.md séparé
- NE PAS confondre avec une autre app

---

### 2. Système de Documentation

**Chaque app a EXACTEMENT 4 fichiers** :

#### APP.md (fichier de travail)
- Versions (v0.1 MVP, v0.2, v0.3+)
- TODO avec priorités :
  - 🔴 P1 = ASAP (bugs bloquants + débloqueurs techniques)
  - 🟡 P2 = Prochaine version
  - 🔵 P3 = Plus tard
- Liens vers issues GitHub (→ numéro issue)
- Notes en vrac

#### PITCH.md (vision stable)
- Concept
- Identité visuelle (référence styleguide)
- Public cible
- Différenciation
- Métriques succès

#### USER-NOTES.md (notes d'utilisation) ⭐ NOUVEAU
- **Usage** : Notes personnelles de l'utilisateur au fil de l'utilisation quotidienne
- **Sections** :
  - 🐛 Bugs Rencontrés : Bugs observés avec date + contexte
  - 💡 Améliorations Souhaitées : Idées d'amélioration + justification
  - 📝 Notes d'Usage : Observations générales, comportements inattendus
  - ✅ Résolu : Bugs/améliorations traités (archive)
- **Workflow Copilot** :
  - Lire USER-NOTES.md régulièrement pour identifier les tâches à traiter
  - Déplacer les items traités vers section "✅ Résolu"
  - Utiliser comme source pour mise à jour APP.md TODO

#### PROMPT_USER.md (demande utilisateur)
- Fichier en langage naturel (1-2 chapitres max)
- L'utilisateur décrit ce qu'il veut réaliser
- Optionnel : maquette/capture et points d'attention
- **À vider ou supprimer après transformation**

#### PROMPT_AI.md (instructions structurées)
- Généré par Copilot à partir de PROMPT_USER.md
- Objectif + tâches + contexte technique + critères de succès
- **Supprimé ou réécrit à chaque nouvelle demande**

**Workflow** :
1. Utilisateur écrit dans PROMPT_USER.md
2. Copilot lit et transforme en PROMPT_AI.md structuré
3. Copilot exécute les tâches
4. Fichiers vidés/supprimés pour la prochaine demande

**Workflow USER-NOTES.md** :
1. Utilisateur prend des notes au fil de l'utilisation (bugs, idées, observations)
2. Copilot lit USER-NOTES.md lors des sessions de travail sur l'app
3. Copilot identifie les tâches prioritaires et les traite
4. Items résolus déplacés vers section "✅ Résolu" avec date de résolution

**NE JAMAIS** :
- Créer de fichier TODO.md séparé
- Créer de fichier MASTER.md
- Créer de fichier DECISION_*.md (décisions = commits + updates dans docs existantes)
- Garder plusieurs versions de prompts (PROMPT_V0.1.md, etc.)
- Multiplier les fichiers de doc au-delà de APP.md + PITCH.md + USER-NOTES.md + PROMPT_USER.md + PROMPT_AI.md

---

### 3. Workflow Git & Issues

**Issues GitHub** :
- Une issue = Un bug OU Une feature
- Labels obligatoires : `[nom-app]` + `bug` ou `feature`
- Priorité dans le titre si P1 : `[P1] Description`

**Commits** :
- Format : `[app] type: description`
- Exemples :
  - `[timer] feat: add background service`
  - `[timer] fix: crash on Android 12+`
  - `[docs] update: timer APP.md TODO section`

**Branches** :
- `main` = stable
- `feat/[app]-[feature]` = nouvelle feature
- `fix/[app]-[bug]` = correction bug

---

### 4. Conventions Code Flutter

**Packages partagés** :
- `dotlyn_ui` : Composants UI, thème, assets (sons, fonts)
- `dotlyn_core` : Services, models, utils

**Import packages** :
```dart
// Toujours préférer les packages partagés
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:dotlyn_core/dotlyn_core.dart';
```

**Structure app standardisée** :
```
apps/[nom]/
├── lib/
│   ├── main.dart
│   ├── data/database/        ← Drift schemas + app_database.dart
│   ├── models/               ← Data models (enums, classes)
│   ├── providers/            ← Riverpod providers (DB, repo, state)
│   │   ├── database_provider.dart
│   │   ├── [entity]_provider.dart
│   │   └── ui_state_provider.dart
│   ├── screens/              ← Screens with state consumption
│   └── widgets/              ← Reusable UI components (optionnel si pas de widgets extraits)
├── test/                     ← Tests unitaires et widgets
├── pubspec.yaml
└── README.md (court, lien vers _docs/)
```

**Patterns standards** :

*Drift + Riverpod* :
```dart
// Pattern: StreamProvider pour réactivité DB
final itemsProvider = StreamProvider.autoDispose.family<List<Item>, int>(
  (ref, filterId) {
    final db = ref.watch(databaseProvider);
    return (db.select(db.items)..where((t) => t.filter.equals(filterId))).watch();
  }
);
```

*Secure Storage (tokens/credentials)* :
- Utiliser `flutter_secure_storage` pour données sensibles
- Pattern documenté : `_docs/SECURE_STORAGE_PATTERN.md`
- Toujours invalider providers après écriture token
```dart
// Pattern: StreamProvider pour réactivité DB
final itemsProvider = StreamProvider.autoDispose.family<List<Item>, int>(
  (ref, filterId) {
    final db = ref.watch(databaseProvider);
    return (db.select(db.items)..where((t) => t.filter.equals(filterId))).watch();
  }
);

// Pattern: Repository avec méthodes métier
final itemsRepoProvider = Provider<ItemsRepository>((ref) {
  return ItemsRepository(ref.watch(databaseProvider));
});

// Migrations Drift: incrémenter schemaVersion + onUpgrade
@override
int get schemaVersion => 4;

@override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (m, from, to) async {
    if (from <= 3) await m.createTable(newTable);
  },
);
```

**Code Generation Drift** :
```bash
# Après modification des tables
flutter pub run build_runner build --delete-conflicting-outputs
# Ou via melos
melos run build:runner
```

---

### 5. Assets Partagés

**Sons, fonts, animations** :
- Stockés dans `packages/dotlyn_ui/lib/assets/`
- Accessibles via `DotlynAssets.sound('bell.mp3')`

**Assets spécifiques app** :
- Icônes, screenshots → `_docs/apps/[nom]/assets/`

**Brand assets** :
- Logos, templates → `_docs/dotlyn/brand-assets/`
- **Workflow icônes** : Voir [`_docs/dotlyn/WORKFLOW_ICONS.md`](../_docs/dotlyn/WORKFLOW_ICONS.md) pour la génération des app icons

---

### 6. Styleguide Dotlyn

**TOUJOURS respecter** `_docs/dotlyn/STYLEGUIDE.md` (source unique de vérité) :
- **Couleurs** : Orange terre cuite (#E36C2D), Gris anthracite (#2C2C2C), Bleu acier (#3A6EA5)
  - Utiliser via `DotlynColors.*` de `packages/dotlyn_ui/lib/theme/colors.dart`
- **Typo** : Satoshi (titres/logo) + Plus Jakarta Sans (UI/texte)
- **Icônes** : Remix Icon (app icons/launcher), Material Icons (UI interne Flutter)
- **Contraste** : WCAG AA minimum

**Usage** : `import 'package:dotlyn_ui/dotlyn_ui.dart';` puis `DotlynColors.primary`

**Dark Theme** :
- Toutes les apps doivent supporter le dark theme via `ThemeMode.system`
- Pattern standard :
```dart
MaterialApp(
  theme: DotlynTheme.lightTheme,
  darkTheme: DotlynTheme.darkTheme,
  themeMode: ThemeMode.system,
  // ...
)
```
- Utiliser `Theme.of(context).colorScheme.surface` au lieu de `Colors.white` hardcodé
- Vérifier `Theme.of(context).brightness` pour ajuster shadows/borders

---

---

### 7. Dashboard Global

**Quand mettre à jour** `_docs/DASHBOARD.md` :
- Changement de version d'une app
- Ajout/suppression d'app
- Changement significatif de status

**Ne PAS** le mettre à jour pour :
- Petites modifs dans APP.md
- Commits quotidiens

---

## 🚫 À NE JAMAIS FAIRE

❌ Créer un fichier TODO.md séparé (utiliser APP.md section TODO)  
❌ Dupliquer la doc entre fichiers  
❌ Utiliser d'autres polices que Satoshi/Plus Jakarta Sans  
❌ Utiliser d'autres icônes que Remix Icon  
❌ Créer des packages non partagés (code spécifique → dans app/)  
❌ Pusher sur `main` directement (toujours passer par PR)

---

## ✅ Checklist Avant Commit

- [ ] Code lint-free (`flutter analyze`)
- [ ] Tests passent (si existants)
- [ ] Doc à jour (APP.md si changement de features/bugs)
- [ ] Commit message respecte format `[app] type: description`
- [ ] Issue liée si applicable (closes numéro)

---

## 🎯 Exemples Concrets

### Exemple 1 : Ajout feature Timer
```
User: "Ajoute les notifications enrichies au timer"

Actions Copilot:
1. Créer branche: feat/timer-rich-notifications
2. Coder dans apps/timer/lib/services/notification_service.dart
3. Update _docs/apps/timer/APP.md:
   - Déplacer "Notifications enrichies" de P2 vers "En cours"
4. Commit: "[timer] feat: add rich notifications with actions"
5. Créer issue si pas existante
6. Update APP.md avec lien vers issue
```

### Exemple 2 : Bug critique
```
User: "Le timer crash sur Android 12+"

Actions Copilot:
1. Créer issue GitHub: "[P1] Timer crash on Android 12+"
2. Label: timer, bug, P1
3. Update _docs/apps/timer/APP.md section "🔴 P1":
   - [ ] Bug: Timer crash Android 12+ (lien issue)
4. Créer branche: fix/timer-android12-crash
5. Investiguer + fix
6. Commit: "[timer] fix: resolve crash on Android 12+ (closes issue)"
```

### Exemple 3 : Nouvelle app
```
User: "Créer une nouvelle app Notes"

Actions Copilot:
1. Créer apps/notes/ avec structure standard :
   ├── lib/
   │   ├── main.dart
   │   ├── data/database/       ← Si DB nécessaire
   │   ├── models/
   │   ├── providers/
   │   ├── screens/
   │   └── widgets/
   ├── test/
   ├── pubspec.yaml             ← Inclure dotlyn_ui, dotlyn_core
   └── README.md
2. Créer _docs/apps/notes/APP.md avec :
   - Vision
   - v0.1 MVP (phases si complexe)
   - TODO P1/P2/P3
3. Créer _docs/apps/notes/PITCH.md
4. Créer _docs/apps/notes/USER-NOTES.md (template avec sections 🐛💡📝✅)
5. Créer label GitHub "notes"
6. Update _docs/DASHBOARD.md (ajouter Notes dans tableau)
7. Commit: "[notes] init: create new notes app structure"
8. Bootstrap: cd apps/notes && flutter pub get
```

### Exemple 4 : Traiter notes utilisateur
```
User: "Regarde les notes dans USER-NOTES et traite les bugs/amélio"

Actions Copilot:
1. Lire _docs/apps/[app-active]/USER-NOTES.md
2. Identifier items prioritaires (bugs critiques en premier)
3. Pour chaque item traité:
   - Corriger le code ou implémenter l'amélioration
   - Déplacer l'item vers section "✅ Résolu" avec date
   - Ajouter référence dans APP.md TODO si tâche récurrente
4. Commit: "[app] fix/feat: address user-reported issues from USER-NOTES"
```
   └── README.md
2. Créer _docs/apps/notes/APP.md avec :
   - Vision
   - v0.1 MVP (phases si complexe)
   - TODO P1/P2/P3
3. Créer _docs/apps/notes/PITCH.md
4. Créer label GitHub "notes"
5. Update _docs/DASHBOARD.md (ajouter Notes dans tableau)
6. Commit: "[notes] init: create new notes app structure"
7. Bootstrap: cd apps/notes && flutter pub get
```

---

**Version** : 1.1  
**Dernière update** : 2025-12-28  
**Maintainer** : @sedounet
