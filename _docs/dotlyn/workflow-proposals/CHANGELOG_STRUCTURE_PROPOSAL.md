# CHANGELOG Structure Proposée (Brouillon)

> **Objectif** : Format exploitable pour stores (Google Play, App Store)  
> **Statut** : BROUILLON — À étudier et adapter

---

## Format recommandé

```markdown
# Changelog

Toutes les modifications notables de ce projet sont documentées ici.

Format basé sur [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).  
Versioning basé sur [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

<!-- 
Section active — ajout quotidien
À renommer en version numérotée lors release
-->

### Added 🆕
- **User-facing headline** (max 80 chars, store-ready)
  - Technical detail: Implementation with ServiceX
  - User benefit: Explains why it matters
  - (commit abc1234, from issue #5)

### Changed ✨
- **Behavior modification headline**
  - Technical: What changed internally
  - Impact: How it affects usage
  - (commit def5678)

### Fixed 🐛
- **Bug fix headline**
  - Technical: Root cause + solution
  - Impact: What works now
  - (commit ghi9012, closes #3)

---

## [0.2.0] - 2026-01-15

<!-- 
Version figée — utilisée pour release stores
Copie de [Unreleased] au moment du tag
-->

### Added 🆕
- **Offline editing support**
  - Technical: Create/edit files without network, sync later when online
  - User benefit: Work anywhere, sync when you have connectivity
  - (commit 4f2a8b3, closes #12)

- **Export settings backup**
  - Technical: JSON export via Share sheet with all tracked files
  - User benefit: Easy migration to new device or restore after reinstall
  - (commit 8d3c1f9, from issue #10)

### Changed ✨
- **Simplified file creation flow**
  - Technical: Removed GitHub validation on add, validate at sync time
  - Impact: Faster to add files, better offline UX
  - (commit a5b9e2c)

### Fixed 🐛
- **Token visibility security**
  - Technical: Default to hidden, auto-hide when leaving settings
  - Impact: Prevents accidental token exposure
  - (commit 7e4d2a1, closes #1)

- **Sync button intermittent failure**
  - Technical: Race condition in first-click handler resolved
  - Impact: Reliable sync on first attempt
  - (commit 3c8f5b2, closes #2)

---

## [0.1.0] - 2026-01-10

### Added 🆕
- **Initial MVP release**
  - GitHub file tracking (owner/repo/path configuration)
  - Markdown editor with auto-save (2s debounce)
  - Manual sync with conflict detection (SHA verification)
  - Personal Access Token secure storage
  - Dark theme support (system-aware)
  - Offline editing with local persistence
  - (commit d8b2ac6)

### Security 🔒
- INTERNET permission for GitHub API
- Token sanitization (trim, remove invisible chars)
- flutter_secure_storage for token persistence
