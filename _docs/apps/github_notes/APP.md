# GitHub Notes — Documentation

**Status** : 🚧 En développement  
**Version actuelle** : v0.1 MVP (stable)  
**Dernière update** : 2026-01-10  
**Roadmap** : Voir section TODO pour le plan détaillé des versions

---

## 📋 Vision

App de prise de notes GitHub-sync pour faciliter le workflow de développement avec VS Code IA.

**Objectif** : Accès rapide depuis mobile aux fichiers markdown de travail (PROMPT_USER.md, APP.md) avec édition offline et sync GitHub.

---

## 🎯 Versions

### v0.1 MVP — Fonctionnalités de base

**Fonctionnalités complétées** :
- ✅ Configuration de fichiers trackés (owner/repo/path/nickname)
- ✅ Liste des fichiers configurés (card avec status badge)
- ✅ Éditeur markdown (TextField multiline + scrollbar)
- ✅ Sauvegarde locale automatique (debounce 2s)
- ✅ Sync manuelle vers GitHub (bouton Sync + SHA conflict detection)
- ✅ Auth GitHub via Personal Access Token (secure storage)
- ✅ Dark theme support (system)
- ✅ Markdown quick help (bouton aide)
- ✅ Duplicate file flow (popup menu + prefilled dialog + existence check)
- ✅ SafeArea + responsive design

**Specs techniques** :
- **State** : Riverpod (Provider, StreamProvider, FutureProvider)
- **DB** : Drift (tables: `project_files`, `file_contents`, `app_settings`)
- **API** : GitHub REST API (`GET/PUT /repos/{owner}/{repo}/contents/{path}`)
- **UI** : dotlyn_ui theme + Material Icons
- **Security** : flutter_secure_storage pour GitHub token

**Non inclus v0.1** :
- ❌ Localization (i18n) — v0.2
- ❌ Background sync automatique — optionnel
- ❌ Preview markdown avancé (rendu HTML) — optionnel
- ❌ OAuth GitHub (seulement token manuel)
- ❌ Bidirectional sync (pull/push/merge) — optionnel

---

## 📝 TODO

<!-- 
RÈGLES :
- Issues locales = #N (numéro séquentiel, pas GitHub)
- Commit SHA = 7 premiers chars obligatoire dans Recently Done
- Date format = YYYY-MM-DD
- Recently Done = garder max 15 items ou 2 semaines
-->

### 🚧 In Progress (max 3-5 items actifs)

_Aucun item en cours (app stable v0.1)._

---

### 🔴 P1 — ASAP (Post-release fixes)

_Aucun bug bloquant pour l'instant._

---

### 🟡 P2 — Prochaine version (v0.2)

- [ ] #10: Export settings (backup config JSON via Share/clipboard)
- [ ] #11: Refactor Settings avec ExpansionTile pour sections foldables
- [ ] #12: Localization (i18n) — ARB files en/fr (APP_STANDARDS.md)
- [ ] #13: Three-way merge option dans ConflictDialog (actuellement Keep Local/Keep Remote seulement)
- [ ] #14: Extract dialog helpers (9x showDialog patterns en duplication)

---

### 🔵 P3 — Versions futures

**v0.3 — Standards & Polish** :
- [ ] #20: Analytics service abstraction + events clés + opt-out UI
- [ ] #21: Ads placeholder widget (banner 50-60dp + feature flag)

**v0.4 — Auto-sync & Conflict UX** :
- [ ] #30: Auto-sync optionnel (toggle + interval)
- [ ] #31: Background sync service (WorkManager)
- [ ] #32: Conflict resolution UI avancée (diff view)
- [ ] #33: Historique versions locales (rollback)

**v0.5 — OAuth & Multi-compte** :
- [ ] #40: OAuth GitHub flow (remplace PAT)
- [ ] #41: Stockage tokens par compte GitHub

---

### ✅ Recently Done (last 15 items or 2 weeks)

<!-- Format: [x] #N: Description — Done YYYY-MM-DD (commit SHA7CHAR) -->

- [x] #15: Token visibility default OFF; auto-hide on exiting Settings — Done 2026-01-11 (commit a0831b6)
- [x] #16: Fix first-click Sync race (wait token + single retry) — Done 2026-01-11 (commit a0831b6)
- [x] #17: Floating SnackBar above bottom action buttons — Done 2026-01-11 (commit a0831b6)


- [x] #1: Token GitHub release fix (INTERNET permission + sanitization) — Done 2026-01-10 (commit 92ce174)
- [x] #2: Theme persistence (themeModeProvider + secure storage) — Done 2026-01-10 (commit 92ce174)
- [x] #3: Android 12+ splash config (android_12 section) — Done 2026-01-10 (commit 92ce174)
- [x] #4: Sync offline error handling (SocketException → SnackBar) — Done 2026-01-10 (commit 92ce174)
- [x] #5: Field help tooltips → bottom sheets (FieldHelpButton widget) — Done 2026-01-10 (commit d8b2ac6)
- [x] #6: SnackBar colors conformes styleguide (SnackHelper utility) — Done 2026-01-10 (commit 7ff8f7b)
- [x] #7: Extract reusable FieldHelpButton widget — Done 2026-01-10 (commit 7ff8f7b)
- [x] #8: Atomization Phase 1 (SyncService, TokenService, dialogs) — Done 2026-01-10 (commit d6c7ef6)
- [x] #9: Atomization Phase 2 (ProjectFileService refactor) — Done 2026-01-10 (commit 773fda1)
- [x] #10: Atomization Phase 3 (AutoSaveMixin extraction) — Done 2026-01-10 (commit 63a8032)

**Items pré-workflow (pre-2026-01-10)** :
- FileCard extracted widget
- Settings theme & language pickers
- ProjectFileForm widget + tests
- Device smoke test release build

---

## 🔗 Liens

- PITCH.md : [`PITCH.md`](PITCH.md)
- CHANGELOG.md : [`../../../apps/github_notes/CHANGELOG.md`](../../../apps/github_notes/CHANGELOG.md)
- USER-NOTES.md : [`USER-NOTES.md`](USER-NOTES.md) (lecture seule — notes perso)

---

## 📌 Notes Techniques

### GitHub API
- **Rate limit** : 60 req/h sans auth, 5000 req/h avec token
- **Token scope requis** : `repo` (privé) ou `public_repo` (public seulement)
- **SHA verification** : GitHub retourne SHA du fichier, stocker pour détecter conflits
- **Offline strategy** : Cache local first, sync arrière-plan

### Stack Technique
- **State** : Riverpod (Provider, StreamProvider, FutureProvider)
- **DB** : Drift (tables: `project_files`, `file_contents`, `app_settings`)
- **API** : GitHub REST API (`GET/PUT /repos/{owner}/{repo}/contents/{path}`)
- **UI** : dotlyn_ui theme + Material Icons
- **Security** : flutter_secure_storage pour GitHub token
- **Platform** : Mobile uniquement (Android/iOS)

---

**Version** : 2.0  
**Dernière mise à jour** : 2026-01-11  
**Maintainer** : @sedounet

  - Cause : manque permission `INTERNET` dans AndroidManifest.xml
  - Fix : ajout permission + sanitization token (trim, enlever invisible chars)
  - Status : ✅ Validé sur device physique
  
- [x] **FIX**: Theme switch ne persistait pas
  - Cause : pas de provider pour theme mode
  - Fix : `themeModeProvider` + FlutterSecureStorage persistence
  - Status : ✅ Theme persiste après redémarrage
  
- [x] **FIX**: Splash Android 12+ affichait icône au lieu du logo
  - Cause : manque config `android_12` dans flutter_native_splash
  - Fix : ajout section android_12 dans pubspec.yaml
  - Status : ✅ Vérifié API 30/35

**Bugs résolus (workflow offline)** :
- [x] **FIX**: Sync offline pas de message d'erreur — **Done 2026-01-10**
  - Fix : Gestion SocketException avec message clair "Offline: Cannot sync to GitHub. File saved locally."
  - Fix : Suppression vérification GitHub lors création fichier (permet création offline)
  - Fix : Save Local toujours actif (pas de désactivation auto après auto-save)
  - Status : ✅ Workflow offline complet fonctionnel

**UX Improvements (complétés)** :
- [x] **FIX**: Field help tooltips remplacées par tap-to-open bottom sheets
  - Cause : Tooltip widget peu fiable sur mobile
  - Fix : `FieldHelpButton` widget (IconButton → showModalBottomSheet)
  - Status : ✅ Implemented in Add File dialog for Owner/Repository/File Path/Nickname fields
  
- [x] **FIX**: SnackBar colors non-conformes au styleguide
  - Cause : hardcoded Colors.red au lieu de DotlynColors.error
  - Fix : création `SnackHelper` utility class + remplacement 15+ call sites
  - Status : ✅ Integrated across file_editor_screen & settings_screen

- [x] **REFACTOR**: Extract reusable FieldHelpButton widget & centralize SnackBar styling
  - Cause : code duplication (IconButton + showModalBottomSheet pattern 4x)
  - Fix : `FieldHelpButton` widget + `SnackHelper` utility (3 static methods: showInfo/showSuccess/showError)
  - Status : ✅ Implemented, all usages replaced (commit 92ce174)

- [x] **REFACTOR**: Replace inline tooltips and AlertDialog patterns in `settings_screen.dart` with `FieldHelpButton`, `DialogHelpers` and `SnackHelper`.
  - Done: 2026-01-10 — commit 92ce174

**Release Checklist** :
- [x] Device smoke test (`flutter run --release`) — **Done 2026-01-10** ✅
  - Token invalid/sanitize : ✅
  - Sync bidirectionnel : ✅
  - Multiple files : ✅
  - Conflict detection : ✅
  - Offline sync error message: verify ywhen device is offline that attempting to Snc shows a clear network error (SnackBar) — **Done 2026-01-10** ✅ (red SnackBar via SnackHelper)
  - Verify Add File dialog: tooltips/placeholders in Owner/Repository/File Path/Nickname fields — **Done 2026-01-10** ✅ (tap-to-open bottom sheets)
- [x] Fix analyzer warnings — **zero issues** ✅
- [x] Version in pubspec.yaml — **0.1.0** ✅
- [x] CHANGELOG.md updated — **done** ✅
- [x] Icons & splash screen (adaptive icons + android_12 config) — **verified API 30/35** ✅
- [x] Token release fix (INTERNET permission + sanitization) — **Done 2026-01-10** ✅
- [x] Theme persistence fix (themeModeProvider + secure storage) — **Done 2026-01-10** ✅
- [x] Confirmer Fix bug P1 sync offline (message erreur) avant release publique (inclut vérification des tooltips/placeholders) — **Done 2026-01-10** ✅

**Backend** :
- [x] Models: `ProjectFile`, `FileContent`, `SyncStatus`
- [x] Drift schema: tables + migrations
- [x] GitHub API service: `fetchFile()`, `updateFile()`, `testToken()`
- [x] Providers: `projectFilesProvider`, `fileContentProvider`, `githubServiceProvider`
- [x] Secure storage: token storage via `flutter_secure_storage`

**UI** :
- [x] Screen: Files list (home)
- [x] Screen: File editor (scrollbar + markdown help)
- [x] Screen: Settings (GitHub token + add/remove/edit files)
- [x] Widget: FileCard extracted → `lib/widgets/file_card.dart` (status badge + popup menu duplicate)
- [x] Settings: use `ProjectFileForm` for Add/Edit; theme & language pickers added

**Release / housekeeping** :
- [ ] Device smoke test (`flutter run --release`)

**Note** : App mobile uniquement (Android/iOS). Pas de support web/desktop.

### 🟡 P2 — Améliorations UX & Code Quality

**Features demandées (USER-NOTES 2026-01-10)** :
- [ ] **Export settings** (backup config)
  - Description : JSON exportable via Share/clipboard
  - Contenu : Liste fichiers + token (optionnel)
  - Cas usage : Réinstall app, multi-device
  
- [ ] **Refactor Settings : sections foldables**
  - ExpansionTile pour : GitHub Token, Fichiers Suivis, Préférences
  - Bouton "Afficher token" → icône œil dans TextField
  - Justification : Settings devient long

**Localization & UI** :
- [ ] Localization (i18n) : ARB files en/fr (per APP_STANDARDS.md)
- [x] Help tooltips (?) sur Add File dialog — **Done 2026-01-10** (commit d8b2ac6)

**Conflict Resolution** :
- [ ] **Implement merge option** (three-way merge)
  - Description : Ajouter choix "Merge" dans ConflictDialog (actuellement Keep Local / Keep Remote / Cancel)
  - Justification : Utilisateur veut combiner changements locaux + remote sans écraser
  - Spec : diff3 algorithm ou merge manuel (UI interactive)
  - Priority : P2 (nice-to-have pour workflow avancé)

**Code Quality & Refactors** :
- [x] Extract reusable FieldHelpButton widget — **Done 2026-01-10** (commit 7ff8f7b)
- [x] Centralize SnackBar styling via SnackHelper utility — **Done 2026-01-10** (commit 7ff8f7b)
- [x] **Atomization Phase 1**: Extract SyncService, TokenService, dialogs — **Done 2026-01-10** (commit d6c7ef6)
- [x] **Atomization Phase 2**: Extract ProjectFileService, refactor settings — **Done 2026-01-10** (commit 773fda1)
- [x] **Atomization Phase 3**: Extract AutoSaveMixin — **Done 2026-01-10** (commit 63a8032)
- [x] Simplify GitHub error messages (404 → concise user-facing text) — **Done 2026-01-11**
- [x] Offline tracked-file creation fallback (add locally on network error) — **Done 2026-01-11**
- [x] Device release smoke tests (create/edit/sync/conflict/offline) — **Done 2026-01-11** ✅
- [x] Use githubServiceProvider consistently (replace 3x direct instantiation) — **Done 2026-01-10** (commit NEW)
- [x] **PHASE 1 ATOMIZATION** (2026-01-10, commit d6c7ef6) :
  - Extracted `SyncService` class (210 → 80 line reduction in file_editor_screen._syncToGitHub)
  - Created sealed class `SyncResult` with pattern matching (.when() extension)
  - Created `TokenService` for centralized token management
  - Created reusable dialogs: `ConfigDialog`, `ConflictDialog`
  - Created Riverpod providers: `syncServiceProvider`, `tokenServiceProvider`
  - Refactored file_editor_screen to use SyncService (60% LOC reduction, much cleaner)
  - Test status: flutter analyze 0 errors, 5 info-level warnings only
- [x] **PHASE 2 REFACTORING** (2026-01-10, commit 773fda1) :
  - Extracted `ProjectFileService` class (centralized file CRUD)
  - Refactored `settings_screen.dart` to use ProjectFileService (618 → ~500 lines)
  - Removed duplicate `secureStorageProvider` (fixed imports)
  - All file operations now use service layer instead of inline DB calls
- [x] **PHASE 3 EXTRACTION** (2026-01-10, commit 63a8032) :
  - Created `AutoSaveMixin` for reusable auto-save behavior with debounce
  - Integrated mixin into file_editor_screen (reduced auto-save boilerplate by 40%)
  - Simplified timer/callback management with `scheduleAutoSave()`, `saveNow()`, `cancelAutoSave()` methods
  - All phases compile clean: 0 errors, 5 info warnings only
- [ ] Extract dialog helpers (9x showDialog patterns)

### 🔵 P3 — Futur (roadmap long terme)

**v0.3 — Early Standards** (prioritaire, voir APP_STANDARDS.md) :
- [ ] **Localization (i18n)** : ARB files en/fr, externaliser strings
- [ ] **Analytics** : service abstraction + events clés + opt-out UI
- [ ] **Ads Placeholder** : widget banner 50-60dp + feature flag

**v0.4 — Auto-sync & Conflict UX** :
- [ ] Auto-sync optionnel (toggle + interval)
- [ ] Background sync service (WorkManager)
- [ ] Conflict resolution UI améliorée (diff view)
- [ ] Historique versions locales (rollback)

**v0.5 — OAuth & Multi-compte** :
- [ ] OAuth GitHub flow (remplace PAT)
- [ ] Stockage tokens par compte
- [ ] Account switcher UI
- [ ] Support orgas GitHub

**v1.0 — Release Publique** :
- [ ] Tests complets (>80% coverage) + CI/CD
- [ ] Privacy policy + Terms
- [ ] Store listings (screenshots, descriptions)
- [ ] Analytics opérationnelles + Ads SDK

**Autres (optionnel)** :
- [ ] Preview markdown avancé (flutter_markdown renderer)
- [ ] Édition collaborative (notif si autre commit)
- [ ] Export local (.md file)
- [ ] Widget home screen (quick add note)
- [ ] Search/filter fichiers
- [ ] Tags/labels pour organisation

---

## 🔗 Liens

- PITCH.md : [`PITCH.md`](PITCH.md)
- USER-NOTES.md : [`USER-NOTES.md`](USER-NOTES.md) (lecture seule — notes perso extraites vers TODO)
- Repo GitHub : `dotlyn-apps/apps/github_notes`

---

## 📌 Notes techniques

- **GitHub API rate limit** : 60 req/h sans auth, 5000 req/h avec token
- **Token scope requis** : `repo` (accès privé) ou `public_repo` (public seulement)
- **SHA verification** : GitHub retourne SHA du fichier, stocker en local pour détecter conflits
- **Offline strategy** : Toujours charger cache local d'abord, sync en arrière-plan
- **Error handling** : Toast pour erreurs réseau, dialog pour conflits

---

## Configuration / Quickstart

### Prérequis
- Flutter (version compatible avec le monorepo)
- Melos installé si vous utilisez le monorepo
- Un compte GitHub avec droits pour créer / modifier un repo de test

### 1) Bootstrap & dépendances
Depuis la racine du monorepo :

```bash
melos bootstrap
```

Puis, pour travailler sur l'app :

```bash
cd apps/github_notes
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2) Générer un token GitHub
1. Ouvrez GitHub → Settings → Developer settings → Personal access tokens
2. Créez un token (classic) avec scope `repo`
3. Copiez le token — **NE PAS** le committer

### 3) Injecter le token
- Lancez l'app : `flutter run`
- Ouvrez Settings → collez le token → Save Token
- Test Token pour vérifier

### 4) Vérifier l'horloge de l'émulateur
Si erreurs TLS ou token refusé, vérifiez l'horloge de l'émulateur :

```bash
adb shell date $(date +%m%d%H%M%Y)
```

### 5) Tester le flux complet
1. Settings → Collez token → Save → Test
2. Files → Add file (owner/repo/path)
3. Ouvrez le fichier → modifiez → auto-save
4. Sync GitHub (bouton Sync dans l'éditeur)
5. En conflit : `Fetch remote` pour récupérer la version distante

### 6) Débogage
- Logs : `flutter run` pour voir la sortie
- Token (debug) : Settings → `Show token (debug)`
- Analyzer : `flutter analyze` (fix warnings avant commit)

---

## Notes & Liens
- Styleguide : [`_docs/dotlyn/STYLEGUIDE.md`](../../dotlyn/STYLEGUIDE.md)
- Checklist avant commit : `flutter analyze`, update `APP.md` si nécessaire
