# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Tap-to-open field help**: Replace Tooltip with FieldHelpButton widget (bottom sheet on icon tap) in Add File dialog for all 4 fields (Owner, Repository, File Path, Nickname)
- **SnackHelper utility**: Centralized SnackBar styling using DotlynColors (error/success/info) — 15+ usages across file_editor_screen and settings_screen
- **FieldHelpButton widget**: Reusable widget extracting IconButton + showModalBottomSheet pattern, reducing boilerplate by 20-line blocks

### Changed
- **Styleguide compliance**: Replace hardcoded Colors.white and Colors.red with theme-derived colors (Theme.of(context).colorScheme.onPrimary, DotlynColors.error)
- **Offline error messages**: Sync failures now show red SnackBar via SnackHelper.showError instead of generic toast

### Fixed
- **Android 12+ splash**: Added android_12 config in flutter_native_splash (see pubspec.yaml)
- **Token GitHub release**: Added INTERNET permission to AndroidManifest.xml + token sanitization (trim invisible chars)
- **Theme persistence**: Added themeModeProvider + SecureStorage persistence for app-wide dark/light mode
- **Deprecated API**: Replaced surfaceVariant → surfaceContainerHighest (Material 3 color scheme update)

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

