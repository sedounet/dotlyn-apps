# Habit Tracker — Documentation Technique

**Status** : 🔵 En conception  
**Version actuelle** : -  
**Dernière update** : 2025-12-27

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

## ✅ TODO

### 🔴 P1 — ASAP (Conception)
- [ ] Valider architecture données (modèle Habit)
- [ ] Valider UX quick tap (wireframes ?)
- [ ] Décider stockage : local (Hive/SQLite) ou cloud ?
- [ ] Définir tracking positif vs négatif (UI différenciée ?)

### 🟡 P2 — v0.2+
- [ ] Routines (séquences d'actions)
- [ ] Time blocking horaires
- [ ] Stats et graphiques
- [ ] Notifications / rappels
- [ ] Mode avancé quantités

### 🔵 P3 — Plus tard
- [ ] Export données (CSV, PDF)
- [ ] Thèmes / personnalisation
- [ ] Backup cloud
- [ ] Partage / social (?)

---

## 🤔 Questions ouvertes

**Architecture** :
- Modèle unifié Habit ou types distincts (Counter/Binary/Quantity) ?
- Catégories habitudes (bien-être, travail...) dès MVP ?
- Gestion objectifs : par habitude ou globale ?

**UX** :
- Vue par défaut : liste ou cards ?
- Quick actions : tap simple ou swipe ?
- Affichage tracking négatif : compteur inversé ? warning visuel ?

**Données** :
- Historique : combien de jours conserver ?
- Streaks : calculés à la volée ou stockés ?
- Soft delete ou suppression définitive ?

---

## 🐛 Bugs Connus

_Aucun bug pour le moment_

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
