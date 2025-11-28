# Timer — Documentation de développement

> **Version actuelle** : 0.1.0 (MVP)  
> **Dernière update** : 2025-11-22  
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

- [x] Interface timer simple : affichage durée + play/pause/reset
- [x] Sélection durée (saisie numérique avec basculement secondes/hhmmss)
  - [x] BottomSheet de saisie avec preview en temps réel
  - [x] Mode secondes (ex: 125 = 2min05s)
  - [x] Mode hhmmss (ex: 12530 = 1h25min30s)
  - [x] Conservation de la valeur au basculement de mode
  - [x] Édition possible en pause
  - [x] Validation et correction automatique des erreurs
- [x] Son de fin (1 son par défaut, boucle infinie jusqu'à arrêt manuel)
- [x] Vibration de fin (pattern personnalisé, boucle infinie synchronisée avec le son)
- [x] Page settings minimale (son on/off, vibration on/off)

**Critère de succès** : Timer utilisable pour des tâches courtes (5-30 min) avec l'app au premier plan.

**Tech** : Shared preferences pour settings, basic timer avec Ticker.

---

### v0.2 — Notifications & Alarmes (EN COURS)
**Objectif** : Timer fiable en arrière-plan, notification de fin.


**Critère de succès** : Timer fonctionne avec écran éteint/app tuée, notification sonore à la fin.

**Tech** : `android_alarm_manager_plus`, `flutter_local_notifications`, permissions Android.

**⚠️ Débloqueur technique MVP** : Sans cette version, l'app n'a pas de valeur.

---

### 🚀 MVP v0.2 — Ce qui sera en production

- Un seul timer simple, durée personnalisable
- Notification locale à la fin du timer (Android/iOS)
- Sonnerie embarquée Dotlyn (1 son par défaut, boucle jusqu’à arrêt manuel)
- Vibration à la fin (pattern Dotlyn)
- Fonctionne en arrière-plan (notification fiable, selon limites OS)
- Page settings minimale (activer/désactiver son/vibration)
- UI sobre, stable, cohérente (Dotlyn styleguide)
- Pas de pub intrusive (aucune ou bannière discrète)
- Communication claire sur les limites OS (fiabilité, background, etc.)
- **Tests et re-tests obligatoires** :
  - Vérifier la sonnerie et le vibreur sur différents modèles
  - Tester en mode silence, vibreur seul, sonnerie seule
  - Tester avec écran éteint, app en arrière-plan, app tuée
  - Réglages dans les settings (son/vibreur activables/désactivables)

---

**🔬 Piste à creuser (v0.2.1 ou v0.3)** :
Architecture hybride AlarmManager + Foreground Service pour sonnerie custom en boucle :

---

### Différences Android / iOS & Contournements

#### Android
- Deux options pour la sonnerie :
  - Sonnerie système (alarme/notification) : fiabilité maximale, jouée même si l’app est tuée, mais peu personnalisable.
  - Son embarqué dans l’app : personnalisation totale, mais fiabilité variable (nécessite que l’app soit réveillée).
- Possibilité d’utiliser un foreground service pour garantir la sonnerie/vibration, au prix d’une notification persistante.
- AlarmManager : économe en énergie, mais fiabilité limitée si l’app est tuée.

#### iOS
- Uniquement son embarqué dans le bundle de l’app (pas d’accès aux sonneries système).
- Notification locale : joue le son si l’app n’est pas tuée et si l’utilisateur n’a pas coupé le son des notifications.
- Pas de foreground service possible, limitations strictes d’Apple sur l’exécution en arrière-plan.

#### Contournements & Possibilités
- Embarquer 3-4 sonneries propres à l’app pour renforcer l’identité Dotlyn et garantir une expérience cohérente sur les deux plateformes.
- Proposer le choix du son dans les paramètres (settings), avec une UI simple.
- Informer l’utilisateur des limites (fiabilité, restrictions OS) dans l’app et la documentation.
- Pour Android, permettre l’utilisation de la sonnerie système en option (pour fiabilité maximale).
- Pour iOS, accepter les limites et privilégier la simplicité.

**Recommandation** : architecture hybride (AlarmManager + foreground service sur Android, notification locale sur iOS), sons embarqués pour l’identité, et communication transparente sur les limites techniques.

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

### 🔴 P1 — v0.2 (Notifications & Alarmes - EN COURS)

- [x] Intégration AlarmManager Android
- [x] Notification "Timer en cours" au démarrage
- [x] Notification "Timer terminé" avec sonnerie système
- [x] Permissions Android 12+ (POST_NOTIFICATIONS, SCHEDULE_EXACT_ALARM, WAKE_LOCK, RECEIVE_BOOT_COMPLETED)
- [x] Tests sur émulateur et device réel
- [ ] Rappel d'app au clic sur notification (à faire)
- [ ] Sons configurables (à faire)
- [ ] Page settings : choix du son (à faire)

**Deadline** : À définir  
**Bloqueurs** : Tests sur device physique requis pour validation finale

---

## ✅ Tests

- [x] Test sur device réel Android 15 (Nothing Phone A015)
- [x] Son en boucle validé
- [x] Vibration en boucle validée
- [x] Arrêt simultané son + vibration validé

---

## 🐛 Bugs connus

### Critiques (empêchent utilisation)

- [x] ~~La saisie de temps ne fonctionne pas : en modifiant le temps puis en cliquant sur Start, le temps par défaut revient.~~ **Corrigé** : Controller initialisé correctement, flag `_isEditing`
- [x] ~~Une fois à zéro, aucun son ne se joue (ni dingding ni pouit).~~ **Corrigé** : Asset path corrigé
- [x] ~~Une fois le timer fini, on ne peut pas remettre un temps ni le reset (il reste à zéro).~~ **Corrigé** : Start utilise duration au lieu de remaining
- [x] ~~Saisie non fluide (controller recréé à chaque build).~~ **Corrigé** : Controller stable + flag `_isEditing`
- [x] ~~Dialog de fin s'ouvre deux fois.~~ **Corrigé** : Flag `_showCompletionDialog` pour éviter les doublons
- [x] ~~Affichage par défaut 00:05:00 au lieu de vide.~~ **Corrigé** : Duration initiale à zéro avec affichage grisé
- [x] ~~Perte de la valeur saisie au basculement secondes/hhmmss.~~ **Corrigé** : Conversion automatique préservant la durée

---

### Mineurs (contournables)

---

## 📊 Analyse Concurrence

### Apps existantes — Points faibles identifiés

#### Google Clock (natif Android) — 3.3/5 ⭐
- Alarmes qui ne sonnent parfois pas (seulement vibration)
- UI changée régulièrement, manque de cohérence
- Plus de clics requis pour activer/sauver une alarme
- Impossible de supprimer toutes les alarmes en une fois

#### Alarm Clock for Me — 4.3/5 ⭐
- **Alarmes non fiables** : alarme sonnée au mauvais moment (raté entretien)
- **Publicités agressives** : vidéo plein écran à 3h du matin
- Bugs critiques : impossible de stopper/snooze sur l'écran
- Alarmes récurrentes cassées après réinstallation

#### Forest (focus timer) — 4.5/5 ⭐
- UI laggy, crashes fréquents
- App se ferme automatiquement sans raison
- Bloque les autres apps mais fiabilité timer en arrière-plan non garantie

### Points faibles récurrents
- **Fiabilité** : alarmes qui ne sonnent pas ou au mauvais moment
- **UX** : UI surchargée, publicités intrusives, changements d'interface fréquents
- **Technique** : crashes, bugs après mises à jour, fonctionnalités cassées

### Opportunités Dotlyn Timer
1. **Fiabilité avant tout** : garantir que le timer sonne (notification + son/vibration fiables)
2. **Simplicité** : un seul timer, pas de sur-fonctionnalités
3. **Pas de pub intrusive** : bannière discrète ou premium sans pub
4. **UI stable** : cohérence visuelle, pas de changements brutaux
5. **Sons embarqués** : identité sonore propre (3-4 sons Dotlyn)
6. **Communication transparente** : informer des limites OS au lieu de promettre l'impossible

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
