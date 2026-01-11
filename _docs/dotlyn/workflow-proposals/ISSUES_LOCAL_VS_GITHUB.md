# Issues Locales vs GitHub Issues (Brouillon)

> **Objectif** : Tracking léger par défaut, escalade si besoin  
> **Statut** : BROUILLON — À étudier et adapter  
> **⛔ IMPORTANT** : Issues GitHub DÉSACTIVÉES par défaut (feature verrouillée)

---

## Principe général

**Par défaut** : Issues locales dans APP.md (numérotation #1, #2, #3...)  
**⛔ GitHub issues VERROUILLÉ** : Feature désactivée, ne pas utiliser sans activation manuelle  
**Escalade optionnelle** : GitHub issues (GH#N) seulement après déverrouillage manuel

---

## Issues locales (#N)

### Format dans APP.md

```markdown
### 🔴 P1 — ASAP

- [ ] #1: Fix token visibility default (from USER-NOTES 2026-01-11)
- [ ] #2: Investigate first-click Sync failure (intermittent)
- [ ] #3: Adjust SnackBar placement above buttons
```

### Règles

- **Numérotation** : Séquentielle par app (#1, #2, #3...)
- **Reset** : À chaque version majeure si souhaité (optionnel)
- **Format commit** : `[app] type: description (closes #N)`
- **Référence** : `closes #N` dans commit message

### Avantages

✅ Léger, pas de setup GitHub  
✅ Numéros courts faciles à taper  
✅ Pas de pollution repo avec micro-issues  
✅ Ownership clair (solo dev)

### Inconvénients

⚠️ Pas de suivi externe (OK pour solo)  
⚠️ Pas de notifications/labels GitHub  
⚠️ Faut maintenir numérotation manuellement

---

## GitHub Issues (GH#N)

### ⛔ Feature VERROUILLÉE — Ne pas utiliser

**Statut** : DÉSACTIVÉ par défaut

### Conditions déverrouillage (manuel)

Avant d'utiliser GitHub issues, vérifier TOUS critères :
- ✅ Besoin réel de tracking public confirmé
- ✅ gh CLI installé et configuré (`gh auth login`)
- ✅ Labels créés dans repo GitHub
- ✅ Décision explicite d'activer cette feature
- ✅ Documentation workflow mise à jour

### Quand créer une GitHub issue ? (après déverrouillage)

**Critères d'escalade** :
- Bug critique nécessitant suivi externe (reproductibilité, tests multiples devices)
- Feature > 1 semaine de dev (découpage en sous-tâches utile)
- Collaboration prévue (contributeur externe, code review)
- Discussion publique souhaitée (community feedback)

### Format dans APP.md

```markdown
### 🔴 P1 — ASAP

**Issues locales** :
- [ ] #1: Fix token visibility (from USER-NOTES)

**GitHub issues** :
- [ ] #12: Implement three-way merge → [GH#42](https://github.com/sedounet/dotlyn-apps/issues/42)
```

### Création avec GitHub CLI

**Installation** (Windows) :
```powershell
winget install GitHub.cli
gh auth login
```

**Créer issue** :
```powershell
gh issue create --title "[github_notes] P1: Fix token visibility" \
                --body "From USER-NOTES 2026-01-11: Token should be hidden by default in settings" \
                --label "github_notes,P1,bug"
```

**Lister issues** :
```powershell
gh issue list --label "github_notes"
```

**Fermer issue** :
```powershell
gh issue close 42 --comment "Fixed in commit abc1234"
```

### Format commit avec GH issue

```markdown
[github_notes] fix: hide token by default in settings (closes GH#42)
```

### Avantages

✅ Suivi externe avec labels/milestones  
✅ Notifications automatiques  
✅ Discussion thread publique  
✅ Intégration CI/CD (auto-close on merge)

### Inconvénients

⚠️ Setup requis (gh CLI ou web)  
⚠️ Overhead pour micro-issues  
⚠️ Numéros longs (#42 au lieu de #1)

---

## Workflow hybride recommandé

### Phase 1 (MVP, solo dev) — Issues locales uniquement

```markdown
### 🔴 P1
- [ ] #1: Bug A
- [ ] #2: Bug B

Commit: [app] fix: resolve bug A (closes #1)
```

### Phase 2 (beta, quelques testeurs) — Mix

```markdown
### 🔴 P1

**Local** :
- [ ] #5: Quick fix for UX

**GitHub** :
- [ ] #10: Critical bug reported by tester → [GH#42](...)

Commit: [app] fix: critical bug reported by beta tester (closes GH#42)
```

### Phase 3 (public release) — GitHub issues majoritaires

```markdown
### 🔴 P1
- [ ] #50: User-reported crash → [GH#128](...)
- [ ] #51: Performance issue → [GH#129](...)

Commits référencent GH# pour traçabilité publique
```

---

## Conversion manuelle (si escalade)

**Issue locale → GitHub issue** :

1. Copier contexte depuis APP.md
2. Créer GH issue avec `gh issue create`
3. Update APP.md :
   ```markdown
   - [x] #3: Bug X — Escalated to GH#42
   - [ ] #3: Bug X → [GH#42](https://github.com/.../issues/42)
   ```
4. Commits futurs référencent `GH#42`

---

## Labels recommandés (GitHub)

Si utilisation GitHub issues :

- **Par app** : `github_notes`, `money_tracker`, `sc_loop_analyzer`
- **Par type** : `bug`, `feature`, `chore`, `docs`
- **Par priorité** : `P1`, `P2`, `P3`
- **Par statut** : `in-progress`, `blocked`, `waiting-feedback`

**Création labels** (une fois) :
```powershell
gh label create "github_notes" --color E36C2D --description "GitHub Notes app"
gh label create "P1" --color FF0000 --description "ASAP priority"
gh label create "bug" --color D73A4A --description "Bug fix"
```

---

**Version** : 1.0 (brouillon)  
**Date** : 2026-01-11  
**Statut** : PROPOSAL — À valider avant application
