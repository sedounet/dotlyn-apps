# Gap Analysis — Existant vs Proposé

> **Objectif** : Identifier incohérences actuelles et proposer migration vers workflow cadré  
> **Date** : 2026-01-11  
> **Principe** : L'existant = organique sans cadre, le proposé = structure robuste

---

## 🔍 Analyse de l'existant (état actuel)

### APP.md (github_notes, 298 lignes)

**✅ Ce qui fonctionne** :
- Structure P1/P2/P3 claire
- Items cochés avec dates (`Done 2026-01-10`)
- Commit SHA présent parfois (`commit d8b2ac6`)
- Liens vers USER-NOTES (`from USER-NOTES 2026-01-11`)

**❌ Problèmes identifiés** :
- Items Done mélangés avec actifs dans P1/P2
- Release Checklist répète items déjà cochés
- Pas de section "In Progress" (difficile voir ce qui est en cours)
- Dates éparpillées : 2026-01-08, 01-10, 01-11 dans même section
- Format inconsistant : certains avec SHA, d'autres non
- Pas de numérotation issues locales (#N)

**Exemple problème** :
```markdown
### 🔴 P1 — Bugs bloquants & Release v0.1

- [x] FIX: Token GitHub ne fonctionnait pas — Done 2026-01-08 ✅
- [x] FIX: Theme switch ne persistait pas — Done 2026-01-10 ✅
- [ ] TODO (from USER-NOTES 2026-01-11): Token visibility default off
- [x] Help tooltips (?) sur Add File dialog — Done 2026-01-10 (commit d8b2ac6)

**Release Checklist** :
- [x] Device smoke test — Done 2026-01-10 ✅  ← Redondant
```

**Pollution** : 50+ lignes d'items Done dans P1 alors que terminés.

---

### CHANGELOG.md (github_notes)

**✅ Ce qui fonctionne** :
- Format Keep a Changelog respecté
- Section [Unreleased] active
- Catégories Added/Changed/Fixed/Security
- Détails techniques présents
- Commit SHA référencés

**❌ Problèmes identifiés** :
- Pas de headlines "store-ready" (texte trop technique)
- Pas de séparation claire user-facing vs technical
- Dates dans section [Unreleased] (devrait être non daté)

**Exemple actuel** :
```markdown
## [Unreleased]

### Added
- **Full offline workflow**: Create and edit files without network
  - (commit 4f2a8b3)
```

**Manque** : User benefit explicite, format copier-coller store.

---

### PRE_COMMIT_CHECKLIST.md

**✅ Ce qui fonctionne** :
- Structure 3 phases claire
- flutter analyze obligatoire
- Proposition commit (pas auto)
- Format commit strict `[app] type: description`

**❌ Problèmes identifiés** :
- CHANGELOG format dans doc : `### 2026-01-10 — Brief description` (dates dans [Unreleased] ❌)
- Commit SHA "optionnel mais recommandé" → devrait être OBLIGATOIRE
- Pas de mention "Recently Done" ou archivage

**Incohérence** :
```markdown
**2.1 Marquer l'item comme fait dans APP.md**
- Ajouter date + commit SHA (optionnel mais recommandé)
```
→ Devrait être OBLIGATOIRE pour traçabilité.

---

### copilot-instructions.md

**✅ Ce qui fonctionne** :
- Workflow Git clair (branches, merge, delete)
- Format commit strict
- USER-NOTES.md lecture seule
- Pre-commit checklist référencée

**❌ Problèmes identifiés** :
- Mentionne "Issues GitHub" avec labels mais pas de process
- Pas de mention issues locales (#N)
- Pas de règle "archivage Done items"
- Pas de mention CHANGELOG format

**Contradiction existante** :
```markdown
**Issues GitHub** :
- Une issue = Un bug OU Une feature
- Labels obligatoires : `[nom-app]` + `bug` ou `feature`
```
Mais ensuite, pas de workflow décrit pour créer/gérer ces issues.

---

## 🎯 Proposition de cadrage (nouveau standard)

### 1. Structure APP.md standardisée

**Migration** :
```markdown
## 📝 TODO

### 🚧 In Progress (max 3-5 items)
- [ ] #5: Feature en cours — branch: feat/x, started: YYYY-MM-DD

### 🔴 P1 — ASAP
- [ ] #1: Bug critique (from USER-NOTES YYYY-MM-DD)

### 🟡 P2 — Next release
- [ ] #10: Feature planned

### 🔵 P3 — Backlog
- [ ] #20: Nice-to-have

### 🗨️ Parking Lot (optionnel, zone tampon)
- [ ] Question: ...
- [ ] Idea: ...

### ✅ Recently Done (last 15 items or 2 weeks)
- [x] #3: Feature X — Done YYYY-MM-DD (commit abc1234)

### 📦 Pre-Workflow Archive (items avant 2026-01-11)
<details>
<summary>50+ items historiques (2026-01-08 → 2026-01-10)</summary>

- [x] FIX: Token GitHub — Done 2026-01-08 (pre-workflow)
- [x] FIX: Theme switch — Done 2026-01-10 (pre-workflow)
...

</details>
```

**Avantages** :
- ✅ In Progress visible
- ✅ Recently Done court (2 weeks max)
- ✅ Archive collapsible garde historique
- ✅ Tag "pre-workflow" identifie ancien vs nouveau
- ✅ Issues locales #N pour tracking léger

---

### 2. CHANGELOG.md format store-ready

**Migration** :
```markdown
## [Unreleased]

### Added 🆕
- **User-facing headline** (max 80 chars, store-ready)
  - Technical: Implementation details
  - User benefit: Why it matters
  - (commit abc1234, closes #5)

### Fixed 🐛
- **Bug fix headline** (user-facing)
  - Technical: Root cause + solution
  - Impact: What works now
  - (commit def5678, closes #1)

---

## [0.1.0] - 2026-01-10

### Pre-Workflow Items (migrated from old format)

- Initial MVP release (see APP.md Pre-Workflow Archive for details)
- Token fixes, theme persistence, offline workflow
- (commits d8b2ac6, 7ff8f7b, multiple)
```

**Avantages** :
- ✅ Headline user-facing copier-coller stores
- ✅ Détails techniques séparés
- ✅ User benefit explicite
- ✅ Tag "Pre-Workflow" pour items historiques

---

### 3. Issues locales (#N) par défaut

**Nouveau pattern** (n'existe pas actuellement) :
```markdown
### 🔴 P1
- [ ] #1: Fix token visibility (from USER-NOTES 2026-01-11)
- [ ] #2: Investigate Sync failure

Commit: [github_notes] fix: hide token by default (closes #1)
```

**Migration** :
- Items actuels sans numéro → numéroter séquentiellement
- Nouveaux items → incrémenter #N
- SHA commit obligatoire dans Recently Done

**Issues GitHub** :
- ⛔ Feature VERROUILLÉE par défaut
- Activation manuelle si besoin collaboration
- Pattern `GH#N` distinct de `#N`

---

### 4. Commit SHA OBLIGATOIRE

**Changement** :
```markdown
Avant (optionnel) :
- [x] Feature X — Done 2026-01-10

Après (obligatoire) :
- [x] #5: Feature X — Done 2026-01-10 (commit abc1234)
```

**Raison** : Traçabilité git essentielle même en solo.

**Update PRE_COMMIT_CHECKLIST.md** :
```markdown
**2.1 Marquer l'item comme fait**
- Cocher [x] et déplacer vers Recently Done
- Format OBLIGATOIRE : — Done YYYY-MM-DD (commit SHA7CHAR)
- Récupérer SHA : git log -1 --pretty=format:"%h"
```

## 🔄 Plan de migration (github_notes)

**✅ MIGRATION COMPLÈTE — 2026-01-11**

### Étape M1 : Nettoyer APP.md (30 min) ✅ DONE

**Status** : Complété 2026-01-11

**Action** :
1. Créer section "📦 Pre-Workflow Archive" collapsible
2. Déplacer tous items Done (50+) vers Archive avec tag "(pre-workflow)"
3. Créer section "✅ Recently Done" vide
4. Créer section "🚧 In Progress" vide
5. Garder P1/P2/P3 actifs uniquement
6. Numéroter items actifs : #1, #2, #3...

**Commit** :
```
[github_notes] docs: restructure APP.md with new workflow (archive 50+ old Done items)
```

---

### Étape M2 : Standardiser CHANGELOG.md (15 min) ✅ DONE

**Status** : Complété 2026-01-11

**Action** :
1. Vérifier [Unreleased] : supprimer dates si présentes
2. Ajouter format headline + technical + benefit
3. Ajouter note "Pre-workflow items in [0.1.0]"
4. Items futurs : suivre nouveau format strict

**Commit** :
```
[github_notes] docs: update CHANGELOG format for store-readiness
```

---

### Étape M3 : Update PRE_COMMIT_CHECKLIST.md (10 min) ✅ DONE

**Status** : Complété 2026-01-11

**Action** :
1. Commit SHA : "optionnel" → "OBLIGATOIRE"
2. Ajouter règle "Recently Done > 15 items → archiver"
3. Corriger format CHANGELOG (supprimer dates dans [Unreleased])
4. Ajouter étape "numéroter issue locale #N"

**Commit** :
```
[docs] update: PRE_COMMIT_CHECKLIST with mandatory SHA + issues #N
```

---

### Étape M4 : Update copilot-instructions.md (10 min) ✅ DONE

**Status** : Complété 2026-01-11

**Action** :
1. Ajouter section "Issues locales (#N) par défaut"
2. Verrouiller GitHub issues : "Feature désactivée sauf activation manuelle"
3. Référencer workflow-proposals/
4. Ajouter règle archivage Done items

**Commit** :
```
[docs] update: copilot instructions with issues #N + workflow references
```

---

## 📊 Comparaison avant/après

| Aspect                  | Avant (organique) | Après (cadré)             |
| ----------------------- | ----------------- | ------------------------- |
| **APP.md lignes**       | 298 (pollué)      | ~150 (propre)             |
| **Done items visibles** | 50+ dans P1/P2    | 10-15 max Recently Done   |
| **Issues tracking**     | Aucun système     | #N locales séquentielles  |
| **Commit SHA**          | Optionnel         | OBLIGATOIRE               |
| **In Progress**         | N/A               | Section dédiée            |
| **Historique**          | Mélangé partout   | Archive collapsible       |
| **CHANGELOG format**    | Technique seul    | User headline + technical |
| **Store-ready**         | Non               | Oui (copier-coller)       |

---

## ✅ Décisions finales

### Garder de l'existant :
- ✅ Structure P1/P2/P3 (fonctionne bien)
- ✅ CHANGELOG Keep a Changelog (standard éprouvé)
- ✅ Workflow 3 phases commit (clair)
- ✅ Format commit `[app] type: description`
- ✅ USER-NOTES.md lecture seule

### Ajouter/Changer :
- 🆕 Issues locales #N (nouveau)
- 🆕 Section In Progress (nouveau)
- 🆕 Section Recently Done (nouveau, 2 weeks)
- 🆕 Archive collapsible "Pre-Workflow" (migration)
- ✏️ Commit SHA OBLIGATOIRE (était optionnel)
- ✏️ CHANGELOG format store-ready (était trop technique)
- ⛔ GitHub issues VERROUILLÉES (était flou)

### Supprimer :
- ❌ Items Done dans P1/P2 (→ Recently Done ou Archive)
- ❌ Release Checklist redondante (→ intégrer P1)
- ❌ Dates dans CHANGELOG [Unreleased] (→ seulement dans versions)

---

## 🚀 Application recommandée

### Option Progressive (recommandé)

**Semaine 1** : Migration github_notes (M1-M4)
- Tester nouveau workflow en usage réel
- Ajuster si problèmes identifiés

**Semaine 2** : Valider retours
- Documenter leçons apprises
- Ajuster templates si besoin

**Semaine 3+** : Étendre autres apps
- money_tracker, sc_loop_analyzer
- Utiliser templates validés

### Option Complète (rapide)

**Jour 1** : Migrations M1-M4 + application immédiate sur toutes apps

---

## 🔖 Tag "Pre-Workflow"

**Usage** : Identifier items historiques (avant cadrage 2026-01-11)

**Patterns** :
```markdown
APP.md :
- [x] Old item — Done 2026-01-08 (pre-workflow)

CHANGELOG.md :
### Pre-Workflow Items (migrated)
- Legacy features and fixes (see APP.md Archive)

Commits :
- Messages anciens gardent format libre
- Messages nouveaux : suivre standard strict
```

**Avantage** : Distinction claire ancien/nouveau sans perdre historique.

---

**Version** : 1.0  
**Date** : 2026-01-11  
**Statut** : ANALYSIS COMPLÈTE — Prêt pour décision migration
