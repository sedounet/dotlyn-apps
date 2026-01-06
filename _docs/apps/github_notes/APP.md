# GitHub Notes — Documentation

**Status** : 🚧 En développement  
**Version actuelle** : v0.1 MVP  
**Dernière update** : 2026-01-03  
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

### 🔴 P1 — MVP v0.1 (Finalisation)

**Refactors (Completed for v0.1)**
- [x] **Extract form widget** — `lib/widgets/project_file_form.dart` (ProjectFileForm)
  - Description: Reusable Add/Edit form with validation for `owner`, `repo`, `path`, `nickname`.
  - Tests: `test/widgets/project_file_form_test.dart` (validation + successful submit) — **passed**.
  - Branch: `feat/githubnotes-refactor-form` — **merged (2026-01-03)**

**Release Checklist** :
- [x] Device smoke test (`flutter run --release` on Android/iOS) — **passed on Android device A015** ✅
- [x] Fix analyzer warnings — **zero issues** ✅
- [x] Version in pubspec.yaml — **0.1.0** ✅
- [x] CHANGELOG.md updated — **done** ✅
- [x] Icons & splash screen generated (adaptive icons) — **done (2026-01-03)** ✅
- [ ] GitHub label `github_notes` created

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
- [ ] GitHub label `github_notes`

**Note** : App mobile uniquement (Android/iOS). Pas de support web/desktop.

### 🟡 P2 — Améliorations légères v0.2

**Code Quality & Refactors** :
- [ ] Extract GitHub file check service (lightweight) — `lib/services/file_check_service.dart`
  - Goal: Testable wrapper for file existence check (200/404/401/5xx/network)
  - Branch: `feat/githubnotes-filecheck-service`
- [ ] ProjectFilesNotifier (Riverpod Notifier) — `lib/providers/project_files_notifier.dart`
  - Goal: Move DB operations out of widgets into a Notifier with unit tests
  - Branch: `feat/githubnotes-notifier`

**Localization & UI** :
- [ ] Localization (i18n) : ARB files en/fr (per APP_STANDARDS.md)
- [ ] Theme switcher + language picker (settings screen)
- [ ] UI tweaks : edit/delete icons visibility
- [ ] Help tooltips (?) sur Add File dialog
- [ ] Remove unused imports / fix analyzer warnings (settings_screen.dart)

### 🔵 P3 — Futur (optionnel, complexe)

- [ ] Background sync (chaque 15min si connecté)
- [ ] Bidirectional sync (pull/push/merge conflict resolution UI)
- [ ] Historique versions locales (rollback)
- [ ] Preview markdown avancé (flutter_markdown renderer)
- [ ] OAuth GitHub flow complet
- [ ] Support multi-comptes GitHub
- [ ] Édition collaborative (notif si autre commit)
- [ ] Export local (.md file)

---

## 🔗 Liens

- PITCH.md : [`PITCH.md`](PITCH.md)
- USER-NOTES.md : [`USER-NOTES.md`](USER-NOTES.md)
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
