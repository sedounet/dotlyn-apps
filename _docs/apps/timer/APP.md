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

### v0.1 — MVP Core (en cours)
**Objectif** : Timer fonctionnel de base, utilisable sans frustration.

- [ ] Interface timer simple : affichage durée + play/pause/reset
- [ ] Sélection durée (saisie numérique ex: 10552 = 1h05mn52s ou 1:05:52)
- [ ] Son de fin (1 son par défaut)
- [ ] Vibration de fin
- [ ] Page settings minimale (son on/off, vibration on/off)

**Critère de succès** : Timer utilisable pour des tâches courtes (5-30 min) avec l'app au premier plan.

**Tech** : Shared preferences pour settings, basic timer avec Ticker.

---

### v0.2 — Background Service (MVP complet)
**Objectif** : Timer fiable en arrière-plan, notification de fin.

- [ ] Background service Android (Foreground Service)
- [ ] Background task iOS (Background Modes + Local Notifications)
- [ ] Permissions Android 12+ (POST_NOTIFICATIONS, Foreground Service)
- [ ] Notification persistante pendant le timer (Android)
- [ ] Notification de fin de session (iOS/Android)
- [ ] Sons configurables (2-3 choix simples)
- [ ] Page settings : choix du son

**Critère de succès** : Timer fonctionne avec écran éteint pendant 30+ min (cuisine, méditation).

**Tech** : `flutter_local_notifications`, `workmanager` (Android), Background Modes (iOS).

**⚠️ Débloqueur technique MVP** : Sans cette version, l'app n'a pas de valeur.

---

### v0.3 — Monétisation & UX (Post-MVP)
**Objectif** : Stabiliser le modèle économique et améliorer l'ergonomie.

- [ ] Firebase Analytics (événements : timer_start, timer_complete, settings_changed)
- [ ] Google AdMob : bannière en bas de l'écran d'accueil
- [ ] Possibilité de support par video ads (optionnel, rewarded ad)
- [ ] Système de favoris (presets) : durées fréquentes (ex: 5min, 15min, 30min)
- [ ] Storage local des presets (shared_preferences ou Hive)
- [ ] Réglage retour haptique avancé (intensité : légère/moyenne/forte)
- [ ] Consent GDPR/CCPA (app_tracking_transparency iOS)

**Critère de succès** : Génération de revenus publicitaires + UX optimisée (presets).

**Tech** : Firebase, AdMob SDK, consent management.

---

### v0.4 — Multi-timers & Cloud
**Objectif** : Permettre plusieurs timers simultanés et sauvegarder les données.

- [ ] Multi-timers simultanés (max 3)
- [ ] UI : liste des timers actifs avec statut (running/paused)
- [ ] Notifications multiples (1 par timer)
- [ ] Backup cloud des presets (Google Drive/iCloud)
- [ ] Sync automatique des favoris entre devices
- [ ] Widget home screen (Android/iOS) : affiche le timer en cours

**Critère de succès** : Utilisateurs peuvent lancer 2-3 timers en parallèle (ex: cuisine + lessive).

**Tech** : Gestion d'état avancée (Provider/Riverpod), cloud storage API.

---

### v0.5 — Features Premium
**Objectif** : Mode focus et personnalisation avancée.

- [ ] Mode focus avec DND automatique (Android/iOS)
- [ ] Sons custom uploadés par utilisateur (ou depuis bibliothèque)
- [ ] Thèmes custom (dark mode amélioré, couleurs personnalisables)
- [ ] Statistiques d'utilisation (temps total, timers complétés)
- [ ] Export des stats (CSV/PDF)
- [ ] Mode "strict" : impossibilité de pause (optionnel)

**Critère de succès** : Fonctionnalités premium pour utilisateurs avancés.

**Tech** : File picker, custom theme engine, stats database (SQLite/Hive).

---

### v0.6 — Extensions & Intégrations
**Objectif** : Catégories, interfaces avancées, intégrations tierces.

- [ ] Système de catégories de timers (cuisine, sport, méditation, travail)
- [ ] Passage sur BDD locale robuste (SQLite ou Hive)
- [ ] Migration automatique depuis shared_preferences (transparente pour l'utilisateur)
- [ ] Interfaces supplémentaires pour affichage timer :
  - Compte à rebours visuel (progress bar circulaire)
  - Timer circulaire animé
  - Mode "flip clock" (style rétro)
- [ ] Interfaces supplémentaires pour réglage durée :
  - Sélecteur horlogique (type horloge analogique)
  - Slider circulaire
  - Input clavier direct (ex: "25m")
- [ ] Intégration calendrier (optionnel) : créer des timers depuis des événements
- [ ] API publique pour intégrations tierces (ex: Shortcuts iOS, Tasker Android)

**Critère de succès** : App mature avec options avancées pour power users.

**Tech** : SQLite (sqflite), custom painters pour UI, Shortcuts API (iOS), Intents (Android).

## 📝 TODO

### 🔴 P1 — v0.1 (MVP Core - EN COURS)

- [ ] Créer UI timer simple (durée, play/pause/reset)
- [ ] Implémenter logique timer de base (Ticker)
- [ ] Ajouter picker/slider pour sélection durée
- [ ] Son + vibration de fin
- [ ] Page settings minimale (toggle son/vibration)
- [ ] Tests manuels sur émulateur

**Deadline** : À définir  
**Bloqueurs** : Aucun

---

### 🔴 P1 — v0.2 (Background Service - CRITIQUE)

- [ ] Implémenter Foreground Service Android
- [ ] Implémenter Background Modes iOS
- [ ] Setup flutter_local_notifications
- [ ] Permissions Android 12+ (POST_NOTIFICATIONS, Foreground Service)
- [ ] Notification persistante (Android) pendant timer
- [ ] Notification de fin (iOS + Android)
- [ ] Choix de sons (2-3 options)
- [ ] Tester avec écran éteint 30+ min (devices réels requis)

**Deadline** : À définir  
**Bloqueurs** : Devices physiques nécessaires pour tests background  
**⚠️ Sans cette version, l'app est inutilisable en conditions réelles**

---

### 🟡 P2 — v0.3 (Monétisation)

- [ ] Firebase setup (iOS + Android)
- [ ] Analytics : événements timer_start, timer_complete, settings_changed
- [ ] AdMob SDK + bannière
- [ ] Rewarded video ads (optionnel)
- [ ] Consent GDPR/CCPA
- [ ] UI presets favoris
- [ ] Storage presets (shared_preferences)
- [ ] Réglage haptique intensité

**Deadline** : Post v0.2 stabilisée

---

### 🔵 P3 — v0.4+ (Features avancées)

- [ ] Multi-timers (v0.4)
- [ ] Backup cloud (v0.4)
- [ ] Widget home screen (v0.4)
- [ ] Mode focus + DND (v0.5)
- [ ] Sons custom (v0.5)
- [ ] Stats d'utilisation (v0.5)
- [ ] Catégories + BDD SQLite (v0.6)
- [ ] Interfaces timer avancées (v0.6)

**Deadline** : Long terme

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
