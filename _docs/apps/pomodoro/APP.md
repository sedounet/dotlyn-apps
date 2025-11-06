# Pomodoro — Documentation de développement

> **Version actuelle** : 0.1.0 (MVP)  
> **Dernière update** : 2025-11-06  
> **Status** : 📋 Planifié (pas encore démarré)

---

## 🎯 Vision

**Pomodoro strict pour la productivité.**  
Suit la méthode Pomodoro classique : 4 sessions de 25 min + pauses courtes, puis pause longue.

**Différenciation** : Respect strict de la méthode, compteur de sessions, historique de productivité.  
**Cas d'usage** : Étudiants en révisions intensives, freelances, télétravail, deep work.

---

## 📦 Versions

### v0.1 — MVP

- [ ] Interface Pomodoro avec cycles automatiques
- [ ] Preset classique : 25 min travail / 5 min pause / 15 min pause longue
- [ ] Compteur sessions (1/4, 2/4, 3/4, 4/4)
- [ ] Auto-start session suivante (optionnel dans settings)
- [ ] Bouton "Skip pause" / "Skip session"
- [ ] Notifications de changement de phase (travail → pause)
- [ ] Sons différents pour fin de travail / fin de pause
- [ ] Vibrations
- [ ] Fonctionnement en background
- [ ] Page settings (durées personnalisables, auto-start, sons)

**Critère de succès MVP** : Utilisable pour une session de travail de 2h (4 Pomodoros) sans toucher l'app.

---

### v0.2 — Post-MVP Phase 1 (Tracking)

- [ ] Historique des sessions (date, nb Pomodoros complétés)
- [ ] Statistiques jour/semaine/mois (nb sessions, temps total focus)
- [ ] Graphiques de productivité (fl_chart)
- [ ] Badges/achievements (10 Pomodoros, 50 Pomodoros, etc.)
- [ ] Presets personnalisés (ex: 50/10/30 pour sessions longues)
- [ ] Google Analytics

---

### v0.3 — Phase 2 (Premium)

- [ ] Mode "Strict" : impossible de skip ou pause (pour discipline)
- [ ] Multi-projets : assigner des sessions à des projets
- [ ] Tags : travail, études, sport, etc.
- [ ] Export CSV des sessions
- [ ] Backup cloud (Firebase)
- [ ] Intégration calendrier (bloquer créneaux)
- [ ] Widget home screen avec compteur sessions du jour

---

## 📝 TODO

### 🔴 P1 — ASAP (MVP)

- [ ] Créer state machine Pomodoro (WorkState, ShortBreakState, LongBreakState, IdleState)
- [ ] Implémenter logique de cycles (4 work → 1 long break)
- [ ] Réutiliser `dotlyn_timer_engine` pour countdown
- [ ] Gérer transitions automatiques entre phases
- [ ] Notifications différenciées (work done vs pause done)
- [ ] UI avec indicateur de phase actuelle (1/4, 2/4...)

---

### 🟡 P2 — v0.2 (Tracking)

- [ ] SQLite pour historique sessions
- [ ] Screen stats avec graphiques
- [ ] Calculs stats (moyenne sessions/jour, streaks)
- [ ] Système badges avec animations

---

### 🔵 P3 — v0.3 (Premium)

- [ ] Paywall pour mode strict + multi-projets
- [ ] Firebase Firestore pour backup sessions
- [ ] API Calendar pour intégration
- [ ] Widget Android/iOS

---

## 🐛 Bugs connus

(À remplir lors du développement)

---

## 📝 Notes & Idées en vrac

- Interface inspirée de Forest/Be Focused (simple et claire)
- Animation de progression circulaire pendant la session
- Son de "ding" différent pour travail vs pause (associatif)
- Mode "Strict" pourrait bloquer temporairement certaines apps (controverse)
- Gamification légère : streaks de jours consécutifs avec Pomodoros
- Intégration Notion/Todoist pour lier sessions à des tâches ?

---

## 🔗 Liens

- **Code** : `/apps/pomodoro/` (à créer)
- **Issues GitHub** : [Label pomodoro](https://github.com/sedounet/dotlyn-apps/labels/pomodoro)
- **Doc Pitch** : `_docs/apps/pomodoro/PITCH.md`
- **Référence méthode** : [The Pomodoro Technique](https://francescocirillo.com/pages/pomodoro-technique)

---

**Workflow** : Issues GitHub = source de vérité. Ce fichier = vue d'ensemble + vision.
