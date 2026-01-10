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

### 🔴 P1 — Bugs bloquants & Release v0.1

**Fixes récents (2026-01-08 → 01-10)** :
- [x] **FIX**: Token GitHub ne fonctionnait pas en release build
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

**Bugs restants (à investiguer)** :
- [ ] **BUG**: Sync offline pas de message d'erreur
  - Symptôme : Mode avion, edit fichier, sync → aucun message, statut reste "modified"
  - Attendu : Toast "No network" ou "Sync failed"
  - Impact : UX confus, utilisateur ne comprend pas
  - Fix : try-catch dans file_editor_screen.dart + gestion SocketException

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
  - Status : ✅ Implemented, all usages replaced

**Release Checklist** :
- [x] Device smoke test (`flutter run --release`) — **Done 2026-01-10** ✅
  - Token invalid/sanitize : ✅
  - Sync bidirectionnel : ✅
  - Multiple files : ✅
  - Conflict detection : ✅
  - Offline sync error message: verify when device is offline that attempting to Sync shows a clear network error (SnackBar) — **Done 2026-01-10** ✅ (red SnackBar via SnackHelper)
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

**Code Quality & Refactors** :
- [x] Extract reusable FieldHelpButton widget — **Done 2026-01-10** (commit 7ff8f7b)
- [x] Centralize SnackBar styling via SnackHelper utility — **Done 2026-01-10** (commit 7ff8f7b)
- [x] Use githubServiceProvider consistently (replace 3x direct instantiation) — **Done 2026-01-10** (commit NEW)
- [ ] Extract dialog helpers (9x showDialog patterns)
- [ ] Extract GitHub file check service (lightweight)
- [ ] ProjectFilesNotifier (Riverpod Notifier) pour DB operations

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
