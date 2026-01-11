# Changelog — Dotlyn Apps Monorepo

Format basé sur [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).  
Versioning basé sur [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Scope** : Ce changelog tracke les changements du **monorepo global** (workflow, documentation, infrastructure, packages partagés). Pour les apps individuelles, voir `apps/[app]/CHANGELOG.md`.

---

## [Unreleased]

### Changed ✨
- **USER-NOTES template normalized to minimal format**
  - Technical: 45 lignes → 7 lignes (format libre, pas de structure imposée)
  - Impact: Uniformisation across all apps
  - (commit 1875ca4)

---

## [2.0.0] - 2026-01-11

### Added 🆕
- **Workflow v2.0 consolidated documentation**
  - Technical: Created `_docs/workflow/WORKFLOW.md` (400 lignes) + `VERSIONING_CHANGELOG.md` (300 lignes)
  - Integrated: APP.md structure, Issues #N local, Parking Lot, Recently Done with SHA, CHANGELOG [Unreleased] workflow
  - Archived: 8 proposal files to `_docs/archive/workflow-proposals-v1/`
  - Impact: Single source of truth for development workflow
  - (commit 52620be)

- **Templates for new apps**
  - Technical: Created `_docs/templates/new-app/` with 5 templates (APP.md, CHANGELOG.md, PITCH.md, USER-NOTES.md, README.md)
  - Impact: Instant app creation with consistent structure
  - (commit 52620be)

- **Monorepo versioning system**
  - Technical: Root CHANGELOG.md + README.md version tracking
  - Impact: Track monorepo evolution independently from apps
  - (commit TBD)

### Changed ✨
- **Renamed `_docs/workflow-proposals/` → `_docs/workflow/`**
  - Technical: No longer proposals, now definitive documentation
  - Updated: All references in copilot-instructions.md, templates, BRANCHING.md
  - Impact: Clear distinction between draft and final docs
  - (commit ee06354)

- **Copilot instructions completely rewritten**
  - Technical: 632 → 725 lignes with deep workflow v2.0 integration
  - Added: 3 concrete examples (Bug P1→Done, Feature+Parking Lot, Parking Lot triage)
  - Impact: AI assistant follows workflow consistently
  - (commit 52620be)

### Fixed 🐛
- **PRE_COMMIT_CHECKLIST corrected CHANGELOG format**
  - Technical: Removed dates requirement in [Unreleased] section
  - Impact: Aligns with Keep a Changelog standard
  - (commit 52620be)

- **BRANCHING.md missing APP.md integration**
  - Technical: Added "Intégration avec APP.md TODO" section (30 lignes)
  - Impact: Clear workflow for moving issues In Progress → Recently Done
  - (commit 52620be)

### Code Quality 🔧
- **Consolidated workflow documentation**
  - Refactoring: 9 proposal files → 3 definitive files (66% reduction)
  - Archive: Kept v1 files in `_docs/archive/` for reference
  - Impact: No redundancies, easier maintenance
  - (commit 52620be)

---

## [1.0.0] - 2025-12-XX

### Added 🆕
- **Initial monorepo structure**
  - Melos-based monorepo setup
  - Apps: design_lab, money_tracker, habit_tracker, github_notes, sc_loop_analyzer
  - Packages: dotlyn_ui, dotlyn_core
  - CI/CD: GitHub workflows

- **Documentation foundations**
  - Brand styleguide: `_docs/dotlyn/STYLEGUIDE.md`
  - App standards: `_docs/APP_STANDARDS.md` (i18n, analytics, ads)
  - Technical guides: STATE_MANAGEMENT_CONVENTIONS, SECURE_STORAGE_PATTERN, GUIDE_TDD_TESTS

---

**Version** : 2.0.0  
**Date** : 2026-01-11  
**Maintainer** : @sedounet
