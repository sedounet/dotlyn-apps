# GitHub Notes — APP.md

**Status** : 🟢 v0.1 MVP (stable, release ready)  
**Version actuelle** : v0.1.0  
**Dernière update** : 2026-01-17  
**Statut Code Quality** : Refactor code cleanup en cours (branch: refactor/github_notes-code-cleanup)

---

## 📋 Vision

App de prise de notes GitHub-sync pour faciliter le workflow de développement avec VS Code IA.

**Objectif** : Accès rapide depuis mobile aux fichiers markdown de travail (APP.md, PROMPT_USER.md, etc.) avec édition offline et sync GitHub.

**Public** : Développeurs utilisant IA (Copilot, Claude, etc.) pour documenter leurs workflows.

---

## ✅ v0.1.0 MVP — Release-Ready

**Fonctionnalités complétées** :
- ✅ Configuration fichiers trackés (owner/repo/path/nickname)
- ✅ Liste fichiers + status badges (Local/Synced/Modified)
- ✅ Éditeur markdown avec auto-save (debounce 2s)
- ✅ Sync manuelle GitHub (SHA conflict detection)
- ✅ Token GitHub (secure storage, sanitization)
- ✅ Dark theme (system-aware)
- ✅ Offline support (local first, clear error messages)
- ✅ i18n (en/fr) — COMPLETED 2026-01-17
- ✅ UI polish (FileCard date formatting, CardMenu widget)
- ✅ Code quality refactoring (imports, pattern matching, FormFieldRow)

**Stack Tech** :
- State: Riverpod (Provider, StreamProvider, FutureProvider, NotifierProvider)
- DB: Drift (project_files, file_contents, app_settings tables)
- API: GitHub REST API (GET/PUT /repos/{owner}/{repo}/contents/{path})
- UI: dotlyn_ui (DotlynColors, DotlynTheme) + Material Icons
- Security: flutter_secure_storage, token sanitization
- Platform: Android/iOS only

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
- [ ] #34: Add CardMenu widget & unify file card menus — branch: refactor/github_notes-code-cleanup, started: 2026-01-17, ETA: 2026-01-17

---

### 🔴 P1 — ASAP (Critical bugs only)

(empty — v0.1.0 stable)

---


### 🟡 P2 — Next Version (v0.2)

**Code Quality & Refactoring** :
- [ ] #11: Refactor Settings avec ExpansionTile pour sections foldables (GitHub Auth, Tracked Files, Preferences)
- [ ] #13: Three-way merge option dans ConflictDialog (actuellement Keep Local/Keep Remote seulement)
- [ ] #14: Extract dialog helpers (9x showDialog patterns en duplication dans settings_screen)
- [ ] #26: UI: Unifier menu fichier Settings avec menu home (CardMenu refactor pour TrackedFilesScreen)

**UX Improvements** :
- [ ] #10: Export settings (JSON backup via Share/clipboard)
- [ ] #30: Auto-sync optionnel (toggle + interval configurable)

**Standards (per APP_STANDARDS.md)** :
- [ ] #20: Analytics service abstraction + core events + opt-out UI
- [ ] #21: Ads placeholder widget (banner 60dp + feature flag)


---

### 🔵 P3 — Future Versions (v0.3+)

- [ ] #31: Background sync service (WorkManager)
- [ ] #32: Conflict resolution UI avancée (diff view)
- [ ] #33: Historique versions locales (rollback)
- [ ] #40: OAuth GitHub flow (remplace PAT)
- [ ] #41: Multi-account support

---

### ✅ Recently Done (last 15 items or 2 weeks)

<!-- Format: [x] #N: Description — Done YYYY-MM-DD (commit SHA7CHAR) -->

- [x] #34: Code refactor (imports, pattern matching, FormFieldRow widget) — Done 2026-01-17 (commit 836ad85)
- [x] #12: Localization (i18n en/fr) — Done 2026-01-17 (commit fe0bb2f)
- [x] #29: UI — Move last sync date to right of file path; increase font 10%; improve colors — Done 2026-01-17 (commit abd7382)
- [x] #25: Afficher date de dernière sync sur carte fichier (format relatif) — Done 2026-01-17 (commit abd7382)
- [x] #18: Fix save button Settings — Done 2026-01-17 (commit abd7382)
- [x] #27: Smart file duplication with intelligent alias suggestion — Done 2026-01-17 (commit 3b1e4a2)
- [x] #28: Duplication GitHub — Prevent duplicate (same owner/repo/path) — Done 2026-01-17 (commit cfa7fd0)
- [x] #19: Harmonised conflict menu + duplicate prevention + status badges — Done 2026-01-17 (commit 6b5c308)
- [x] #15: Token visibility default OFF; auto-hide on exiting Settings — Done 2026-01-11 (commit a0831b6)
- [x] #16: Fix first-click Sync race condition — Done 2026-01-11 (commit a0831b6)
- [x] #17: Floating SnackBar above bottom action buttons — Done 2026-01-11 (commit a0831b6)
- [x] #1-9: Token fix, Theme persistence, Android 12+, Offline handling, FieldHelpButton, SnackHelper — Done 2026-01-10 (commits d8b2ac6 onwards)

## 📚 Quickstart

### Setup
```bash
cd apps/github_notes
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Test Flow
1. Settings → Paste GitHub token (repo scope) → Save & Test
2. Files → Add tracked file (owner/repo/path/nickname)
3. Open file → edit → auto-save (2s debounce)
4. Sync button → push to GitHub
5. Verify on GitHub → file updated

### Debug
- `flutter analyze` — fix before commit
- `flutter test` — all tests pass
- Settings → Show token (debug mode only)

---

## 🔗 Links

- [PITCH.md](PITCH.md) — Vision & positioning
- [CHANGELOG.md](../../../apps/github_notes/CHANGELOG.md) — Version history
- [USER-NOTES.md](USER-NOTES.md) — Personal notes (read-only)
- [REFACTOR_CODE_CLEANUP.md](REFACTOR_CODE_CLEANUP.md) — Code quality refactor details

---

**Last Update**: 2026-01-17  
**Maintainer**: @sedounet  
**Status**: v0.1.0 Ready for Release + Device Testing
