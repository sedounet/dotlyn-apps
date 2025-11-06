# Timer — Documentation de développement

> **Version actuelle** : 0.1.0 (MVP)  
> **Dernière update** : 2025-11-06  
> **Status** : 🚧 En développement actif

---

## 🎯 Vision

**Le timer le plus simple et fiable.**  
Un seul timer, durée personnalisable, fonctionne en arrière-plan.

**Différenciation** : Pas de features inutiles, juste un timer qui marche à tous les coups.  
**Cas d'usage** : Cuisine, méditation, révisions, sieste, sport, n'importe quelle tâche chronométrée.

---

## 📦 Versions

### v0.1 — MVP (en cours)
- [ ] Interface timer simple : durée + play/pause/reset
- [ ] Sélecteur durée rapide (1/5/10/15/30 min + custom)
- [ ] Sons configurables (3 choix simples)
- [ ] Vibrations
- [ ] Fonctionnement en background (iOS/Android)
- [ ] Notification de fin de session
- [ ] Page settings minimale (son, vibration, thème)

**Critère de succès MVP** : Timer utilisable en cuisine/méditation sans avoir à garder l'app ouverte.

**Note** : Pas d'analytics/ads dans MVP. Focus sur la fiabilité technique (background service).

---

### v0.2 — Post-MVP Phase 1 (Monétisation)
- [ ] Google Analytics intégré
- [ ] Google Ads (bannière en bas)
- [ ] Possibilité de support par video ads (remove ads)
- [ ] Système de favoris UI (presets) stockage local
- [ ] Réglage retour haptique avancé

---

### v0.3 — Phase 2 (Features avancées)
- [ ] Multi-timers simultanés (max 3)
- [ ] Backup données sur cloud (Google Drive/iCloud)
- [ ] Widget home screen (Android/iOS)
- [ ] Mode focus avec DND automatique
- [ ] Sons custom (upload perso)

---

## 📝 TODO

### 🔴 P1 — ASAP (MVP)

- [ ] Implémenter background service Android (Foreground Service)
- [ ] Implémenter background task iOS (Background Modes + Local Notifications)
- [ ] Configurer permissions Android 12+ (REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
- [ ] Setup flutter_local_notifications + permissions iOS
- [ ] Tester comportement avec écran éteint pendant 30+ minutes

---

### � P2 — v0.2 (Monétisation)

- [ ] Intégration Firebase Analytics
- [ ] Intégration Google AdMob (bannière + interstitiel)
- [ ] Consent GDPR/CCPA (app_tracking_transparency iOS)
- [ ] Presets favoris (UI + storage local)
- [ ] Réglage haptique avancé

---

### 🔵 P3 — v0.3 (Features avancées)

- [ ] Multi-timers simultanés (max 3)
- [ ] Backup cloud (Google Drive/iCloud)
- [ ] Widget home screen (Android/iOS)
- [ ] Mode focus avec DND automatique
- [ ] Sons custom uploadés par utilisateur

---

## 🐛 Bugs connus

### Critiques (empêchent utilisation)

---

### Mineurs (contournables)

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
