# Habit Tracker — Documentation

**Status** : 🔵 En conception  
**Version actuelle** : -  
**Dernière update** : 2026-01-11  
**Roadmap** : Voir section TODO

---

## 📋 Versions

### v0.1 — MVP (Brouillon)

**Concepts clés** :
- App focalisée habit tracking (pas task management = future app séparée)
- Tracking bidirectionnel : habitudes positives ET négatives
- UX minimaliste : 1-2 taps max pour tracker
- Vue quotidienne prioritaire (semaine en complément)

**Features MVP** :
- CRUD habitudes (nom, type, fréquence, objectif)
- Types d'habitudes :
  - **Compteur** : +1 par tap (eau, cigarettes, pages...)
  - **Binaire** : fait/pas fait (méditation, course)
  - **Quantité** : mode avancé optionnel (saisie précise)
- Fréquences : quotidien, hebdo, mensuel
- Vue jour : liste habits avec quick tap
- Vue semaine : heatmap/compteurs simples
- Compteur progression (ex: 3/5 cette semaine)

**Tech** :
- Flutter
- Packages partagés : `dotlyn_ui`, `dotlyn_core`
- Possibilité nouveau package : `dotlyn_planning` (models communs)

**Hors scope v0.1** :
- Routines (séquences d'actions)
- Time blocking configuré
- Stats avancées / graphiques
- Notifications / rappels
- Mode avancé quantité précise

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

_Aucun item en cours actuellement._

---

### 🔴 P1 — ASAP (Conception MVP)

- [ ] #1: Valider architecture données (modèle Habit)
- [ ] #2: Valider UX quick tap (wireframes ?)
- [ ] #3: Décider stockage : local (Hive/SQLite) ou cloud ?
- [ ] #4: Définir tracking positif vs négatif (UI différenciée ?)

**⛔ Issues GitHub DÉSACTIVÉES** (feature verrouillée) :
<!-- NE PAS utiliser GitHub issues (GH#N) tant que feature non activée -->

---

### 🟡 P2 — Next release (v0.2+)

- [ ] #10: Routines (séquences d'actions)
- [ ] #11: Time blocking horaires
- [ ] #12: Stats et graphiques
- [ ] #13: Notifications / rappels
- [ ] #14: Mode avancé quantités

---

### 🔵 P3 — Backlog (long terme)

- [ ] #20: Export données (CSV, PDF)
- [ ] #21: Thèmes / personnalisation
- [ ] #22: Backup cloud
- [ ] #23: Partage / social (?)

---

### ✅ Recently Done (last 15 items or 2 weeks)

<!-- Format: [x] #N: Description — Done YYYY-MM-DD (commit SHA7CHAR) -->

_Aucun item terminé pour l'instant (app en conception)._

---

## � Liens

- PITCH.md : [`PITCH.md`](PITCH.md)
- CHANGELOG.md : [`../../../apps/habit_tracker/CHANGELOG.md`](../../../apps/habit_tracker/CHANGELOG.md)

---

## 📝 Notes

### Philosophie Design
- **Simplicité > Fonctionnalités** : 2 taps max pour tracker
- **Clarté > Exhaustivité** : pas de surcharge d'info
- **Focus > Dispersion** : vue jour prioritaire

### Inspiration Apps Existantes
- **Problèmes identifiés** :
  - Vues semaine illisibles
  - Trop d'étapes pour actions simples (ex: entrer quantité eau)
  - Fonctionnalités avancées imposées dès le départ

### Roadmap Future
- **Habit Tracker** (cette app) : routines, récurrence, time blocking
- **Task Manager** (app séparée) : GTD, projets, tâches ponctuelles
- **Partage code** : via packages monorepo (dotlyn_ui, dotlyn_core, dotlyn_planning?)

### Principes Tracking
- Habitudes **positives** : à développer (sport, lecture)
- Habitudes **négatives** : à réduire (cigarettes, alcool, sucre)
- Neutralité : l'app ne juge pas, elle aide à voir les patterns

---

## 🔗 Liens

- Issues GitHub : [Label `habit-tracker`](https://github.com/[votre-repo]/issues?q=label%3Ahabit-tracker)
- Documentation : `_docs/apps/habit_tracker/`
