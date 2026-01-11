# Versioning Rules (Semantic Versioning)

> **Objectif** : Règles claires pour numérotation versions  
> **Statut** : BROUILLON — À adapter par app si besoin

---

## Format

**MAJOR.MINOR.PATCH** (ex: 1.2.3)

Basé sur [Semantic Versioning 2.0.0](https://semver.org/)

---

## Règles générales

### MAJOR (1.0.0, 2.0.0, 3.0.0...)

**Quand incrémenter** :
- Breaking changes (incompatibilité avec version précédente)
- Architecture refactor majeur
- Migration DB incompatible (schéma change, pas de migration auto)
- Suppression feature existante

**Exemples** :
```markdown
## [2.0.0] - 2026-06-01

### Removed
- **Removed legacy sync mode** (breaking change)
  - Impact: Users must reconfigure GitHub tokens
  
### Changed
- **Database schema v2** (incompatible with v1.x)
  - Impact: Requires fresh install or manual migration
```

**Impact utilisateur** : Peut nécessiter action (reconfiguration, réinstall)

---

### MINOR (0.1.0, 0.2.0, 1.1.0...)

**Quand incrémenter** :
- Nouvelle feature (backwards-compatible)
- Amélioration UX significative
- Nouvelle API/service ajouté
- Migration DB compatible (auto-migration)

**Exemples** :
```markdown
## [0.2.0] - 2026-01-15

### Added
- **Offline editing support** (new feature)
  - Impact: Users can now work without internet
  
- **Export settings backup** (new feature)
  - Impact: Easy migration to new device
```

**Impact utilisateur** : Nouvelles capacités, pas de rupture

---

### PATCH (0.1.1, 0.1.2, 1.0.1...)

**Quand incrémenter** :
- Bug fix uniquement
- Amélioration performance sans changement fonctionnel
- Correctif sécurité
- Typo/texte corrigé

**Exemples** :
```markdown
## [0.1.1] - 2026-01-12

### Fixed
- **Token visibility security** (bug fix)
  - Technical: Default to hidden, auto-hide on exit
  
- **Sync button intermittent failure** (bug fix)
  - Technical: Race condition resolved
```

**Impact utilisateur** : Corrections, pas de nouvelle feature

---

## Cas particuliers

### Pre-release (v0.x.y)

**Avant v1.0.0** : API/features instables, breaking changes possibles

```markdown
## [0.1.0] - MVP initial
## [0.2.0] - Ajout feature X (peut casser compatibilité v0.1)
## [0.3.0] - Refactor Y
## [1.0.0] - Première release stable publique
```

**Règle** : Incrémenter MINOR librement en v0.x, MAJOR peut attendre v1.0.0

---

### Hotfix urgent

**Si bug critique en production** :

```markdown
## [1.0.0] - 2026-01-10 (release stable)

## [1.0.1] - 2026-01-11 (hotfix)

### Fixed
- **Critical crash on Android 12+**
  - Technical: NullPointerException in SyncService
  - Impact: App now stable on all Android versions
```

**Process** :
1. Branch `hotfix/critical-crash` depuis tag v1.0.0
2. Fix + test
3. Merge main
4. Tag v1.0.1
5. Release immédiate sans attendre autres features

---

## Exemples concrets (GitHub Notes)

### Historique fictif

```markdown
## [0.1.0] - 2026-01-10
MVP initial : tracking files, sync, offline editing

## [0.1.1] - 2026-01-11
Hotfix: token visibility security

## [0.2.0] - 2026-01-15
Feature: export settings backup + three-way merge

## [0.2.1] - 2026-01-18
Bugfix: merge dialog crash on conflict

## [0.3.0] - 2026-02-01
Feature: localization (en/fr) + analytics opt-in

## [1.0.0] - 2026-03-01
Stable public release (features finalisées, tests complets, store release)

## [1.1.0] - 2026-04-15
Feature: OAuth GitHub login (alternative au PAT)

## [1.1.1] - 2026-04-20
Bugfix: OAuth token refresh issue

## [2.0.0] - 2026-08-01
Breaking: nouvelle architecture sync bidirectionnel (requiert reconfiguration)
```

---

## Decision tree (aide rapide)

```
Changement terminé
    ↓
Est-ce une breaking change / architecture refactor majeur?
    ├─ Oui → MAJOR (x+1.0.0)
    └─ Non
        ↓
        Est-ce une nouvelle feature / amélioration UX?
            ├─ Oui → MINOR (x.y+1.0)
            └─ Non
                ↓
                Est-ce un bug fix / performance / typo?
                    └─ Oui → PATCH (x.y.z+1)
```

---

## Intégration avec workflow

### Dans APP.md

```markdown
## 🎯 Versions

### v0.2.0 — Next release (in progress)

**Target date** : 2026-01-15

**Features planned** :
- [ ] #10: Export settings backup (MINOR bump)
- [ ] #11: Three-way merge (MINOR bump)

**Bug fixes** :
- [ ] #1: Token visibility (PATCH si seul)
```

### Dans CHANGELOG.md

```markdown
## [Unreleased]

### Added (will be MINOR bump)
- **Export settings backup**

### Fixed (will be PATCH if alone, or included in MINOR)
- **Token visibility security**

→ Decision lors release :
   - Si Added non vide → v0.2.0 (MINOR)
   - Si seulement Fixed → v0.1.1 (PATCH)
```

---

## Versioning par app

**Indépendant** : Chaque app a son propre versioning

```
apps/github_notes → v0.2.0
apps/money_tracker → v0.1.5
apps/sc_loop_analyzer → v0.1.0
```

**Pas de versioning monorepo** : Les apps évoluent à leur rythme

---

## Tagging Git (recommandé)

**Format tag** : `github_notes-v0.2.0` (préfixe app pour clarté)

```powershell
git tag -a github_notes-v0.2.0 -m "GitHub Notes v0.2.0: Offline editing + Export backup"
git push origin github_notes-v0.2.0
```

**Avantages** :
- Retrouver code exact d'une version
- Rollback si besoin
- Release notes automatiques (GitHub Releases)

---

**Version** : 1.0 (brouillon)  
**Date** : 2026-01-11  
**Statut** : PROPOSAL — À adapter par app si besoin spécifique
