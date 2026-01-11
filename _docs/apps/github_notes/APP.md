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
- Commit SHA = 7 premiers chars (ex: abc1234)
- Date format = YYYY-MM-DD
- Recently Done = garder max 15 items ou 2 semaines
-->

### 🚧 In Progress (max 3-5 items actifs)

<!-- Items en cours de développement avec branche + ETA -->

_Aucun item en cours actuellement._

---

### 🔴 P1 — ASAP (bugs bloquants, débloqueurs techniques)

- [ ] #1: Token visibility default off in Settings; auto-hide when leaving token settings (from USER-NOTES 2026-01-11)
- [ ] #2: Investigate intermittent first-click Sync failure in editor (possible race condition) (from USER-NOTES 2026-01-11)

**⛔ Issues GitHub DÉSACTIVÉES** (feature verrouillée) :
<!-- NE PAS utiliser GitHub issues (GH#N) tant que feature non activée -->

---

### 🟡 P2 — Next release (prochaine version planifiée)

**Features demandées (USER-NOTES 2026-01-10)** :
- [ ] #10: Export settings (backup config as JSON via Share/clipboard)
- [ ] #11: Refactor Settings with foldable sections (ExpansionTile for GitHub Token, Files, Preferences)
- [ ] #12: Adjust SnackBar placement above action buttons (from USER-NOTES 2026-01-11)

**Conflict Resolution** :
- [ ] #13: Implement three-way merge option in ConflictDialog (add "Merge" choice alongside Keep Local/Remote)

**Code Quality** :
- [ ] #14: Extract dialog helpers (9x showDialog patterns remain)

---

### 🔵 P3 — Backlog (long terme, nice-to-have)

**v0.3 — Early Standards** (per APP_STANDARDS.md) :
- [ ] #20: Localization (i18n) — ARB files en/fr, externaliser strings
- [ ] #21: Analytics — service abstraction + events clés + opt-out UI
- [ ] #22: Ads Placeholder — widget banner 50-60dp + feature flag

**v0.4 — Auto-sync & Conflict UX** :
- [ ] #30: Auto-sync optionnel (toggle + interval)
- [ ] #31: Background sync service (WorkManager)
- [ ] #32: Conflict resolution UI améliorée (diff view)
- [ ] #33: Historique versions locales (rollback)

**v0.5 — OAuth & Multi-compte** :
- [ ] #40: OAuth GitHub flow (remplace PAT)
- [ ] #41: Stockage tokens par compte
- [ ] #42: Account switcher UI
- [ ] #43: Support orgas GitHub

**v1.0 — Release Publique** :
- [ ] #50: Tests complets (>80% coverage) + CI/CD
- [ ] #51: Privacy policy + Terms
- [ ] #52: Store listings (screenshots, descriptions)
- [ ] #53: Analytics opérationnelles + Ads SDK

**Autres (optionnel)** :
- [ ] #60: Preview markdown avancé (flutter_markdown renderer)
- [ ] #61: Édition collaborative (notif si autre commit)
- [ ] #62: Export local (.md file)
- [ ] #63: Widget home screen (quick add note)
- [ ] #64: Search/filter fichiers
- [ ] #65: Tags/labels pour organisation

---

### ✅ Recently Done (last 15 items or 2 weeks)

<!-- Format: [x] #N: Description — Done YYYY-MM-DD (commit SHA7CHAR) -->

- [x] #15: Simplify GitHub error messages (404 → concise text) — Done 2026-01-11 (commit unknown)
- [x] #14: Offline tracked-file creation fallback — Done 2026-01-11 (commit unknown)
- [x] #13: Device release smoke tests (create/edit/sync/conflict/offline) — Done 2026-01-11 (commit unknown)
- [x] #12: Use githubServiceProvider consistently (replace 3x direct) — Done 2026-01-10 (commit unknown)
- [x] #11: AutoSaveMixin extraction (Phase 3 Atomization) — Done 2026-01-10 (commit 63a8032)
- [x] #10: ProjectFileService extraction (Phase 2 Refactoring) — Done 2026-01-10 (commit 773fda1)
- [x] #9: SyncService extraction (Phase 1 Atomization) — Done 2026-01-10 (commit d6c7ef6)
- [x] #8: Replace inline tooltips/AlertDialog patterns in settings_screen — Done 2026-01-10 (commit 92ce174)
- [x] #7: Extract FieldHelpButton widget + SnackHelper utility — Done 2026-01-10 (commit 7ff8f7b)
- [x] #6: Fix SnackBar colors (use DotlynColors.error) — Done 2026-01-10 (commit 7ff8f7b)
- [x] #5: Replace tooltip widgets with tap-to-open bottom sheets — Done 2026-01-10 (commit d8b2ac6)
- [x] #4: Fix sync offline error message (SocketException handling) — Done 2026-01-10 (commit unknown)
- [x] #3: Fix splash Android 12+ (add android_12 config) — Done 2026-01-10 (commit unknown)
- [x] #2: Fix theme persistence (themeModeProvider + secure storage) — Done 2026-01-10 (commit unknown)
- [x] #1: Fix token GitHub release build (INTERNET permission + sanitization) — Done 2026-01-10 (commit unknown)

---

<details>
<summary><strong>📦 Pre-Workflow Archive (items avant 2026-01-11)</strong></summary>

<!-- Items complétés avant l'adoption du nouveau workflow (tag: Pre-Workflow) -->

**Release v0.1 MVP Checklist** :
- [x] Device smoke test (`flutter run --release`) — Done 2026-01-10
  - Token invalid/sanitize : ✅
  - Sync bidirectionnel : ✅
  - Multiple files : ✅
  - Conflict detection : ✅
  - Offline sync error message : ✅ (red SnackBar via SnackHelper)
  - Verify Add File dialog tooltips/placeholders : ✅ (tap-to-open bottom sheets)
- [x] Fix analyzer warnings — zero issues ✅
- [x] Version in pubspec.yaml — 0.1.0 ✅
- [x] CHANGELOG.md updated — done ✅
- [x] Icons & splash screen (adaptive icons + android_12 config) — verified API 30/35 ✅
- [x] Token release fix (INTERNET permission + sanitization) — Done 2026-01-10 ✅
- [x] Theme persistence fix (themeModeProvider + secure storage) — Done 2026-01-10 ✅
- [x] Confirmer Fix bug P1 sync offline (message erreur) — Done 2026-01-10 ✅

**Backend v0.1** :
- [x] Models: `ProjectFile`, `FileContent`, `SyncStatus`
- [x] Drift schema: tables + migrations
- [x] GitHub API service: `fetchFile()`, `updateFile()`, `testToken()`
- [x] Providers: `projectFilesProvider`, `fileContentProvider`, `githubServiceProvider`
- [x] Secure storage: token storage via `flutter_secure_storage`

**UI v0.1** :
- [x] Screen: Files list (home)
- [x] Screen: File editor (scrollbar + markdown help)
- [x] Screen: Settings (GitHub token + add/remove/edit files)
- [x] Widget: FileCard extracted → `lib/widgets/file_card.dart` (status badge + popup menu duplicate)
- [x] Settings: use `ProjectFileForm` for Add/Edit; theme & language pickers added

**Note** : App mobile uniquement (Android/iOS). Pas de support web/desktop.

</details>

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
