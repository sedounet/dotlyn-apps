# Instructions GitHub Copilot — Dotlyn Apps Monorepo

> **Version** : 2.0  
> **Date** : 2026-01-11  
> **Principe** : Workflow v2.0 structuré, traçable, store-ready

---

## 🎯 Contexte Projet

**Type** : Monorepo Flutter pour mini-apps Dotlyn  
**Structure** : Melos-based, apps indépendantes + packages partagés  
**Convention** : Workflow v2.0 avec APP.md TODO structuré + CHANGELOG store-ready

**Apps actives** :
- `design_lab` — Outil interne design system
- `money_tracker` — Gestion financière (Drift + Riverpod)
- `github_notes` — Notes markdown synchro GitHub (Android/iOS)
- `habit_tracker` — Tracker d'habitudes (en conception)
- `sc_loop_analyzer` — Analyseur boucles Starcraft

**Standards techniques** : Voir [`_docs/APP_STANDARDS.md`](../_docs/APP_STANDARDS.md) pour i18n, analytics, ads (intégration v0.2-v0.3).

---

## 📁 Structure Monorepo

```
dotlyn-apps/
├── _docs/                          ← Documentation (apps + brand + workflow)
│   ├── apps/                       ← Doc par app
│   │   └── [app]/
│   │       ├── APP.md              ← Fichier de travail (TODO, versions)
│   │       ├── PITCH.md            ← Vision stable
│   │       ├── USER-NOTES.md       ← Notes utilisateur (LECTURE SEULE Copilot)
│   │       └── assets/             ← Screenshots, maquettes
│   ├── dotlyn/                     ← Brand (styleguide, fonts, logos)
│   ├── workflow/                   ← Workflow v2.0 documentation
│   │   ├── WORKFLOW.md             ← Guide complet workflow (source unique)
│   │   ├── VERSIONING_CHANGELOG.md ← Versioning + release notes stores
│   │   └── README.md               ← Index
│   ├── templates/new-app/          ← Templates copier-coller nouvelle app
│   ├── APP_STANDARDS.md            ← Standards techniques (i18n, analytics, ads)
│   ├── PRE_COMMIT_CHECKLIST.md     ← Checklist avant commit (3 phases)
│   └── BRANCHING.md                ← Convention branches
├── apps/                           ← Mini-apps Flutter
│   └── [app]/
│       ├── lib/
│       │   ├── main.dart
│       │   ├── l10n/               ← Localization ARB files (v0.2+)
│       │   ├── data/database/      ← Drift schemas
│       │   ├── models/             ← Data models
│       │   ├── providers/          ← Riverpod providers
│       │   ├── screens/            ← UI screens
│       │   ├── services/           ← Business logic
│       │   └── widgets/            ← Reusable components
│       ├── test/                   ← Tests unitaires + widgets
│       ├── CHANGELOG.md            ← Historique versions (Keep a Changelog)
│       └── pubspec.yaml
├── packages/                       ← Code partagé
│   ├── dotlyn_ui/                  ← Thème, couleurs, typography, widgets
│   └── dotlyn_core/                ← Services, providers, utils, i18n
└── melos.yaml                      ← Config monorepo
```

---

## ⚙️ Architecture & Stack Technique

### Stack Standard
- **State Management** : Riverpod 2.4+ (StreamProvider, Provider, NotifierProvider) — [`STATE_MANAGEMENT_CONVENTIONS.md`](../_docs/STATE_MANAGEMENT_CONVENTIONS.md)
- **Database** : Drift (SQLite) migrations versionnées
- **Code Generation** : build_runner (Drift schemas)
- **Patterns** : Repository pattern accès DB
- **Secure Storage** : flutter_secure_storage (tokens/credentials) — [`SECURE_STORAGE_PATTERN.md`](../_docs/SECURE_STORAGE_PATTERN.md)
- **Testing** : Riverpod overrides + Drift mocks — [`GUIDE_TDD_TESTS.md`](../_docs/GUIDE_TDD_TESTS.md)

### Packages Partagés
- **dotlyn_ui** : `import 'package:dotlyn_ui/dotlyn_ui.dart';` → DotlynColors, DotlynTheme, widgets
- **dotlyn_core** : `import 'package:dotlyn_core/dotlyn_core.dart';` → Services, utils, i18n (localeProvider, I18nHelpers)

### Melos Scripts
```bash
melos bootstrap           # Init packages
melos run analyze         # flutter analyze tout
melos run test            # flutter test tout
melos run build:runner    # Code generation Drift
```

### Workflows Dev
```bash
# App-specific (depuis apps/[app]/)
flutter run -d <device>
flutter pub run build_runner build --delete-conflicting-outputs

# Après modif DB Drift → hot restart (R), pas hot reload (r)
# Bootstrap après git pull
melos bootstrap
```

---

## 📝 Workflow v2.0 — Source Unique

> **Documentation complète** : [`_docs/workflow/WORKFLOW.md`](../_docs/workflow/WORKFLOW.md) (400 lignes)  
> **Versioning & Release** : [`_docs/workflow/VERSIONING_CHANGELOG.md`](../_docs/workflow/VERSIONING_CHANGELOG.md) (300 lignes)

### Vue d'Ensemble (5 Étapes)

```
1. SESSION START     → Consulter APP.md TODO, choisir #N depuis P1/P2
2. BRANCH CREATION   → git checkout -b feat/app-desc, move #N vers In Progress
3. DEVELOPMENT       → Coder, commiter, noter idées Parking Lot
4. VALIDATION        → flutter analyze + flutter test (MUST PASS)
5. DOCUMENTATION     → Move #N vers Recently Done (SHA), update CHANGELOG [Unreleased], commit
```

---

### APP.md Structure

```markdown
# [App Name] — APP.md

**Status** : 🟢 Active | 🟡 Beta | 🔴 Paused  
**Version actuelle** : 0.1.0  
**Dernière mise à jour** : YYYY-MM-DD

## 🎯 Vision
[2-3 phrases objectif app]

## ✅ Versions Complétées
### v0.1.0 (YYYY-MM-DD) — MVP Release
- Feature 1, Feature 2, Bug fixes

## 📝 TODO

<!-- 
RÈGLES STRICTES :
- Issues locales = #N (séquentiel #1, #2, #3...)
- Date format = YYYY-MM-DD
- Commit SHA = 7 chars OBLIGATOIRE dans Recently Done
- Recently Done = max 15 items OU 2 semaines
- In Progress = max 3-5 items actifs
- Parking Lot = trier 1x/semaine
-->

### 🚧 In Progress (max 3-5 items actifs)
- [ ] #5: Description — branch: feat/app-desc, started: YYYY-MM-DD, ETA: YYYY-MM-DD

### 🔴 P1 — ASAP
- [ ] #1: Bug critique X
- [ ] #2: Débloqueur technique Y

### 🟡 P2 — Prochaine version
- [ ] #10: Feature A
- [ ] #11: Feature B

### 🔵 P3 — Plus tard
- [ ] #20: Feature future Z

### 🅿️ Parking Lot (idées organiques)
<!-- Idées spontanées pendant dev, trier/vider chaque semaine -->
- Idée pendant #5 : améliorer dialog X
- Observation UX : bouton Y plus visible

### ✅ Recently Done (last 15 items or 2 weeks)
<!-- Format STRICT : [x] #N: Description — Done YYYY-MM-DD (commit SHA7CHAR) -->
- [x] #4: Description — Done 2026-01-10 (commit d8b2ac6)

## 🔗 Liens
- [PITCH.md](PITCH.md)
- [CHANGELOG.md](../../apps/[app]/CHANGELOG.md)
- [USER-NOTES.md](USER-NOTES.md)

**Version doc** : 1.0  
**Maintainer** : @username
```

---

### Issues Convention

**⛔ GitHub Issues DÉSACTIVÉES par défaut** (feature verrouillée)

**Format** :
- **Local** : `#N` (numérotation séquentielle #1, #2, #3...)
- **GitHub** : `GH#N` (après activation manuelle + gh CLI)

**Pourquoi local ?**
- Friction minimale (pas besoin GitHub web/CLI)
- Traçabilité APP.md (single source of truth)
- Scalable : escalade GitHub si besoin collaboration externe

**Numérotation** :
- Partir #1 pour nouvelle app
- Incrémenter séquentiellement (ne pas réutiliser)
- Référencer commits : `(closes #5)`, `(from issue #10)`

**Escalation GitHub** (optionnel) :
- Critères : collaboration externe, bug reports publics, roadmap public
- Setup : `gh auth login`, `gh issue create`, format `GH#N` dans APP.md

---

### Parking Lot — Gestion Idées Organiques

**Principe** : Capturer idées spontanées pendant dev sans interrompre flow.

**Format libre** (pas de #N nécessaire) :
```markdown
### 🅿️ Parking Lot
- Idée pendant #5 : dialog pourrait avoir bouton cancel
- Observation UX : loading indicator manque sur sync button
- Refactoring : extraire FileListWidget
```

**Workflow hebdomadaire** (vendredi) :
1. Revoir Parking Lot ligne par ligne
2. Promouvoir vers P1/P2/P3 (ajouter #N) ou supprimer
3. Vider Parking Lot après triage

**Avantages** : Capture immédiate, revue structurée, évite scope creep.

---

### CHANGELOG Workflow

**Format Keep a Changelog** :

```markdown
# Changelog

Format basé sur [Keep a Changelog](https://keepachangelog.com/).  
Versioning basé sur [Semantic Versioning](https://semver.org/).

## [Unreleased]

<!-- Section active quotidienne — PAS de dates ici -->

### Added 🆕
- **User-facing headline** (max 80 chars, store-ready)
  - Technical details
  - User benefit
  - (commit abc1234, closes #5)

### Fixed 🐛
- **Bug fix headline**
  - Technical: root cause + solution
  - Impact: what works now
  - (commit def5678, closes #3)

### Code Quality 🔧
- **Internal improvement**
  - Refactoring, performance
  - (commit ghi9012)

## [0.2.0] - 2026-01-15
[Copie de [Unreleased] au release]

## [0.1.0] - 2026-01-10
[Version initiale]
```

**Règles STRICTES** :
- ❌ **PAS de dates dans [Unreleased]** (ajoutées au release)
- ✅ **Headlines user-facing** (pas "fixed bug" → "improved security")
- ✅ **Technical details** en sous-points
- ✅ **Commit SHA + issue #N** systématiquement

**Workflow quotidien** :
- À chaque commit → ajouter entrée dans [Unreleased]

**Workflow release** :
- Renommer [Unreleased] → [0.2.0] - YYYY-MM-DD
- Créer nouvelle section [Unreleased] vide
- Tag Git : `git tag v0.2.0`

---

### Recently Done — Archivage

**Règles** : Max 15 items OU 2 semaines.

**Au-delà** :
1. Supprimer anciens items de APP.md
2. Vérifier présence dans CHANGELOG [version] ou [Unreleased]
3. Si absent → ajouter avant suppression

**Workflow hebdomadaire** :
- 1x/semaine : compter items, supprimer si > 15 ou > 2 semaines
- Commit : `[app] chore: archive old Recently Done items`

---

### Commit Workflow (PRE_COMMIT_CHECKLIST)

**Documentation complète** : [`_docs/PRE_COMMIT_CHECKLIST.md`](../_docs/PRE_COMMIT_CHECKLIST.md)

**Phase 1 : Vérification Code**
```bash
cd apps/[app]
flutter analyze  # MUST be clean (0 errors)
flutter test     # MUST pass
```

**Phase 2 : Documentation**
1. **Move item In Progress → Recently Done** avec SHA :
   ```markdown
   - [x] #5: Description — Done 2026-01-11 (commit d8b2ac6)
   ```
2. **Update CHANGELOG [Unreleased]** avec headline + technical + SHA
3. **Vérifier USER-NOTES.md** (ne PAS modifier sans validation)

**Phase 3 : Git Operations**
```bash
git status  # Vérifier fichiers
git add [files]
# PROPOSER commit à utilisateur : "✅ Changements prêts : [fichiers]. Commit avec message `[app] type: description (closes #N)` ?"
# ATTENDRE validation
git commit -m "[app] type: description (closes #N)"
git push origin <branch>
```

**Format commit** : `[app] type: description (closes #N)`
- Types : `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `hotfix`

---

### Branching

**Documentation complète** : [`_docs/BRANCHING.md`](../_docs/BRANCHING.md)

**Format** : `type/app-short-description`
- Exemples : `feat/github_notes-add-tooltips`, `fix/money_tracker-crash-android12`

**Workflow** :
```bash
# Création
git checkout main
git pull origin main
git checkout -b feat/app-desc

# Move issue vers In Progress dans APP.md
# ... dev + commits ...

# Merge
git checkout main
git merge --no-ff feat/app-desc
git push origin main

# Cleanup
git branch -d feat/app-desc
git push origin --delete feat/app-desc
```

**Intégration APP.md** :
- Lors création branche → Move #N de P1/P2 vers In Progress (branch, started, ETA)
- Lors merge → Move #N In Progress vers Recently Done (SHA)

---

## 🏗️ Conventions Code Flutter

### Structure App Standardisée

```
apps/[nom]/
├── lib/
│   ├── main.dart
│   ├── l10n/                   ← ARB files (v0.2+)
│   ├── data/database/          ← Drift schemas + app_database.dart
│   ├── models/                 ← Data models (enums, classes)
│   ├── providers/              ← Riverpod providers
│   │   ├── database_provider.dart
│   │   ├── [entity]_provider.dart
│   │   └── ui_state_provider.dart
│   ├── screens/                ← UI screens
│   ├── services/               ← Business logic
│   └── widgets/                ← Reusable components
├── test/                       ← Tests unitaires + widgets
├── CHANGELOG.md                ← Historique versions
├── pubspec.yaml
└── README.md                   ← Lien vers _docs/apps/[app]/
```

### Patterns Standards

**Drift + Riverpod** :
```dart
// StreamProvider réactivité DB
final itemsProvider = StreamProvider.autoDispose.family<List<Item>, int>(
  (ref, filterId) {
    final db = ref.watch(databaseProvider);
    return (db.select(db.items)..where((t) => t.filter.equals(filterId))).watch();
  }
);

// Repository pattern
final itemsRepoProvider = Provider<ItemsRepository>((ref) {
  return ItemsRepository(ref.watch(databaseProvider));
});

// Migrations Drift
@override
int get schemaVersion => 4;
@override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (m, from, to) async {
    if (from <= 3) await m.createTable(newTable);
  },
);
```

**Secure Storage** (tokens) :
```dart
// Provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

// Écriture + invalidation
await storage.write(key: 'token', value: token);
ref.invalidate(tokenProvider);
```

**Code Generation** :
```bash
cd apps/[app]
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📄 Système Documentation

### Fichiers par App (EXACTEMENT 4)

#### 1. APP.md (fichier de travail)
- Structure workflow v2.0 (voir ci-dessus)
- TODO sections : In Progress, P1/P2/P3, Parking Lot, Recently Done
- Issues #N locales
- Commit SHA OBLIGATOIRE Recently Done

#### 2. CHANGELOG.md (historique versions)
- Format Keep a Changelog
- [Unreleased] + versions numérotées
- Store-ready (headlines user-facing)

#### 3. PITCH.md (vision stable)
- Concept, identité visuelle, public cible
- Différenciation, métriques succès

#### 4. USER-NOTES.md (notes utilisateur)
- **LECTURE SEULE pour Copilot** (sauf validation explicite)
- Notes perso utilisateur (bugs, idées, observations)
- Workflow : Lire → Proposer ajout APP.md TODO → Attendre validation → Exécuter + nettoyer

**⚠️ Gestion Git USER-NOTES** :
- AVANT commit : vérifier `git show origin/main:_docs/apps/[app]/USER-NOTES.md`
- Si notes plus récentes sur main → fusionner manuellement
- Raison : USER-NOTES modifiés directement sur main (sync mobile app)

**NE JAMAIS créer** :
- TODO.md séparé
- MASTER.md
- DECISION_*.md
- Multiples versions prompts

---

### Prompt Files (temporaires)

#### PROMPT_USER.md
- Langage naturel utilisateur (1-2 chapitres)
- À vider/supprimer après transformation

#### PROMPT_AI.md
- Généré par Copilot depuis PROMPT_USER
- Objectif + tâches + contexte + critères
- Supprimé après exécution

---

## 🎨 Styleguide & Assets

**Documentation** : [`_docs/dotlyn/STYLEGUIDE.md`](../_docs/dotlyn/STYLEGUIDE.md)

**Couleurs** (via `DotlynColors.*`) :
- Primary : Orange terre cuite (#E36C2D)
- Secondary : Gris anthracite (#2C2C2C)
- Accent : Bleu acier (#3A6EA5)

**Typo** :
- Satoshi (titres/logo)
- Plus Jakarta Sans (UI/texte)

**Icônes** :
- Remix Icon (app launcher icons)
- Material Icons (UI interne Flutter)

**Dark Theme** :
```dart
MaterialApp(
  theme: DotlynTheme.lightTheme,
  darkTheme: DotlynTheme.darkTheme,
  themeMode: ThemeMode.system,  // OBLIGATOIRE
)
```

**Assets partagés** :
- Sons, fonts : `packages/dotlyn_ui/lib/assets/`
- Assets app-specific : `_docs/apps/[nom]/assets/`
- Brand : `_docs/dotlyn/brand-assets/`

**Workflow icônes** : [`_docs/dotlyn/WORKFLOW_ICONS.md`](../_docs/dotlyn/WORKFLOW_ICONS.md) (génération launcher icons)

---

## ✅ Checklist Avant Commit — Résumé

**Documentation complète** : [`_docs/PRE_COMMIT_CHECKLIST.md`](../_docs/PRE_COMMIT_CHECKLIST.md)

**CRITICAL — 3 Phases** :

**Phase 1 : Code**
- [ ] `flutter analyze` clean (0 errors)
- [ ] Si imports modifiés : `grep_search` vérifie usage
- [ ] `flutter test` pass (si tests existent)

**Phase 2 : Docs**
- [ ] APP.md : Move #N vers Recently Done avec SHA `(commit abc1234)`
- [ ] CHANGELOG [Unreleased] : Ajouter headline + technical + SHA
- [ ] USER-NOTES.md non modifié (lecture seule)

**Phase 3 : Git**
- [ ] `git status` vérifie fichiers (pas de tokens/secrets)
- [ ] Message commit : `[app] type: description (closes #N)`
- [ ] **PROPOSER à utilisateur** : "✅ Changements prêts : [fichiers]. Commit ?"
- [ ] **ATTENDRE validation** avant `git commit`

**⛔ NE JAMAIS** :
- Commiter sans `flutter analyze`
- Marquer Done avant tests pass
- Supprimer imports sans `grep_search`
- Commiter automatiquement (toujours proposer + attendre)

---

## 🎯 Exemples Concrets

### Exemple 1 : Bug Critique (P1 → Recently Done)

**Context** : App crash Android 12

**SESSION START** :
```markdown
### 🔴 P1
- [ ] #1: Bug: Crash on Android 12 startup
```

**BRANCH** :
```bash
git checkout -b fix/app-android12-crash
```

APP.md :
```markdown
### 🚧 In Progress
- [ ] #1: Bug: Crash Android 12 — branch: fix/app-android12-crash, started: 2026-01-11, ETA: 2026-01-11
```

**DEV** :
```dart
// Fix main.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Fix Android 12
  runApp(MyApp());
}
```

**VALIDATION** :
```bash
flutter analyze  # OK
flutter test     # OK
# Test Android 12 → OK
```

**DOCUMENTATION** :

APP.md :
```markdown
### ✅ Recently Done
- [x] #1: Crash Android 12 — Done 2026-01-11 (commit a1b2c3d)
```

CHANGELOG.md :
```markdown
## [Unreleased]

### Fixed
- **Android 12 startup crash resolved**
  - Technical: added WidgetsFlutterBinding.ensureInitialized()
  - Impact: app works on Android 12+
  - (commit a1b2c3d, closes #1)
```

**COMMIT** :
```bash
git commit -m "[app] fix: resolve Android 12 crash (closes #1)"
git push
```

---

### Exemple 2 : Feature + Parking Lot (P2 → In Progress → Recently Done)

**SESSION START** :
```markdown
### 🟡 P2
- [ ] #10: Add export settings
```

**BRANCH** :
```bash
git checkout -b feat/app-export-settings
```

APP.md :
```markdown
### 🚧 In Progress
- [ ] #10: Add export settings — branch: feat/app-export-settings, started: 2026-01-11, ETA: 2026-01-13
```

**DEV** :

Pendant dev, idée spontanée :
```markdown
### 🅿️ Parking Lot
- Import settings pourrait être symétrique (feature inverse)
```

Commits :
```bash
git commit -m "[app] feat: add export button"
git commit -m "[app] feat: implement JSON serialization"
```

**VALIDATION** :
```bash
flutter analyze  # OK
flutter test     # OK
```

**DOCUMENTATION** :

APP.md :
```markdown
### ✅ Recently Done
- [x] #10: Export settings — Done 2026-01-13 (commit def5678)
```

CHANGELOG :
```markdown
### Added
- **Export settings backup**
  - Technical: JSON export via Share sheet
  - User benefit: easy device migration
  - (commit def5678, closes #10)
```

**COMMIT** :
```bash
git commit -m "[app] feat: add settings export (closes #10)"
```

---

### Exemple 3 : Parking Lot Triage (Vendredi)

**Avant** :
```markdown
### 🅿️ Parking Lot
- Dialog add file : bouton cancel
- Loading indicator sync button
- Refactoring : extraire FileListWidget
- Performance : lazy loading listes
- Multi-repo support (futur)
```

**Après triage** :
```markdown
### 🔴 P1
- [ ] #15: Add loading indicator sync button

### 🟡 P2
- [ ] #16: Add cancel button dialog
- [ ] #17: Refactor: extract FileListWidget

### 🔵 P3
- [ ] #25: Performance: lazy loading
- [ ] #26: Feature: multi-repo

### 🅿️ Parking Lot
[vide]
```

Commit :
```bash
git commit -m "[app] chore: weekly parking lot triage"
```

---

## 🚫 À NE JAMAIS FAIRE

❌ Créer TODO.md séparé (utiliser APP.md section TODO)  
❌ Mélanger items Done et actifs dans P1/P2/P3  
❌ In Progress avec > 5 items  
❌ Parking Lot jamais trié (> 20 items)  
❌ Recently Done sans SHA  
❌ Dates dans CHANGELOG [Unreleased]  
❌ Commits sans référence issue  
❌ Sauter validation (analyzer + tests)  
❌ Commiter automatiquement sans proposer  
❌ Modifier USER-NOTES.md sans validation  
❌ Utiliser polices autres que Satoshi/Plus Jakarta Sans  
❌ Utiliser icônes autres que Remix Icon  
❌ Pusher sur `main` avec erreurs analyzer

---

## 📚 Références Complètes

### Workflow v2.0
- **Guide complet** : `_docs/workflow/WORKFLOW.md` (400 lignes, source unique)
- **Versioning & Release** : `_docs/workflow/VERSIONING_CHANGELOG.md` (300 lignes)
- **Pre-commit checklist** : `_docs/PRE_COMMIT_CHECKLIST.md` (3 phases strictes)
- **Branching** : `_docs/BRANCHING.md` (format + intégration APP.md)
- **Templates** : `_docs/templates/new-app/` (copier-coller instant)

### Standards Techniques
- **Apps standards** : `_docs/APP_STANDARDS.md` (i18n, analytics, ads v0.2+)
- **State management** : `_docs/STATE_MANAGEMENT_CONVENTIONS.md` (Riverpod vs provider)
- **Secure storage** : `_docs/SECURE_STORAGE_PATTERN.md` (tokens/credentials)
- **Tests** : `_docs/GUIDE_TDD_TESTS.md` (TDD workflow Flutter)

### Design & Brand
- **Styleguide** : `_docs/dotlyn/STYLEGUIDE.md` (couleurs, typo, icônes)
- **Workflow icônes** : `_docs/dotlyn/WORKFLOW_ICONS.md` (launcher icons génération)

---

**Version** : 2.0  
**Dernière update** : 2026-01-11  
**Maintainer** : @sedounet
