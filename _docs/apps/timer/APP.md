# Timer — Documentation de développement

> **Version actuelle** : 0.1.0 (MVP)  
> **Dernière update** : 2025-11-03  
> **Status** : 🚧 En développement actif

---

## 🎯 Vision

Timer simple et fiable qui fonctionne en arrière-plan avec notifications riches.  
Permet de gérer des sessions de travail/repos (Pomodoro ou custom).

**Cas d'usage** : Étudiants en révision, freelances, professionnels utilisant méthode Pomodoro.

---

## 📦 Versions

### v0.1 — MVP (en cours)
- [x] Interface timer avec play/pause/reset
- [x] Configuration durée personnalisée
- [x] Sons configurables (3 choix)
- [x] Vibrations
- [ ] **EN COURS** : Fonctionnement en background (iOS/Android)
- [ ] **EN COURS** : Notifications basiques de fin de session

**Critère de succès MVP** : Timer utilisable quotidiennement sans avoir à garder l'app ouverte.

---

### v0.2 — Post-MVP Phase 1
- [ ] Notifications enrichies (pause/resume depuis notif)
- [ ] Presets timers favoris (25min Pomodoro, 5min pause, custom)
- [ ] Historique des sessions (local)
- [ ] Settings avancés (sons custom, vibreur on/off, thème clair/sombre)
- [ ] Animations UI polish

---

### v0.3 — Phase 2
- [ ] Stats graphiques (temps total/jour, sessions/semaine)
- [ ] Export données CSV
- [ ] Multi-timers simultanés (max 3)
- [ ] Mode focus avec DND automatique
- [ ] Widget home screen (Android/iOS)

---

## 📝 TODO

### 🔴 P1 — ASAP (débloqueurs)

- [ ] **Bug critique** : Timer se réinitialise si app tuée brutalement (Android 12+) → Issue #1
  - **Impact** : Rend l'app inutilisable en arrière-plan
  - **Action** : Implémenter service foreground Android
  
- [ ] Implémenter permissions background Android 12+ → Issue #2
  - **Bloque** : Background service (feature MVP)
  - **Action** : REQUEST_IGNORE_BATTERY_OPTIMIZATIONS + config AndroidManifest
  
- [ ] Configurer plugin notification iOS avec validation → Issue #3
  - **Bloque** : Notifications (feature MVP)
  - **Action** : Setup flutter_local_notifications + permissions iOS

---

### 🟡 P2 — v0.2 (prochaine version)

- [ ] Notifications enrichies avec boutons pause/resume → Issue #10
- [ ] Presets favoris (UI + storage local) → Issue #11
- [ ] Historique sessions avec SQLite → Issue #12
- [ ] Settings page complète (sons, vibreur, thème) → Issue #13

---

### 🔵 P3 — v0.3 et plus tard

- [ ] Stats graphiques avec charts (fl_chart package)
- [ ] Export CSV avec share
- [ ] Multi-timers (architecture à revoir)
- [ ] Trouver sonnerie plus dynamique/énergique
- [ ] Mode focus avec intégration DND système

---

## 🐛 Bugs connus

### Critiques (empêchent utilisation)
- [ ] Timer se réinitialise si app tuée → #1

### Mineurs (contournables)
- [ ] Son ne joue pas si téléphone en mode silencieux total → #4
- [ ] Vibration parfois retardée de 1-2 secondes → #5

---

## 📝 Notes & Idées en vrac

- Tester comportement avec écran éteint pendant 1h+
- Voir si on peut réutiliser le code notif pour d'autres apps (package partagé ?)
- Creuser l'API Alarm Manager Android pour fiabilité background
- Intégration calendrier possible ? (phase 3-4)
- Mode "strict" Pomodoro avec blocage pause ? (controverse)

---

## 🔗 Liens

- **Code** : `/apps/timer/`
- **Issues GitHub** : [Label timer](https://github.com/sedounet/dotlyn-apps/labels/timer)
- **Design** : _À venir (Figma)_
- **Tests** : _À définir (devices réels nécessaires)_

---

**Workflow** : Issues GitHub = source de vérité. Ce fichier = vue d'ensemble + vision.
