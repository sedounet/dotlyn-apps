# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Full offline workflow**: Create and edit files without network, sync later when online
- **Multiline path field**: Long GitHub paths (e.g., `_docs/apps/myapp/FILE.md`) now display fully without truncation
- **USE_CASES.md**: Comprehensive flowchart documenting all sync scenarios (6 use cases with Mermaid diagram)
- **Phase 1 Atomization** (2026-01-10):
  - `SyncService` class: Encapsulates complete GitHub sync workflow (210 → 80 line reduction)
  - `SyncResult` sealed class: Type-safe result handling with `.when()` pattern matching
  - `TokenService` class: Centralized token management (load, save, validate, delete)
  - `ConfigDialog` widget: Reusable configuration dialog for owner/repo/path
  - `ConflictDialog` widget: Reusable conflict resolution dialog with 3-way choices
  - Riverpod providers: `syncServiceProvider`, `tokenServiceProvider` for dependency injection
  - Extracted architecture: Business logic moved from UI screens to reusable services

### Changed
- **Simplified file creation**: No GitHub validation on add (create locally, validate at sync time)
- **Save Local button**: Always enabled (except during sync loading), no auto-disable after auto-save
- **Sync error messages**: Clear offline detection with "Offline: Cannot sync to GitHub" message
- **Database queries**: Fix duplicates with `orderBy(localModifiedAt DESC).limit(1)` instead of `getSingleOrNull()`
- **file_editor_screen refactor**: Now delegates sync logic to `SyncService`, uses `.when()` pattern matching for result handling

### Fixed
- **Database duplicate crash**: Fixed "Bad state: Too many elements" error with proper orderBy + limit query
- **Path URL encoding**: Special characters (underscores, slashes) now properly encoded with `Uri.encodeFull()`
- **SHA nullable for creation**: GitHub file creation now works (SHA optional, null = create new file)
- **Button disable bug**: Sync button now properly re-enables after error via `finally` block
- **Auto-fetch removed**: No automatic GitHub fetch on file load (allows offline file opening)
- **Unused imports**: Cleaned up unused dialog_helpers and snack_helper imports in SyncService

## [0.1.0] - 2026-01-10

### Added
- Initial MVP release
- GitHub file tracking (owner/repo/path/nickname configuration)
- Markdown editor with auto-save (debounce 2s)
- Manual GitHub sync with conflict detection (SHA verification)
- Personal Access Token storage via flutter_secure_storage
- Dark theme support (system-aware)
- Offline editing with local persistence
- Markdown quick-help reference in editor
- Duplicate file tracking flow (popup menu + prefilled dialog)
- SafeArea + responsive UI

### Security
- INTERNET permission for GitHub API calls
- Token sanitization (trim, remove invisible chars)
- Secure token storage (flutter_secure_storage)

