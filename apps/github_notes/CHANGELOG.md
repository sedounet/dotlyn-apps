# Changelog — GitHub Notes

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Unreleased — Work in progress

- **Harmonised conflict menu for add-file workflow** — Adding a file that already exists on GitHub now shows contextual conflict resolution menu instead of silently overwriting.
  - Technical: `ConflictDialog` widget with 3 situation types (fileExistsRemote, bothModified, generic), integrated in `settings_screen.dart` after GitHub API check, with proper dialog closure ordering and snackbar display.
  - User benefit: Clear menu with "Fetch Remote", "Overwrite", "Cancel" options + localized messages (en/fr).
  - (commit 6b5c308, closes #19)

- **Duplicate prevention for GitHub-linked files** — Attempting to add a file that is already linked to GitHub shows a clear error dialog instead of creating duplicate.
  - Technical: Check githubSha before adding file, show localized error dialog with explanation.
  - User benefit: Prevents confusing duplicate file states and sync conflicts.
  - (commit 6b5c308)

- **File status badges: "Local" for new files** — Files created locally (not yet synced to GitHub) now show "Local" status badge with folder icon and orange color.
  - Technical: Added "pending" case in `_SyncStatusBadge` switch, renamed label to "Local" for clarity.
  - User benefit: Clear visual indication of file sync state (Local/Synced/Modified).
  - (commit 6b5c308)

- **Improved 404 error message for sync failures** — When syncing to a non-existent remote path, user now sees "Verify owner/repo/path or save locally first" instead of generic "Choose to create it".
  - Technical: Better UX guidance in `file_editor_screen.dart` error message.
  - User benefit: Clearer understanding that the path might be incorrect, not that file creation failed.
  - (commit 6b5c308)

- **Auto-create FileContent for local files** — When adding files that don't exist on GitHub, FileContent is now automatically created with "pending" status instead of leaving it empty.
  - Technical: Added FileContent creation in `settings_screen.dart` for local-only files with proper status assignment.
  - User benefit: File status badges display correctly for all files, no more "unknown" states.
  - (commit 6b5c308)

- **Imported files marked as "synced"** — Files fetched from GitHub now correctly show "Synced" status instead of "Pending".
  - Technical: Added `isImportedFromGitHub` parameter to `saveFileContent()`, logic: if imported + has SHA, status = "synced".
  - User benefit: Distinguishes between imported files (synced) and locally-created files (pending).
  - (commit 6b5c308)

---

### Previous work (v0.1)

- **Hidden token by default** — GitHub token input is hidden by default and automatically hidden when leaving Settings.
  - Technical: `settings_screen.dart` now defaults `_showToken = false` and hides token on dispose.
  - Benefit: Reduces accidental token exposure in shared/dev devices.

- **First-click sync retry** — Defensively retry first sync after short delay when token/loading latency or transient network errors occur.
  - Technical: `file_editor_screen.dart` waits briefly for `githubTokenProvider` on first click, and performs one retry after ~800ms when receiving transient `SyncError`.
  - Benefit: Reduces user-facing failures on initial sync after app start.

- **Floating SnackBar positioned above action buttons** — Snackbars are now floating and placed above the bottom action bar for better visibility.
  - Technical: `utils/snack_helper.dart` uses `SnackBarBehavior.floating` with a bottom margin computed from `MediaQuery`.
  - Benefit: Prevents SnackBars from being occluded by bottom action buttons.

_Other minor fixes and refactors included in this work_

---

## [0.1.0] - 2026-01-05

### Added (since initial version)
- **Refactors & Code Quality**:
  - Extracted `ProjectFileForm` widget — reusable Add/Edit form with validation
  - Widget tests for `ProjectFileForm` (validation + submission flows)
  - Duplicate file flow with prefilled dialog and GitHub existence check
  - Theme switcher UI (Light/Dark/System) in Settings
  - Language picker UI (English/French placeholder) in Settings
  
- **Widget Library**:
  - `FileCard` widget for reusable file display with status badges and popup menu
  - `ProjectFileForm` widget for Add/Edit file dialogs with inline validation

- **Testing Infrastructure**:
  - Basic database tests for ProjectFiles, FileContents, AppSettings
  - Widget tests: `test/widgets/project_file_form_test.dart` (2 tests passing)
  - `AppDatabase.testConstructor` for testing

### Changed
- Settings screen: Add/Edit file dialogs now use `ProjectFileForm` widget
- Improved SafeArea handling across all screens
- Caret positioning: auto-scroll to top on file load

### Fixed
- Analyzer warnings: removed `use_build_context_synchronously` lint warnings with proper mounted checks
- Analyzer: removed `dead_null_aware_expression` in main.dart
- Analyzer: applied `const` constructors throughout codebase
- **Zero analyzer issues** ✅

### Added
- **Core Features**:
  - Configure tracked files (owner/repo/path/nickname)
  - Files list screen with project files display
  - Markdown editor with scrollbar support
  - Local save (offline-first with Drift cache)
  - Manual sync to GitHub (push changes)
  - GitHub API integration (`fetchFile`, `updateFile`, `testToken`)
  
- **Security**:
  - GitHub Personal Access Token authentication
  - Secure token storage via `flutter_secure_storage`
  - Token validation with test button
  - Debug-only token display (kDebugMode)

- **Conflict Resolution**:
  - Pre-sync SHA comparison
  - Conflict detection dialog
  - Options: Fetch remote, Overwrite, Cancel

- **UI/UX**:
  - Dark theme support (system-based)
  - Markdown quick help button with syntax reference
  - Status badges (synced/modified/conflict)
  - Visible scrollbar in editor
  - Caret and scroll positioned at top on load

- **Database**:
  - Drift tables: `project_files`, `file_contents`, `app_settings`
  - Schema version 1 with migrations support
  - Repository pattern for data access

- **State Management**:
  - Riverpod providers: database, GitHub service, secure storage
  - StreamProvider for reactive file content
  - FutureProvider for token management

### Technical Stack
- **Framework**: Flutter 3.5+
- **State**: Riverpod 2.4+
- **Database**: Drift (SQLite)
- **API**: GitHub REST API
- **Theme**: Dotlyn UI (shared package)
- **Platforms**: Android, iOS (mobile-only)

### Documentation
- APP.md with vision, TODO, and quickstart guide
- PITCH.md with concept, target audience, differentiation
- README.md with quick setup instructions
- Configuration/quickstart guide with emulator setup, token generation, troubleshooting

---

## Release Notes

### v0.1.0 — MVP Release
First functional release of GitHub Notes. Mobile-only app for quick access to markdown files in GitHub repos with offline editing and manual sync.

**Tested on**: 
- ✅ Android Emulator (API 34)
- ⏳ iOS Simulator (pending)
- ⏳ Physical Android device (pending)

**Known Limitations**:
- No background sync (manual sync required)
- No advanced markdown preview (plain text editor)
- Token must be manually generated (no OAuth flow)
- Web/desktop platforms not supported

**Next Steps (v0.2)**:
- Extract FileCard widget to files list screen
- Add comprehensive unit tests
- Implement background sync
- Add markdown preview with rendering

---

[Unreleased]: https://github.com/sedounet/dotlyn-apps/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/sedounet/dotlyn-apps/releases/tag/v0.1.0
