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
- TODO avec structure claire :
  - 🚧 **In Progress** : Items en cours (max 3-5) avec branche + ETA
  - 🔴 **P1** : ASAP (bugs bloquants + débloqueurs techniques)
  - 🟡 **P2** : Next release (prochaine version planifiée)
  - 🔵 **P3** : Backlog (long terme, nice-to-have)
  - 🗨️ **Parking Lot** : Ajouts organiques en session (à trier en fin de session)
  - ✅ **Recently Done** : 15 derniers items ou 2 semaines (format strict avec SHA)
  - 📦 **Pre-Workflow Archive** : Items historiques dans collapsible (tag "Pre-Workflow")
- **Issues locales #N** : Numérotation séquentielle (ex: #1, #2, #10)
- **⛔ GitHub issues (GH#N) désactivées** : Feature verrouillée par défaut
- Format strict Recently Done : `- [x] #N: Description — Done YYYY-MM-DD (commit SHA7CHAR)`

#### CHANGELOG.md (historique versions)
- Format Keep a Changelog (https://keepachangelog.com)
- Section `[Unreleased]` pour changements en cours
- Sections par version avec date : `[0.1.0] - 2026-01-10`
- Catégories avec emojis : Added 🆕, Changed ✨, Fixed 🐛, Code Quality 🛠️, Security 🔒
- **Format store-ready** : Headline user-facing + Technical + Benefit/Impact + commit SHA
- **Workflow** : À chaque fix/feature complété, ajouter entrée dans `[Unreleased]` format strict
- Format strict : 
  ```markdown
  - **User-facing headline** (max 80 chars)
    - Technical: Implementation details
    - User benefit: Why it matters
    - (commit abc1234, from issue #5)
  ```
- **Release Notes** : Section copie-coller pour stores (Google Play 500 chars, App Store 4000 chars)

#### PITCH.md (vision stable)
- Concept
- Identité visuelle (référence styleguide)
- Public cible
- Différenciation
- Métriques succès

#### USER-NOTES.md (notes d'utilisation) ⭐
- **Usage** : Notes personnelles de l'utilisateur prises lors de l'utilisation de l'app
- **Format** : Simple, non structuré, style carnet de notes brut
- **Contenu typique** :
  - Bugs observés avec date + contexte
  - Idées d'amélioration + justification
  - Observations générales, comportements inattendus
- **Workflow Copilot (STRICT)** :
  - **LECTURE SEULE par défaut** : Lire USER-NOTES.md pour identifier bugs/features à traiter
  - **NE PAS MODIFIER sans validation** : Proposer les actions, discuter avec l'utilisateur, puis exécuter après validation
  - **Action** : Extraire les items et proposer de les copier dans APP.md TODO section avec priorisation (P1/P2/P3)
  - **Suppression** : Supprimer les notes traitées de USER-NOTES.md UNIQUEMENT après validation explicite de l'utilisateur
  - Exemple : Bug identifié → proposer création item dans APP.md P1 → attendre validation → exécuter + nettoyer USER-NOTES
- **Principe** : USER-NOTES.md n'est PAS un TODO, ni une roadmap, ni un outil de dev — c'est un carnet perso traité en mode collaboratif

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
1. Utilisateur prend des notes au fil de l'utilisation (bugs, idées, observations) — **fichier perso**
2. Copilot lit USER-NOTES.md lors des sessions de travail sur l'app
3. Copilot identifie les tâches prioritaires et **propose** de les ajouter dans APP.md TODO
4. **Discussion/validation** avec l'utilisateur sur les actions à prendre
5. Après validation, Copilot exécute (ajoute dans APP.md) et nettoie USER-NOTES.md

**⚠️ Gestion Git des USER-NOTES.md** :
- **AVANT de commit/push** : Toujours vérifier `git show origin/main:_docs/apps/[app]/USER-NOTES.md` pour comparer avec version locale
- **Si notes plus récentes sur main** : Fusionner manuellement avant commit (ne pas écraser)
- **Raison** : USER-NOTES créés/modifiés directement sur main (via app mobile sync) peuvent être plus récents que branche locale
- **Commande check** : `git diff HEAD origin/main -- _docs/apps/*/USER-NOTES.md`
- **TODO Workflow (2026-01-11)** : Avant tout commit sur branche, systématiquement exclure USER-NOTES.md du staging si modifiés localement ET vérifier version main en premier. Pattern: `git restore --staged _docs/apps/*/USER-NOTES.md` puis `git diff origin/main -- _docs/apps/*/USER-NOTES.md` → merger manuellement si conflit détecté.

**NE JAMAIS** :
- Créer de fichier TODO.md séparé
- Créer de fichier MASTER.md
- Créer de fichier DECISION_*.md (décisions = commits + updates dans docs existantes)
- Garder plusieurs versions de prompts (PROMPT_V0.1.md, etc.)
- Multiplier les fichiers de doc au-delà de APP.md + PITCH.md + USER-NOTES.md + PROMPT_USER.md + PROMPT_AI.md
- **Modifier USER-NOTES.md (lecture seule pour Copilot)**
- **Écraser USER-NOTES.md sans vérifier version main d'abord**

---

### 3. Workflow Git & Issues

**Convention de branchage** : Voir [`_docs/BRANCHING.md`](../_docs/BRANCHING.md) pour la convention complète.

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

**Workflow Commits (Copilot) — STRICT** :

**⚠️ CRITICAL** : TOUJOURS suivre [`_docs/PRE_COMMIT_CHECKLIST.md`](../_docs/PRE_COMMIT_CHECKLIST.md) AVANT de proposer un commit.

**Phases obligatoires (dans l'ordre)** :

**Phase 1 — Vérification Code** :
1. Lancer `flutter analyze` sur les fichiers modifiés → **MUST PASS** (0 errors)
2. Si imports modifiés/supprimés : `grep_search` pour vérifier usage AVANT suppression
3. Si tests existent : lancer `flutter test` → **MUST PASS**

**Phase 2 — Documentation** :
1. Mettre à jour `APP.md` TODO (cocher items terminés, ajouter nouveaux)
2. Mettre à jour `CHANGELOG.md` section `[Unreleased]` avec changements
3. Vérifier `USER-NOTES.md` : ne pas modifier sans validation utilisateur

**Phase 3 — Proposition Commit** :
1. Lister TOUS les fichiers modifiés (`git status`)
2. Formater message commit : `[app] type: description`
3. **PROPOSER** : "✅ Changements prêts : [liste fichiers]. Commit avec message `[message]` ?"
4. **ATTENDRE validation utilisateur**
5. Exécuter `git add` / `git commit` / `git push` UNIQUEMENT après validation

**⛔ NE JAMAIS** :
- Commiter sans exécuter `flutter analyze` d'abord
- Marquer items "fait" dans APP.md avant que tests passent
- Proposer commit si analyzer a des erreurs
- Supprimer imports sans `grep_search` pour vérifier usage
- Commiter automatiquement (toujours attendre validation utilisateur)

**Branches** :
- `main` = stable (source of truth)
- Format : `type/[app]-short-description` (ex: `feat/github_notes-add-project-form`)
- Types : `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `hotfix`
- Workflow : branch → commits → test local → merge direct → suppression branche
- Pas de PR obligatoire (merge direct après vérification locale)

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

**⚠️ CRITICAL** : Voir [`_docs/PRE_COMMIT_CHECKLIST.md`](../_docs/PRE_COMMIT_CHECKLIST.md) pour le workflow complet.

**Résumé strict** :
- [ ] `flutter analyze` passe (0 errors) sur fichiers modifiés
- [ ] Si imports modifiés : `grep_search` vérifie usage avant suppression
- [ ] Tests passent (si existants) : `flutter test`
- [ ] `APP.md` TODO à jour (items cochés si terminés)
- [ ] `CHANGELOG.md` section `[Unreleased]` mise à jour
- [ ] `USER-NOTES.md` non modifié (lecture seule)
- [ ] Commit message respecte format `[app] type: description`
- [ ] Issue liée si applicable (closes #numéro)
- [ ] **Validation utilisateur obtenue** avant `git commit`
- [ ] **Validation utilisateur obtenue** avant `git commit`

---

## 🎯 Exemples Concrets

### Exemple 1 : Ajout feature Timer
```
User: "Ajoute les notifications enrichies au timer"

Actions Copilot (ORDRE STRICT) :
1. Créer branche: feat/timer-rich-notifications
2. Coder dans apps/timer/lib/services/notification_service.dart
3. VÉRIFICATION CODE (Phase 1) :
   - Lancer: flutter analyze apps/timer/lib/services/
   - Vérifier: 0 errors
   - Si tests existent: flutter test apps/timer/test/
4. DOCUMENTATION (Phase 2) :
   - Update _docs/apps/timer/APP.md TODO:
     * Cocher "[ ] Notifications enrichies" en "[x] Notifications enrichies"
   - Update _docs/apps/timer/CHANGELOG.md section [Unreleased]:
     * Ajouter "### Added" + "- Rich notifications with actions"
5. PROPOSITION COMMIT (Phase 3) :
   - Lister fichiers modifiés: git status
   - Proposer: "✅ Changements prêts : notification_service.dart, APP.md, CHANGELOG.md. Commit avec message `[timer] feat: add rich notifications with actions` ?"
6. ATTENDRE validation utilisateur
7. Après validation → git add + git commit + git push
```

### Exemple 2 : Bug critique
```
User: "Le timer crash sur Android 12+"

Actions Copilot (ORDRE STRICT) :
1. Créer issue GitHub: "[P1] Timer crash on Android 12+"
2. Label: timer, bug, P1
3. Update _docs/apps/timer/APP.md section "🔴 P1":
   - Ajouter: "- [ ] Bug: Timer crash Android 12+ → #[numéro issue]"
4. Créer branche: fix/timer-android12-crash
5. Investiguer + coder le fix dans apps/timer/lib/...
6. VÉRIFICATION CODE (Phase 1) :
   - flutter analyze apps/timer/
   - flutter test apps/timer/ (si tests existent)
7. DOCUMENTATION (Phase 2) :
   - APP.md: Cocher item P1 "[x] Bug: Timer crash Android 12+"
   - CHANGELOG.md [Unreleased]: Ajouter "### Fixed" + "- Crash on Android 12+ (closes #X)"
8. PROPOSITION COMMIT (Phase 3) :
   - git status → lister fichiers
   - Proposer: "✅ Changements prêts : [fichiers]. Commit avec message `[timer] fix: resolve crash on Android 12+ (closes #X)` ?"
9. ATTENDRE validation → git add + commit + push
```

### Exemple 3 : Nouvelle app
```
User: "Créer une nouvelle app Notes"

Actions Copilot (ORDRE STRICT) :
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
4. Créer _docs/apps/notes/CHANGELOG.md (template Keep a Changelog)
5. Créer _docs/apps/notes/USER-NOTES.md (template avec sections 🐛💡📝✅)
6. Créer label GitHub "notes" (si applicable)
7. Update _docs/DASHBOARD.md (ajouter Notes dans tableau)
8. VÉRIFICATION CODE (Phase 1) :
   - cd apps/notes && flutter pub get
   - flutter analyze apps/notes/
9. DOCUMENTATION (Phase 2) :
   - Vérifier tous les docs créés (APP.md, PITCH.md, CHANGELOG.md, USER-NOTES.md)
   - DASHBOARD.md à jour
10. PROPOSITION COMMIT (Phase 3) :
   - git status → lister fichiers
   - Proposer: "✅ Changements prêts : structure notes/ + docs. Commit avec message `[notes] init: create new notes app structure` ?"
11. ATTENDRE validation → git add + commit + push
12. Bootstrap: cd apps/notes && flutter pub get
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
4. Proposer commit: "✅ Changements prêts : [liste fichiers]. Commit avec message `[app] fix/feat: address user-reported issues from USER-NOTES` ?"
5. Après validation → commit et push
```

---

**Version** : 1.1  
**Dernière update** : 2025-12-28  
**Maintainer** : @sedounet
