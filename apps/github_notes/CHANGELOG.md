# Changelog — GitHub Notes

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

<!-- 
Section active — ajout quotidien au fil des commits
Format: headline user-facing + technical + benefit + commit SHA
À renommer en [0.2.0] lors release
-->

### Added 🆕
_Aucune nouvelle feature pour l'instant._

### Changed ✨
_Aucun changement comportemental pour l'instant._

### Fixed 🐛
_Aucun fix en cours pour l'instant._

---

## [0.1.0] - 2026-01-10

<!-- MVP Release — Version figée -->

### Added 🆕
- **Offline editing support**
  - Technical: Create/edit files without network, sync later when online; local-first with Drift cache
  - User benefit: Work anywhere, sync when you have connectivity
  - (commit d8b2ac6)

- **GitHub file tracking**
  - Technical: Configure tracked files (owner/repo/path/nickname) with secure token storage (flutter_secure_storage)
  - User benefit: Quick access to your dev markdown files from mobile
  - (commit d8b2ac6)

- **Conflict detection & resolution**
  - Technical: Pre-sync SHA comparison with conflict dialog (Fetch remote / Overwrite / Cancel)
  - User benefit: Prevents accidental overwrites of remote changes
  - (commit d8b2ac6)

- **Dark theme support**
  - Technical: System-aware theme switching with persistent preference (themeModeProvider)
  - User benefit: Comfortable editing in any lighting condition
  - (commit d8b2ac6)

- **Markdown quick help**
  - Technical: Tap-to-open bottom sheets for field help (Owner/Repository/Path/Nickname guidance)
  - User benefit: Clear guidance without cluttering UI
  - (commit d8b2ac6)

### Fixed 🐛
- **Token authentication in release builds**
  - Technical: Added INTERNET permission + token sanitization (trim, remove invisible chars)
  - Impact: Token works reliably on physical devices
  - (commit d8b2ac6)

- **Theme persistence**
  - Technical: themeModeProvider backed by flutter_secure_storage
  - Impact: Theme choice persists after restart
  - (commit d8b2ac6)

- **Android 12+ splash screen**
  - Technical: Added flutter_native_splash.android_12 config
  - Impact: Correct logo display on Android 12+ (API 31+)
  - (commit d8b2ac6)

- **Offline sync error handling**
  - Technical: Catch SocketException and show user-friendly SnackBar
  - Impact: Clear network error messages instead of crashes
  - (commit d8b2ac6)

### Code Quality 🛠️
- **Service layer extraction** (Phases 1-3 Atomization)
  - Extracted SyncService, TokenService, ProjectFileService, AutoSaveMixin
  - 60% LOC reduction in file_editor_screen, 20% in settings_screen
  - Reusable components: FieldHelpButton, SnackHelper, ConfigDialog, ConflictDialog
  - (commits d6c7ef6, 773fda1, 63a8032, 92ce174, 7ff8f7b)

### Security 🔒
- Personal Access Token secure storage (flutter_secure_storage)
- Token validation with test button
- Debug-only token display (kDebugMode guard)

### Technical Stack
- Flutter 3.5+ / Riverpod 2.4+ / Drift (SQLite)
- GitHub REST API (fetchFile, updateFile, testToken)
- Dotlyn UI shared package (theme + colors)
- Platforms: Android, iOS (mobile-only)

### Tested On
- ✅ Android Emulator API 34
- ✅ Physical Android device (release build)
- ⏳ iOS Simulator (pending)

---

## Release Notes (for stores)

<!-- 
Copie manuelle dans Google Play / App Store lors release
Google Play: 500 chars max
App Store: 4000 chars max
-->

### v0.1.0 — MVP Release

**Quick markdown editing synced with GitHub**

Work on your development markdown files (PROMPT_USER.md, APP.md, etc.) directly from your phone. Offline-first with manual sync when you're ready.

**What's included**:
✅ Track files from any GitHub repo (owner/repo/path)
✅ Markdown editor with auto-save
✅ Manual sync with conflict detection
✅ Dark theme support
✅ Secure token storage

**Tested on Android emulators and physical devices.**

**Known Limitations**:
- Manual sync only (no background sync)
- Plain text editor (no markdown preview)
- Mobile-only (Android/iOS)

**Next release (v0.2)**: Improved settings UX, export backup, better conflict resolution.

---

[Unreleased]: https://github.com/sedounet/dotlyn-apps/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/sedounet/dotlyn-apps/releases/tag/v0.1.0
