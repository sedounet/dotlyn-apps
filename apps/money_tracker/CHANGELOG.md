# Changelog — Money Tracker

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added 🆕
_No new features yet._

### Changed ✨
_No behavioral changes yet._

### Fixed 🐛
_No fixes yet._

---

## [0.1.0] - 2025-12-30

### Added 🆕
- **Multi-account support with dual balance system**
  - Technical: CRUD accounts with Drift; Real balance (validated) + Available balance (includes pending)
  - User benefit: Track multiple bank accounts with clear financial picture
  - (Phase 0.1b-c)

- **Transaction management with swipe gestures**
  - Technical: Add/edit/delete with categories, beneficiaries, transfers; swipe right to validate, left to delete
  - User benefit: Quick one-hand transaction management
  - (Phase 0.1c-d)

- **Date filters and dark theme**
  - Technical: Filter by Day/Week/Month/Year; system-aware theme switching
  - User benefit: Analyze spending patterns; comfortable usage
  - (Phase 0.1d)

### Code Quality 🛠️
- Refactoring phases 1-3: extracted reusable components (ActionFab, ConfirmDialog, form fields, utilities)
- Impact: ~150 lines removed, 87% duplication eliminated, 0 analyzer issues
- (Phase 0.1d, 2025-12-30)

---

[Unreleased]: https://github.com/sedounet/dotlyn-apps/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/sedounet/dotlyn-apps/releases/tag/v0.1.0
