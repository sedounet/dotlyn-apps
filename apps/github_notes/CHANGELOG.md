# Changelog — GitHub Notes

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Widget library: `FileCard` widget for reusable file display with status badges
- Unit tests: Basic database tests for ProjectFiles, FileContents, AppSettings
- Test infrastructure: `AppDatabase.testConstructor` for testing

### Changed
- N/A

### Fixed
- Analyzer: Removed `dead_null_aware_expression` in main.dart
- Analyzer: Applied `const` constructors in markdown help dialog

---

## [0.1.0] - 2026-01-01

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
