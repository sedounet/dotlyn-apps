# Workflow v2.0 — Guide Complet

> **Statut** : DÉFINITIF — Source unique de vérité pour le workflow  
> **Date** : 2026-01-11  
> **Principe** : Workflow structuré, traçable, scalable pour solo dev ou petite équipe

---

## 🎯 Vue d'Ensemble

Le workflow v2.0 structure le développement quotidien autour de 5 étapes claires :

```
1. SESSION START     → Consulter APP.md TODO, choisir priorités
2. BRANCH CREATION   → Créer branche, move item vers In Progress
3. DEVELOPMENT       → Coder, tester, noter idées dans Parking Lot
4. VALIDATION        → Tests passent, code analyzed
5. DOCUMENTATION     → Move to Recently Done (SHA), update CHANGELOG, commit
```

**Objectif** : Traçabilité maximale + friction minimale + store-readiness

---

## 📝 APP.md — Structure Complète

### Template Sections

```markdown
# [App Name] — APP.md

**Status** : 🟢 Active | 🟡 Beta | 🔴 Paused  
**Version actuelle** : 0.1.0  
**Dernière mise à jour** : YYYY-MM-DD

---

## 🎯 Vision

[2-3 phrases décrivant l'objectif de l'app]

---

## ✅ Versions Complétées

### v0.1.0 (YYYY-MM-DD) — MVP Release
- Feature 1 complétée
- Feature 2 complétée
- Bug fixes critiques

### v0.2.0 (YYYY-MM-DD) — [Nom release]
- Feature 3 ajoutée
- Amélioration UX

---

## 📝 TODO

<!-- 
RÈGLES STRICTES :
- Issues locales = #N (numérotation séquentielle #1, #2, #3...)
- Date format = YYYY-MM-DD
- Commit SHA = 7 premiers chars OBLIGATOIRE dans Recently Done
- Recently Done = garder max 15 items OU 2 semaines
- In Progress = max 3-5 items actifs simultanément
- Parking Lot = vider/trier régulièrement (1x par semaine)
-->

### 🚧 In Progress (max 3-5 items actifs)

<!-- Items en cours de développement avec branch tracking -->

- [ ] #5: Description précise de la tâche — branch: feat/app-short-desc, started: YYYY-MM-DD, ETA: YYYY-MM-DD

### 🔴 P1 — ASAP

<!-- Bugs bloquants, débloqueurs techniques, release blockers -->

- [ ] #1: Bug critique X
- [ ] #2: Débloqueur technique Y

### 🟡 P2 — Prochaine version

<!-- Features planifiées, améliorations UX/DX -->

- [ ] #10: Feature A
- [ ] #11: Feature B

### 🔵 P3 — Plus tard

<!-- Backlog long-terme, idées futures -->

- [ ] #20: Feature future Z

### 🅿️ Parking Lot (idées organiques)

<!-- 
Idées apparues spontanément pendant dev
À trier chaque semaine : promouvoir en P1/P2/P3 ou supprimer
Format libre, pas de #N nécessaire
-->

- Idée spontanée pendant travail sur #5 : améliorer dialog X
- Observation UX : bouton Y pourrait être plus visible
- Refactoring possible : extraire widget W

### ✅ Recently Done (last 15 items or 2 weeks)

<!-- 
Format STRICT : [x] #N: Description — Done YYYY-MM-DD (commit SHA7CHAR)
Archiver dans CHANGELOG après 15 items OU 2 semaines
-->

- [x] #4: Description tâche — Done 2026-01-10 (commit d8b2ac6)
- [x] #3: Description tâche — Done 2026-01-09 (commit a1b2c3d)

---

## 🔗 Liens

- [PITCH.md](PITCH.md) — Vision, persona, différenciation
- [CHANGELOG.md](../../apps/[app]/CHANGELOG.md) — Historique versions
- [USER-NOTES.md](USER-NOTES.md) — Notes utilisateur

---

**Version doc** : 1.0  
**Dernière mise à jour** : YYYY-MM-DD  
**Maintainer** : @username
```

---

## 🏷️ Issues Convention

### ⛔ GitHub Issues DÉSACTIVÉES par défaut

**Principe** : Issues locales (#N) suffisent pour solo dev ou petite équipe.

**Format** :
- **Local** : `#N` (numérotation séquentielle #1, #2, #3...)
- **GitHub** : `GH#N` (après activation manuelle, voir section Escalation)

**Pourquoi local by default ?**
- Friction minimale (pas besoin GitHub CLI/web)
- Traçabilité dans APP.md (single source of truth)
- Scalable : escalade vers GitHub si besoin collaboration externe

### Numérotation Séquentielle

**Règles** :
1. Partir de #1 pour nouvelle app
2. Incrémenter séquentiellement (#1, #2, #3, #4...)
3. NE PAS réutiliser numéros (même si #5 supprimé, prochain = #6)
4. Référencer dans commits : `(closes #5)` ou `(from issue #10)`

**Exemple APP.md** :
```markdown
### 🔴 P1
- [ ] #1: Bug critique login
- [ ] #2: Token validation fails

### 🟡 P2
- [ ] #10: Add dark mode settings
- [ ] #11: Export backup feature

### ✅ Recently Done
- [x] #5: Fix crash on Android 12 — Done 2026-01-10 (commit d8b2ac6)
```

### Escalation vers GitHub Issues (optionnel)

**Critères pour activer GitHub issues** :
- Collaboration externe (contributeurs externes)
- Bug reports publics
- Feature requests communauté
- Tracking public roadmap

**Setup** (une fois activé) :

1. Installer GitHub CLI :
   ```bash
   winget install GitHub.cli
   gh auth login
   ```

2. Créer issue depuis terminal :
   ```bash
   gh issue create --title "[App] Bug: description" --body "Details..." --label "app,bug,P1"
   ```

3. Dans APP.md, utiliser format `GH#N` :
   ```markdown
   ### 🔴 P1
   - [ ] #1: Bug local (tracking interne)
   - [ ] GH#42: Bug public reporté par utilisateur (GitHub issue #42)
   ```

4. Fermer issue :
   ```bash
   gh issue close 42 --comment "Fixed in commit abc1234"
   ```

**Pattern commit** avec GitHub issue :
```
[app] fix: resolve crash on startup (closes GH#42, related to #1)
```

---

## 📂 Parking Lot — Gestion des Idées Organiques

### Principe

Pendant le développement, des idées **spontanées** surgissent (refactoring, amélioration UX, optimisation...). Au lieu de :
- ❌ Les oublier
- ❌ Les implémenter immédiatement (scope creep)
- ❌ Les noter ailleurs (dispersion)

→ ✅ **Les capturer dans Parking Lot**

### Format

**Libre, pas de #N nécessaire** (sauf si promotion vers P1/P2/P3) :

```markdown
### 🅿️ Parking Lot

- Idée spontanée pendant travail sur #5 : dialog pourrait avoir bouton cancel
- Observation UX : loading indicator manque sur sync button
- Refactoring possible : extraire FileListWidget (réutilisable)
- Performance : lazy loading pour grandes listes (> 100 items)
```

### Workflow Hebdomadaire (Triage)

**1x par semaine** (ex : vendredi après-midi) :

1. **Revoir Parking Lot** ligne par ligne
2. **Décider pour chaque item** :
   - 🔴 Critique → promouvoir en P1 (ajouter #N)
   - 🟡 Important → promouvoir en P2 (ajouter #N)
   - 🔵 Nice-to-have → promouvoir en P3 (ajouter #N)
   - 🗑️ Pas prioritaire → supprimer
3. **Vider Parking Lot** après triage

**Exemple triage** :

```markdown
### 🅿️ Parking Lot (avant)
- Dialog pourrait avoir bouton cancel
- Loading indicator manque sur sync button
- Extraire FileListWidget
- Lazy loading grandes listes

### Après triage :

### 🔴 P1
- [ ] #15: Loading indicator sur sync button (bug UX critique)

### 🟡 P2
- [ ] #16: Add cancel button to dialogs
- [ ] #17: Refactor: extract FileListWidget

### 🔵 P3
- [ ] #25: Implement lazy loading (> 100 items)

### 🅿️ Parking Lot (vidé)
```

### Avantages

✅ Capture immédiate sans interrompre flow  
✅ Revue structurée hebdomadaire  
✅ Évite scope creep (pas d'implémentation immédiate)  
✅ Traçabilité (idées ne sont pas perdues)

---

## 📅 CHANGELOG Workflow

### Format Keep a Changelog

```markdown
# Changelog

Format basé sur [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).  
Versioning basé sur [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

<!-- Section active quotidienne — PAS de dates ici -->

### Added 🆕
- **User-facing headline** (max 80 chars, store-ready)
  - Technical details: implementation specifics
  - User benefit: why it matters
  - (commit abc1234, closes #5)

### Changed ✨
- **Behavior modification headline**
  - Technical: what changed internally
  - Impact: how it affects usage
  - (commit def5678)

### Fixed 🐛
- **Bug fix headline**
  - Technical: root cause + solution
  - Impact: what works now
  - (commit ghi9012, closes #3)

### Code Quality 🔧
- **Internal improvement headline**
  - Refactoring, performance, etc.
  - (commit jkl3456)

---

## [0.2.0] - 2026-01-15

<!-- Version figée au moment du release -->

[Copie de [Unreleased] au moment du tag]

---

## [0.1.0] - 2026-01-10

<!-- Version initiale -->
```

### Workflow Quotidien

**Lors de chaque commit** :

1. Compléter code + tests
2. **Ajouter entrée dans CHANGELOG [Unreleased]** :
   ```markdown
   ## [Unreleased]
   
   ### Fixed
   - **Token visibility security**
     - Technical: default to hidden, auto-hide when leaving settings
     - Impact: prevents accidental token exposure
     - (commit 7e4d2a1, closes #1)
   ```
3. Commit avec référence issue : `[app] fix: token visibility (closes #1)`

### Workflow Release

**Quand prêt pour release v0.2.0** :

1. Renommer `[Unreleased]` → `[0.2.0] - 2026-01-15`
2. Créer nouvelle section `[Unreleased]` vide
3. Tag Git : `git tag v0.2.0 -m "Release v0.2.0"`
4. Extraire headlines pour stores (voir VERSIONING_CHANGELOG.md)

### Règles Strictes

❌ **PAS de dates dans [Unreleased]** (ajoutées au release)  
✅ **Headlines user-facing** (pas "fixed bug" → "improved security")  
✅ **Technical details** en sous-points  
✅ **Commit SHA + issue #N** systématiquement  
✅ **Catégories** : Added, Changed, Fixed, Code Quality (pas Security/Deprecated sauf cas spéciaux)

---

## 🔄 Workflow 5 Étapes — Détail

### ÉTAPE 1 : Session Start

**Objectif** : Prioriser le travail

**Actions** :
1. Ouvrir `_docs/apps/[app]/APP.md`
2. Lire sections dans l'ordre :
   - 🚧 In Progress (quoi en cours ?)
   - 🔴 P1 (quoi ASAP ?)
   - 🅿️ Parking Lot (idées à trier ?)
3. **Décider** :
   - Continuer item In Progress existant ?
   - Prendre nouveau P1 ?
   - Trier Parking Lot (si vendredi) ?

**Output** : Issue #N choisie (ex : #5)

---

### ÉTAPE 2 : Branch Creation

**Objectif** : Isoler le travail + tracking

**Actions** :

1. **Créer branche** :
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feat/app-short-desc
   ```

2. **Move issue vers In Progress** dans APP.md :
   ```markdown
   ### 🔴 P1 — ASAP
   - [ ] #5: Add tooltips to file dialogs  ← SUPPRIMER

   ### 🚧 In Progress
   - [ ] #5: Add tooltips to file dialogs — branch: feat/github_notes-add-tooltips, started: 2026-01-11, ETA: 2026-01-12  ← AJOUTER
   ```

3. **Commit tracking** :
   ```bash
   git add _docs/apps/[app]/APP.md
   git commit -m "[app] chore: move #5 to In Progress"
   git push -u origin feat/app-short-desc
   ```

**Output** : Branche créée, issue trackée dans In Progress

---

### ÉTAPE 3 : Development

**Objectif** : Implémenter + capturer idées

**Actions** :

1. **Coder** dans `apps/[app]/lib/...`
2. **Tester** localement (hot reload)
3. **Commits réguliers** :
   ```bash
   git add .
   git commit -m "[app] feat: add tooltip to add file dialog"
   ```

4. **Idées spontanées** → Parking Lot :
   ```markdown
   ### 🅿️ Parking Lot
   - Idée pendant #5 : dialog pourrait avoir bouton cancel
   - Observation : loading indicator manque sur sync button
   ```

5. **Répéter** jusqu'à feature complète

**Output** : Code fonctionnel, idées capturées

---

### ÉTAPE 4 : Validation

**Objectif** : S'assurer de la qualité

**Actions** :

1. **flutter analyze** :
   ```bash
   cd apps/[app]
   flutter analyze
   ```
   → MUST be clean (0 errors)

2. **flutter test** (si tests existent) :
   ```bash
   flutter test
   ```
   → MUST pass

3. **Manual testing** : Tester sur device/emulator

**Output** : Code validé, tests OK

---

### ÉTAPE 5 : Documentation

**Objectif** : Tracer + communiquer

**Actions** :

1. **Move issue In Progress → Recently Done** dans APP.md :
   ```markdown
   ### 🚧 In Progress
   [vide]

   ### ✅ Recently Done
   - [x] #5: Add tooltips to file dialogs — Done 2026-01-11 (commit d8b2ac6)
   ```

2. **Update CHANGELOG [Unreleased]** :
   ```markdown
   ## [Unreleased]
   
   ### Added
   - **Help tooltips on file dialogs**
     - Technical: added (?) icon with explanatory tooltips
     - User benefit: clearer file path requirements
     - (commit d8b2ac6, closes #5)
   ```

3. **Proposer commit** :
   ```bash
   git add .
   git status  # Vérifier fichiers modifiés
   # Proposer : "✅ Changements prêts : [fichiers]. Commit avec message `[app] feat: add tooltips (closes #5)` ?"
   # ATTENDRE validation utilisateur
   ```

4. **Après validation** :
   ```bash
   git commit -m "[app] feat: add tooltips (closes #5)"
   git push origin feat/app-short-desc
   ```

5. **Merge et cleanup** :
   ```bash
   git checkout main
   git merge --no-ff feat/app-short-desc
   git push origin main
   git branch -d feat/app-short-desc
   git push origin --delete feat/app-short-desc
   ```

6. **Récupérer commit SHA** :
   ```bash
   git log -1 --pretty=format:"%h"
   # Output : d8b2ac6
   ```

7. **Mettre à jour APP.md avec SHA** (si pas fait step 1) :
   ```markdown
   - [x] #5: Add tooltips — Done 2026-01-11 (commit d8b2ac6)
   ```

**Output** : Changements mergés, docs à jour, SHA tracé

---

## 📊 Recently Done — Archivage

### Règles Strictes

**Max 15 items OU 2 semaines** dans Recently Done.

**Au-delà** :
1. Items les plus anciens → **supprimer de APP.md**
2. Vérifier présence dans **CHANGELOG [version]**
3. Si pas dans CHANGELOG → ajouter avant suppression

**Exemple** :

```markdown
### ✅ Recently Done (15 items max)

<!-- Supprimer items > 2 semaines -->

- [x] #14: Feature récente — Done 2026-01-11 (commit xyz)
- [x] #13: Feature récente — Done 2026-01-10 (commit abc)
...
- [x] #1: Feature ancienne — Done 2025-12-28 (commit old)  ← Supprimer si > 2 semaines

<!-- Items supprimés doivent être dans CHANGELOG [0.1.0] ou [Unreleased] -->
```

### Workflow Hebdomadaire

**1x par semaine** (ex : vendredi) :

1. Compter items Recently Done
2. Si > 15 OU items > 2 semaines :
   - Vérifier CHANGELOG [Unreleased] ou [version]
   - Supprimer anciens items de APP.md
3. Commit cleanup :
   ```bash
   git commit -m "[app] chore: archive old Recently Done items"
   ```

---

## 🎯 Exemples Concrets

### Exemple 1 : Bug Critique (P1 → Recently Done)

**Context** : App crash sur Android 12

**ÉTAPE 1 : Session Start**
```markdown
### 🔴 P1
- [ ] #1: Bug: App crash on Android 12 startup
```

**ÉTAPE 2 : Branch Creation**
```bash
git checkout -b fix/app-android12-crash
```

Update APP.md :
```markdown
### 🚧 In Progress
- [ ] #1: Bug: App crash on Android 12 startup — branch: fix/app-android12-crash, started: 2026-01-11, ETA: 2026-01-11
```

**ÉTAPE 3 : Development**
```dart
// Fix dans lib/main.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Fix Android 12
  runApp(MyApp());
}
```

Commits :
```bash
git commit -m "[app] fix: add ensureInitialized for Android 12 compat"
```

**ÉTAPE 4 : Validation**
```bash
flutter analyze  # 0 errors
flutter test     # All pass
# Test sur Android 12 device → OK
```

**ÉTAPE 5 : Documentation**

APP.md :
```markdown
### ✅ Recently Done
- [x] #1: Bug: App crash on Android 12 — Done 2026-01-11 (commit a1b2c3d)
```

CHANGELOG.md :
```markdown
## [Unreleased]

### Fixed
- **Android 12 startup crash resolved**
  - Technical: added WidgetsFlutterBinding.ensureInitialized()
  - Impact: app now works on Android 12+
  - (commit a1b2c3d, closes #1)
```

Commit final :
```bash
git commit -m "[app] fix: resolve Android 12 crash (closes #1)"
```

---

### Exemple 2 : Feature Nouvelle (P2 → In Progress → Recently Done)

**Context** : Ajouter export settings

**ÉTAPE 1 : Session Start**
```markdown
### 🟡 P2
- [ ] #10: Add export settings as JSON
```

**ÉTAPE 2 : Branch**
```bash
git checkout -b feat/app-export-settings
```

APP.md :
```markdown
### 🚧 In Progress
- [ ] #10: Add export settings — branch: feat/app-export-settings, started: 2026-01-11, ETA: 2026-01-13
```

**ÉTAPE 3 : Development**

Pendant dev, idée spontanée :
```markdown
### 🅿️ Parking Lot
- Import settings pourrait être symétrique (feature inverse)
```

Code + commits :
```bash
git commit -m "[app] feat: add export button in settings"
git commit -m "[app] feat: implement JSON serialization"
```

**ÉTAPE 4 : Validation**
```bash
flutter analyze  # OK
flutter test     # OK
# Test export → JSON valide
```

**ÉTAPE 5 : Documentation**

APP.md :
```markdown
### ✅ Recently Done
- [x] #10: Add export settings — Done 2026-01-13 (commit def5678)
```

CHANGELOG.md :
```markdown
## [Unreleased]

### Added
- **Export settings backup**
  - Technical: JSON export via Share sheet
  - User benefit: easy migration to new device
  - (commit def5678, closes #10)
```

Commit :
```bash
git commit -m "[app] feat: add settings export (closes #10)"
```

---

### Exemple 3 : Parking Lot Triage (Vendredi)

**Avant triage** :
```markdown
### 🅿️ Parking Lot
- Dialog add file pourrait avoir bouton cancel
- Loading indicator manque sur sync button
- Refactoring : extraire FileListWidget
- Performance : lazy loading grandes listes
- Idée : support multi-repo (futur majeur)
```

**Après revue** :

**Décisions** :
- Dialog cancel → P2 (amélioration UX)
- Loading indicator → P1 (bug UX, confusion utilisateur)
- FileListWidget → P2 (refactoring utile)
- Lazy loading → P3 (optimisation future)
- Multi-repo → P3 (feature majeure, pas prioritaire)

**Résultat** :
```markdown
### 🔴 P1
- [ ] #15: Add loading indicator on sync button

### 🟡 P2
- [ ] #16: Add cancel button to add file dialog
- [ ] #17: Refactor: extract FileListWidget

### 🔵 P3
- [ ] #25: Performance: lazy loading (> 100 items)
- [ ] #26: Feature: multi-repo support

### 🅿️ Parking Lot
[vide après triage]
```

Commit :
```bash
git commit -m "[app] chore: weekly parking lot triage"
```

---

## 🚫 Anti-Patterns à Éviter

❌ **Mélanger items Done et actifs dans P1/P2/P3**
→ ✅ Move vers Recently Done dès terminé

❌ **In Progress avec > 5 items**
→ ✅ Finir items en cours avant d'en prendre nouveaux

❌ **Parking Lot jamais trié (> 20 items)**
→ ✅ Trier chaque semaine

❌ **Recently Done sans SHA**
→ ✅ SHA OBLIGATOIRE (traçabilité)

❌ **Dates dans CHANGELOG [Unreleased]**
→ ✅ Pas de dates, ajoutées au release

❌ **Commits sans référence issue**
→ ✅ Toujours `(closes #N)` ou `(from issue #N)`

❌ **Sauter ÉTAPE 4 (validation)**
→ ✅ flutter analyze + tests OBLIGATOIRES

---

## 📚 Références

- **Versioning & Release** : [VERSIONING_CHANGELOG.md](VERSIONING_CHANGELOG.md)
- **Pre-commit checklist** : `_docs/PRE_COMMIT_CHECKLIST.md`
- **Branching conventions** : `_docs/BRANCHING.md`
- **Templates** : `_docs/templates/new-app/`

---

**Version** : 1.0  
**Date** : 2026-01-11  
**Maintainer** : @sedounet
