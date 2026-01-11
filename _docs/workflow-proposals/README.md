# Workflow v2.0 — Documentation Définitive

> **Statut** : ✅ APPLIQUÉ — Source unique de vérité  
> **Date mise à jour** : 2026-01-11  
> **Objectif** : Workflow structuré, traçable, scalable

---

## 📁 Fichiers Définitifs

### 1. [WORKFLOW.md](WORKFLOW.md) — Guide Complet (Source Unique)

**Contenu consolidé** (400 lignes) :
- Vue d'ensemble : 5 étapes (Session Start → Branch → Dev → Validation → Doc)
- APP.md structure complète (Header, Vision, Versions, TODO, Liens, Footer)
- Sections TODO : In Progress, P1/P2/P3, Parking Lot, Recently Done
- Issues convention : #N (local), ⛔ GitHub DÉSACTIVÉ par défaut
- CHANGELOG workflow : [Unreleased] quotidien, format store-ready
- Workflow détaillé étape par étape avec exemples concrets
- Anti-patterns à éviter
- Recently Done archivage (max 15 items / 2 semaines)

**Remplace** :
- APP_TEMPLATE_PROPOSAL.md
- WORKFLOW_COMPLETE.md
- ISSUES_LOCAL_VS_GITHUB.md
- GAPS_ANALYSIS.md

**Usage** :
- Référence quotidienne développement
- Copier structure APP.md pour nouvelle app
- Comprendre workflow complet 5 étapes

---

### 2. [VERSIONING_CHANGELOG.md](VERSIONING_CHANGELOG.md) — Versioning + Release

**Contenu consolidé** (300 lignes) :
- Semantic versioning détaillé (MAJOR.MINOR.PATCH)
- Règles décision : breaking changes, features, bug fixes
- Cas particuliers : pre-release v0.x, hotfix
- CHANGELOG format Keep a Changelog complet
- Release workflow : [Unreleased] → [0.2.0], tagging Git
- Release notes stores : Google Play (500 chars) + App Store (4000 chars)
- Templates copier-coller pour stores
- Decision tree + exemples

**Remplace** :
- VERSIONING_RULES.md
- CHANGELOG_STRUCTURE_PROPOSAL.md
- RELEASE_NOTES_FORMAT.md

**Usage** :
- Décider version lors release (v0.1.1 vs v0.2.0 vs v1.0.0)
- Formater CHANGELOG pour stores
- Extraire headlines release notes

---

### 3. [README.md](README.md) — Index (Ce Fichier)

**Contenu** :
- Vue d'ensemble documentation workflow
- Liens vers 2 fichiers définitifs
- Quick start workflow
- Références croisées

**Usage** :
- Point d'entrée documentation workflow
- Navigation rapide

---

## 🎯 Quick Start Workflow

### Développement Quotidien

```
1. SESSION START
   → Ouvrir APP.md, choisir issue #N depuis P1/P2

2. BRANCH CREATION
   git checkout -b feat/app-desc
   → Move #N vers In Progress (branch, started, ETA)

3. DEVELOPMENT
   → Coder, commiter régulièrement
   → Idées spontanées → Parking Lot

4. VALIDATION
   flutter analyze  # MUST be clean
   flutter test     # MUST pass

5. DOCUMENTATION
   → Move #N vers Recently Done (avec SHA commit)
   → Update CHANGELOG [Unreleased]
   → Commit: [app] type: description (closes #N)
   → Merge, delete branch
```

### Release Version

```
1. Décider version : MAJOR.MINOR.PATCH (voir VERSIONING_CHANGELOG.md)
2. CHANGELOG : [Unreleased] → [0.2.0] - YYYY-MM-DD
3. Tag Git : git tag v0.2.0
4. Extraire headlines pour stores (Google Play, App Store)
5. Build + upload
```

---

## 📚 Références Croisées

### Documentation Workflow Complète
- **Workflow quotidien** : [WORKFLOW.md](WORKFLOW.md) — Source unique, 400 lignes
- **Versioning & Release** : [VERSIONING_CHANGELOG.md](VERSIONING_CHANGELOG.md) — 300 lignes
- **Pre-commit checklist** : `_docs/PRE_COMMIT_CHECKLIST.md`
- **Branching** : `_docs/BRANCHING.md`
- **Templates** : `_docs/templates/new-app/`

### Documentation Technique (non-workflow)
- **Standards apps** : `_docs/APP_STANDARDS.md` (i18n, analytics, ads)
- **State management** : `_docs/STATE_MANAGEMENT_CONVENTIONS.md` (Riverpod)
- **Secure storage** : `_docs/SECURE_STORAGE_PATTERN.md` (tokens)
- **Tests** : `_docs/GUIDE_TDD_TESTS.md`

### Copilot Instructions
- **AI workflow** : `.github/copilot-instructions.md` (intégration workflow v2.0)

---

## 🗂️ Fichiers Archivés

Les fichiers suivants ont été consolidés dans WORKFLOW.md et VERSIONING_CHANGELOG.md :

**Archivés dans `_docs/archive/workflow-proposals-v1/`** :
- `APP_TEMPLATE_PROPOSAL.md` → Intégré dans WORKFLOW.md
- `WORKFLOW_COMPLETE.md` → Intégré dans WORKFLOW.md
- `ISSUES_LOCAL_VS_GITHUB.md` → Intégré dans WORKFLOW.md
- `VERSIONING_RULES.md` → Intégré dans VERSIONING_CHANGELOG.md
- `CHANGELOG_STRUCTURE_PROPOSAL.md` → Intégré dans VERSIONING_CHANGELOG.md
- `RELEASE_NOTES_FORMAT.md` → Intégré dans VERSIONING_CHANGELOG.md
- `GAPS_ANALYSIS.md` → Obsolète (migration terminée)
- `WORKFLOW_APPLIED.md` → Tracking temporaire (complété)

**Raison archivage** : Consolidation vers 2 fichiers définitifs (WORKFLOW + VERSIONING_CHANGELOG) pour éviter redondances et disperser information.

---

**Version** : 2.0  
**Date** : 2026-01-11  
**Maintainer** : @sedounet
| **Versioning**   | Semantic (MAJOR.MINOR.PATCH) strict                     |
| **Store notes**  | Copier-coller manuel depuis CHANGELOG                   |
| **Parking Lot**  | Ajouts organiques, trier en fin session                 |
| **Commit SHA**   | 7 chars obligatoire dans Recently Done                  |

---

## � Récap décisions clés

| Aspect           | Décision                                             |
| ---------------- | ---------------------------------------------------- |
| **Issues**       | ⛔ Locales (#N) UNIQUEMENT — GitHub (GH#N) VERROUILLÉ |
| **Archive Done** | CHANGELOG après 15 items ou 2 semaines               |
| **Versioning**   | Semantic (MAJOR.MINOR.PATCH) strict                  |
| **Store notes**  | Copier-coller manuel depuis CHANGELOG                |
| **Parking Lot**  | Ajouts organiques, trier en fin session              |
| **Commit SHA**   | 7 chars obligatoire dans Recently Done               |

**⛔ IMPORTANT** : Issues GitHub (GH#N) désactivées par défaut. Ne pas utiliser sans activation manuelle explicite.

---

## �🚀 Prochaines étapes

### Option A : Validation brouillons

1. Lire tous les fichiers
2. Noter questions/ajustements souhaités
3. Discuter modifications avant application

### Option B : Application partielle

1. Choisir 1-2 fichiers à tester (ex: APP_TEMPLATE + VERSIONING_RULES)
2. Appliquer sur github_notes seulement
3. Valider en usage réel 1-2 semaines
4. Étendre aux autres apps si OK

### Option C : Application complète

1. Valider tous brouillons
2. Refactorer github_notes/APP.md avec nouvelle structure
3. Mettre à jour CHANGELOG.md format
4. Documenter dans .github/copilot-instructions.md
5. Créer template réutilisable pour nouvelles apps

---

## ❓ Questions ouvertes

- **Parking Lot** : Garder ou simplifier (peut être overkill pour solo dev) ?
- **Issues locales** : Reset numérotation à chaque version ou continu ?
- **GitHub CLI** : Installation maintenant ou attendre besoin réel ?
- **Automation** : Script Python release notes utile ou copier-coller suffit ?
- **Tagging Git** : Systématique ou seulement releases majeures ?

---

**Maintainer** : @sedounet  
**Statut** : BROUILLONS EN ÉTUDE — Ne pas appliquer sans validation
