# Tabata — Documentation de développement

> **Version actuelle** : 0.1.0 (MVP)  
> **Dernière update** : 2025-11-06  
> **Status** : 📋 Planifié (pas encore démarré)

---

## 🎯 Vision

**Timer HIIT pour le fitness.**  
Tabata classique : 20 sec effort intense / 10 sec repos × 8 rounds = 4 minutes.  
Extension possible vers HIIT custom, Crossfit, boxe, etc.

**Différenciation** : UI fitness-oriented, sons motivants, customisation totale des intervals.  
**Cas d'usage** : HIIT, Crossfit, boxe, yoga vinyasa, entraînement fractionné course à pied.

---

## 📦 Versions

### v0.1 — MVP

- [ ] Interface Tabata avec cycles visuels clairs (WORK / REST)
- [ ] Preset classique : 20s effort / 10s repos × 8 rounds
- [ ] Préparation : 10 sec countdown avant démarrage
- [ ] Indicateur round actuel (Round 1/8, 2/8...)
- [ ] Sons différents pour WORK / REST / Fin
- [ ] Vibrations puissantes pour changement de phase
- [ ] Écran keep-awake pendant workout
- [ ] Background support (si user switch app)
- [ ] Page settings (durées personnalisables, sons, vibrations)

**Critère de succès MVP** : Utilisable pour un workout Tabata complet (4 min) sans avoir à regarder l'écran (audio cues suffisants).

---

### v0.2 — Post-MVP Phase 1 (Custom Workouts)

- [ ] Presets HIIT populaires (30/15, 40/20, 45/15, etc.)
- [ ] Mode custom : créer ses propres intervals
- [ ] Sauvegarde presets perso (local storage)
- [ ] Historique workouts (date, type, durée totale)
- [ ] Warm-up et Cool-down optionnels (5 min chacun)
- [ ] Sons/musique motivante plus variée

---

### v0.3 — Phase 2 (Tracking & Social)

- [ ] Statistiques workouts (nb sessions/semaine, temps total)
- [ ] Intégration Apple Health / Google Fit
- [ ] Badges/achievements (10 workouts, 50 workouts, etc.)
- [ ] Export données CSV
- [ ] Mode "Coach vocal" (TTS pour encouragements)
- [ ] Partage workouts (QR code ou lien)
- [ ] Widget home screen avec dernier workout

---

## 📝 TODO

### 🔴 P1 — ASAP (MVP)

- [ ] Créer state machine Tabata (PrepareState, WorkState, RestState, DoneState)
- [ ] Implémenter logique rounds (8 cycles work/rest)
- [ ] Réutiliser `dotlyn_timer_engine` pour countdown rapide (secondes)
- [ ] UI avec indicateur visuel fort (rouge = work, vert = rest)
- [ ] Sons courts et percutants (beep pour work, bell pour rest)
- [ ] Vibrations fortes pour changements de phase

---

### 🟡 P2 — v0.2 (Custom Workouts)

- [ ] Screen "Create Custom Workout" avec sliders durées
- [ ] SQLite pour sauvegarder presets + historique
- [ ] Presets populaires HIIT intégrés
- [ ] Warm-up/Cool-down avec timer séparé

---

### 🔵 P3 — v0.3 (Tracking & Social)

- [ ] Intégration HealthKit (iOS) / Health Connect (Android)
- [ ] Stats graphiques avec fl_chart
- [ ] Système badges avec animations
- [ ] Mode coach vocal avec TTS
- [ ] QR code sharing de workouts

---

## 🐛 Bugs connus

(À remplir lors du développement)

---

## 📝 Notes & Idées en vrac

- UI inspirée de "Seconds Pro" et "Interval Timer"
- Couleurs énergiques : rouge/orange pour work, bleu/vert pour rest
- Animation pulsante sur indicateur de phase (attention-grabbing)
- Sons : rechercher des beeps sportifs (type chronomètre natation)
- Vibrations : pattern différent pour work (1 vibration courte) vs rest (2 vibrations courtes)
- Mode "No screen" : juste audio/vibrations pour workout extérieur
- Intégration Spotify/Apple Music pour lancer playlist auto au démarrage ?
- Mode "Rounds infinis" pour entraînements longs (EMOM Crossfit)
- Mode "Pyramide" : augmenter progressivement durée effort (20/30/40/50/40/30/20)

---

## 🔗 Liens

- **Code** : `/apps/tabata/` (à créer)
- **Issues GitHub** : [Label tabata](https://github.com/sedounet/dotlyn-apps/labels/tabata)
- **Doc Pitch** : `_docs/apps/tabata/PITCH.md`
- **Référence méthode** : [Tabata Training Protocol](https://en.wikipedia.org/wiki/High-intensity_interval_training#Tabata_regimen)

---

**Workflow** : Issues GitHub = source de vérité. Ce fichier = vue d'ensemble + vision.
