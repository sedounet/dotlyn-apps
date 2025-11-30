# Prompt Technique : Fix Timer avec AlarmManager Pur

> **Contexte** : Le timer s'arrête quand l'écran est éteint car il utilise `Timer.periodic` (Dart). On bascule sur AlarmManager pur (système Android).  
> **Date** : 2025-11-30  
> **Cible** : Android (iOS aura limitations acceptées)

---

## 🎯 Objectif

Corriger le timer pour qu'il soit **100% fiable** en utilisant UNIQUEMENT AlarmManager :
1. **Supprimer** le `Timer.periodic` (Dart) qui s'arrête avec l'app
2. **Garder** uniquement `AlarmManager` qui fonctionne même si app tuée
3. **Utiliser** les sonneries système (pas de fichiers audio custom)
4. **Simplifier** l'architecture (moins de code, plus fiable)

---

## 🐛 Problème Actuel

Dans `apps/timer/lib/providers/timer_provider.dart`, la méthode `start()` fait :

```dart
void start(Duration duration) {
  // ...
  
  // ❌ PROBLÈME : Timer.periodic en Dart (s'arrête si app fermée)
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_remaining.inSeconds > 0) {
      _remaining = Duration(seconds: _remaining.inSeconds - 1);
      notifyListeners();
    } else {
      _timer?.cancel();
      _onTimerComplete();
    }
  });
  
  // ✅ OK : AlarmManager système (fonctionne même si app fermée)
  AlarmService.scheduleTimer(_remaining);
}
```

**Le souci** : On a DEUX systèmes qui tournent en parallèle, mais seul AlarmManager est fiable.

---

## 📋 Tâches à Réaliser

### 1. Modifier TimerProvider pour Supprimer Timer.periodic

**Fichier** : `apps/timer/lib/providers/timer_provider.dart`

**Changements** :

```dart
void start(Duration duration) {
  _duration = duration;
  _remaining = duration;
  _status = TimerStatus.running;
  _errorMessage = null;
  _startTime = DateTime.now(); // NOUVEAU : stocker l'heure de départ

  // Programmer l'alarme système
  AlarmService.scheduleTimer(_remaining);

  // SUPPRIMER Timer.periodic, utiliser juste un timer pour l'UI
  _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
    // Calculer le temps restant basé sur l'heure réelle
    final elapsed = DateTime.now().difference(_startTime);
    final newRemaining = _duration - elapsed;
    
    if (newRemaining.inSeconds >= 0) {
      _remaining = newRemaining;
      notifyListeners();
    } else {
      // Le timer devrait être fini, mais AlarmManager gère la notification
      _timer?.cancel();
      _status = TimerStatus.idle;
      notifyListeners();
    }
  });

  notifyListeners();
}
```

**Ajouter une variable d'instance** :
```dart
DateTime _startTime = DateTime.now();
```

### 2. Simplifier le Callback AlarmManager

**Fichier** : `packages/dotlyn_core/lib/services/alarm_service.dart`

Le callback est déjà correct, juste s'assurer qu'il est bien minimal :

```dart
@pragma('vm:entry-point')
Future<void> fireTimerAlarm() async {
  // Android : ce code s'exécute au réveil, même si l'app est tuée
  await NotificationService.showTimerComplete();
}
```

### 3. Vérifier NotificationService (Sonnerie Système)

**Fichier** : `packages/dotlyn_core/lib/services/notification_service.dart`

Le code actuel est bon, juste confirmer :

```dart
static Future<void> showTimerComplete() async {
  const androidDetails = AndroidNotificationDetails(
    'timer_complete',
    'Timer',
    channelDescription: 'Notifications when timer completes',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    ticker: 'timer',
    category: AndroidNotificationCategory.alarm,
    audioAttributesUsage: AudioAttributesUsage.alarm, // SON SYSTÈME ALARME
  );
  
  const iosDetails = DarwinNotificationDetails(
    presentSound: true,
  );
  
  const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

  await _plugin.show(1, 'Timer terminé !', 'Votre timer est terminé', details,
      payload: 'timer_complete');
}
```

### 4. Supprimer les Notifications "En Cours" (Optionnel)

Si tu veux simplifier encore plus, supprimer les appels à `NotificationService.showTimerRunning()` dans `TimerProvider` :

```dart
// SUPPRIMER ces lignes :
NotificationService.showTimerRunning(_remaining);
```

On garde juste la notification finale quand le timer se termine

---

## ✅ Critères de Validation

### Tests Obligatoires
1. **T1** : Timer 30s, écran éteint → doit continuer et sonner
2. **T2** : Timer 1min, app en arrière-plan → doit continuer et sonner
3. **T3** : Timer 2min, app tuée (swipe) → doit sonner quand même
4. **T4** : Notification persistante visible pendant le timer
5. **T5** : Bouton "Arrêter" dans la notification fonctionne
6. **T6** : Son d'alarme système (pas média) utilisé

### Comportement Attendu

**Android** :
- ✅ Notification persistante "Timer en cours : 00:05:23" (non supprimable)
- ✅ Timer continue avec écran éteint
- ✅ Timer continue avec app en arrière-plan
- ✅ Son système d'alarme à la fin (fort, même en mode silencieux)

**iOS** :
- ⚠️ Notification visible mais timer s'arrête si app tuée (limitation iOS)
- ✅ Timer continue avec app en arrière-plan
- ✅ Son de notification iOS à la fin

---

## 🔧 Architecture Finale

```
Timer Démarre
    ↓
Foreground Service Lancé
    ↓
Notification Persistante Affichée
    ↓
Timer Compte (1s/1s)
    ↓
Mise à Jour Notification (temps restant)
    ↓
Timer Terminé
    ↓
Notification "Timer terminé!" + Son Système Alarme
    ↓
Service Arrêté
```

---

## 📝 Notes Importantes

1. **Pas de son custom** : On utilise la sonnerie d'alarme configurée dans les paramètres Android de l'utilisateur
2. **Trade-off accepté** : Notification persistante visible (comme Chronomètre Google)
3. **iOS limité** : Pas de garantie si app tuée (limites Apple)
4. **Fiabilité > Esthétique** : Priorité à la robustesse

---

## 🐛 Points d'Attention

- Le foreground service doit être initialisé AVANT le premier démarrage du timer
- La notification persistante est obligatoire (Android 8+)
- Tester sur plusieurs versions Android (8, 10, 12, 14)
- Vérifier que l'optimisation batterie ne tue pas le service

---

**Version** : 1.0  
**Date** : 2025-11-30  
**Exécution** : GPT-4o
---

## ✅ Critères de Validation

### Tests Essentiels (3 tests suffisent)

1. **T1 - Écran éteint** : Timer 1min, éteindre l'écran → doit sonner à la fin
2. **T2 - App en arrière-plan** : Timer 1min, ouvrir une autre app → doit sonner à la fin  
3. **T3 - App tuée** : Timer 2min, fermer l'app (swipe) → doit sonner à la fin

### Comportement Attendu

**Android** :
- ✅ Timer continue avec écran éteint (AlarmManager gère)
- ✅ Timer continue avec app en arrière-plan (AlarmManager gère)
- ✅ Timer continue avec app tuée (AlarmManager réveille l'app)
- ✅ Son système d'alarme à la fin (fort, même en mode silencieux)
- ✅ Pas de notification pendant le timer (juste à la fin)

**iOS** :
- ⚠️ Timer s'arrête si app tuée (limitation iOS - comportement attendu)
- ✅ Timer continue avec app en arrière-plan
- ✅ Son de notification iOS à la fin

---

## 🔧 Architecture Simplifiée

```
User démarre timer 5 minutes
    ↓
AlarmManager.scheduleTimer(5min) → Programme alarme système
    ↓
Timer.periodic (UI seulement) → Affiche le décompte dans l'app
    ↓
[5 minutes passent, app peut être fermée]
    ↓
AlarmManager déclenche fireTimerAlarm()
    ↓
NotificationService.showTimerComplete() → Son système + notification
```

**Simple et fiable** : L'OS Android garantit que l'alarme sonne.

---

## 📝 Notes Importantes

1. **Pas de son custom** : On utilise la sonnerie d'alarme système (configurée dans les paramètres Android)
2. **Pas de notification pendant** : Juste une notification à la fin
3. **iOS limité** : Accepter que ça ne marche pas si app tuée (limites Apple)
4. **AlarmManager = fiabilité** : Le système gère, pas notre app

---

## 🐛 Points d'Attention

- AlarmManager nécessite la permission `SCHEDULE_EXACT_ALARM` (déjà configurée)
- Le callback `fireTimerAlarm()` doit être top-level avec `@pragma('vm:entry-point')`
- Sur Android 12+, l'utilisateur peut avoir besoin d'autoriser les alarmes exactes dans les paramètres système
- Tester sur Android 8+ minimum