# APP.md — Template Proposé (Brouillon)

> **Objectif** : Structure claire, scalable, store-ready  
> **Statut** : BROUILLON — À étudier et adapter

---

## 📋 Vision

[Description courte de l'app — 2-3 phrases max]

**Objectif** : [Pourquoi cette app existe]

---

## 🎯 Versions

### v0.1 MVP — [Nom phase]

**Fonctionnalités complétées** :
- ✅ Feature A
- ✅ Feature B

**Non inclus v0.1** :
- ❌ Feature future X
- ❌ Feature future Y

---

## 📝 TODO

<!-- 
RÈGLES :
- Issues locales = #N (numéro séquentiel, pas GitHub)
- Commit SHA = 7 premiers chars (ex: abc1234)
- Date format = YYYY-MM-DD
- Recently Done = garder max 15 items ou 2 semaines
-->

### 🚧 In Progress (max 3-5 items actifs)

<!-- Items en cours de développement avec branche + ETA -->

- [ ] #5: Feature en cours — branch: `feat/app-short-desc`, started: YYYY-MM-DD, ETA: YYYY-MM-DD

**Exemple réel** :
```markdown
- [ ] #3: Three-way merge dialog — branch: feat/github_notes-merge-ui, started: 2026-01-11, ETA: 2026-01-13
```

---

### 🔴 P1 — ASAP (bugs bloquants, débloqueurs techniques)

<!-- Items critiques à faire immédiatement -->

- [ ] #1: Bug critique à fixer (from USER-NOTES YYYY-MM-DD)
- [ ] #2: Feature débloquante pour continuer dev

**Exemple réel** :
```markdown
- [ ] #1: Token visibility default off (from USER-NOTES 2026-01-11)
- [ ] #2: Fix intermittent Sync failure on first click
```

**⛔ Issues GitHub DÉSACTIVÉES** (feature verrouillée) :
```markdown
<!-- NE PAS utiliser ce pattern tant que feature non activée :
- [ ] #10: Feature collaborative → [GH#42](https://github.com/owner/repo/issues/42)
-->
```

**Note** : Issues locales (#N) uniquement. GitHub issues (GH#N) désactivées par défaut.

---

### 🟡 P2 — Next release (prochaine version planifiée)

<!-- Features importantes mais pas bloquantes -->

- [ ] #10: Feature X planned for v0.2
- [ ] #11: UX improvement Y

**Exemple réel** :
```markdown
- [ ] #10: Export settings as JSON backup
- [ ] #11: Refactor Settings with foldable sections
```

---

### 🔵 P3 — Backlog (long terme, nice-to-have)

<!-- Features futures, pas de priorité immédiate -->

- [ ] #20: Feature optionnelle A
- [ ] #21: Feature optionnelle B

**Exemple réel** :
```markdown
- [ ] #20: Three-way merge algorithm
- [ ] #21: Markdown preview renderer
```

---

### 🗨️ Parking Lot (ajouts organiques en session)

<!-- 
Zone temporaire pour :
- Questions posées pendant dev
- Idées spontanées
- TODOs à trier
À nettoyer en fin de session : promouvoir vers P1/P2/P3 ou archiver
-->

- [ ] Question: Should we use library X or Y? (asked YYYY-MM-DD)
- [ ] Idea: Could we add feature Z? (from brainstorm YYYY-MM-DD)
- [ ] Todo: Verify if component can be shared in dotlyn_core

**Règle** : Trier Parking Lot en fin de session
- Question résolue → supprimer ou noter réponse dans Notes
- Idea validée → promouvoir vers P2/P3 avec numéro #N
- Todo urgent → promouvoir vers P1

---

### ✅ Recently Done (last 15 items or 2 weeks)

<!-- 
Items terminés récemment — donne contexte sans polluer
Après 2 semaines ou > 15 items : déplacer vers CHANGELOG.md [Unreleased]
-->

- [x] #3: Tooltip UX improved — Done 2026-01-10 (commit d8b2ac6)
- [x] #4: SnackBar colors fixed — Done 2026-01-10 (commit 7ff8f7b)
- [x] #5: SyncService extracted — Done 2026-01-10 (commit d6c7ef6)

**Format strict** :
```markdown
- [x] #N: Short description — Done YYYY-MM-DD (commit SHA7CHAR)
```

**Si issue GitHub fermée** :
```markdown
- [x] #10: Feature done — Done 2026-01-11 (commit abc1234) (closes GH#42)
```

---

## 🔗 Liens

- PITCH.md : [`PITCH.md`](PITCH.md)
- USER-NOTES.md : [`USER-NOTES.md`](USER-NOTES.md)
- CHANGELOG.md : [`CHANGELOG.md`](CHANGELOG.md)

---

## 📌 Notes techniques

[Notes spécifiques à l'app — patterns, APIs, contraintes]

---

## Configuration / Quickstart

[Instructions setup — dépendances, secrets, commandes]

---

**Version template** : 1.0 (brouillon)  
**Date** : 2026-01-11  
**Statut** : PROPOSAL — À valider avant application
