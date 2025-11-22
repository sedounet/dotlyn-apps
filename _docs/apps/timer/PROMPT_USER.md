# Instructions : Implémentation des notifications pour le Timer (v0.2)

## 🎯 Objectif

Implémenter un système de notifications pour que le timer continue de fonctionner en arrière-plan (écran éteint, app en background) et notifie l'utilisateur quand le temps est écoulé.

---

## 📋 Contexte technique

**App actuelle (v0.1) :**
- Timer fonctionne uniquement au premier plan
- Son + vibration en boucle à la fin
- Settings : toggle son/vibration
- Code dans `apps/timer/`

**Packages déjà installés :**
- `audioplayers: ^5.2.1`
- `vibration: ^3.1.4`
- `shared_preferences: ^2.3.3`
- `provider: ^6.1.0`

---

## 🎯 Résultat attendu

### Comportement souhaité :

1. **Timer en cours :**
   - Notification persistante affichée (Android : Foreground Service)
   - Notification montre : temps restant + boutons Pause/Stop
   - Timer continue même si app fermée/écran éteint

2. **Timer terminé :**
   - Notification "Timer terminé !" (avec son système)
   - Si app ouverte : dialog + son/vibration en boucle (existant)
   - Si app fermée : notification cliquable → ouvre app

3. **Permissions Android :**
   - POST_NOTIFICATIONS (Android 13+)
   - Foreground Service
   - Wake Lock si nécessaire

---

## ⚠️ Contraintes importantes

- **Simplicité** : Pas de sur-ingénierie, solution la plus simple qui marche
- **Énergie** : Éviter les polling constants, utiliser les mécanismes natifs
- **Debug** : Étapes séparées, testables une par une
- **Réutilisable** : Service dans `dotlyn_core` si possible (pour Pomodoro, Tabata...)

---

## 📦 Architecture proposée (multi-plateforme)

```
1. Packages multi-plateforme
   - android_alarm_manager_plus : alarme Android native (économie batterie)
   - flutter_local_notifications : notifications Android + iOS
   - Code partagé avec Platform.isAndroid / Platform.isIOS
   
2. Service AlarmService (dans dotlyn_core)
   - scheduleTimer(duration) : Android AlarmManager / iOS notification programmée
   - cancelTimer() : annule alarme/notification
   - Platform checks intégrés dans le service
   
3. Service NotificationService (dans dotlyn_core)
   - showTimerRunning(remaining)
   - showTimerComplete()
   - cancelAll()
```

**⚠️ Stratégie multi-plateforme :**

**Android (AlarmManager) :**
- ✅ Vraie alarme système (comme un réveil)
- ✅ Fonctionne app tuée/fermée
- ✅ Très économe batterie
- ✅ Son + vibration en boucle au réveil

**iOS (Notification programmée) :**
- ✅ Notification apparaît au bon moment
- ✅ Code compatible sans Mac (test plus tard)
- ⚠️ Limitation : son joue 1 fois (pas de boucle)
- ⚠️ App ne se réveille pas automatiquement

**Workflow dev sans Mac :**
1. Code avec Platform checks dès le début
2. Test Android sur device physique
3. Code iOS dormant jusqu'à accès Mac/CI

---

## 🔧 Plan d'implémentation par étapes

### **Étape 1 : Setup packages**

**Fichiers à modifier :**
- `apps/timer/pubspec.yaml` : ajouter les dépendances
- `apps/timer/android/app/src/main/AndroidManifest.xml` : ajouter permissions

**Dépendances à ajouter :**
```yaml
android_alarm_manager_plus: ^4.0.3
flutter_local_notifications: ^17.0.0
```

**Permissions Android :**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.VIBRATE"/> (déjà fait)
```

**iOS Info.plist :**
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
</array>
```

**Actions :**
1. Ajouter les dépendances
2. `flutter pub get`
3. Configurer les permissions
4. Initialiser `flutter_local_notifications` dans `main.dart`

**Test :** Afficher une notification test au lancement de l'app

---

### **Étape 2 : Créer NotificationService (simple)**

**Nouveau fichier :** `packages/dotlyn_core/lib/services/notification_service.dart`

**Méthodes nécessaires :**
```dart
class NotificationService {
  // Init
  Future<void> initialize()
  
  // Notifications timer
  Future<void> showTimerRunning(Duration remaining)
  Future<void> showTimerComplete()
  Future<void> cancelAll()
  
  // Request permissions (Android 13+)
  Future<bool> requestPermissions()
}
```

**Test :** Appeler `showTimerComplete()` depuis un bouton → notification apparaît

---

### **Étape 3 : Intégrer dans TimerProvider (notifications uniquement)**

**Fichier :** `apps/timer/lib/providers/timer_provider.dart`

**Modifications :**
1. Ajouter `NotificationService _notificationService`
2. Appeler `showTimerRunning()` toutes les 5 secondes pendant le timer
3. Appeler `showTimerComplete()` quand timer fini
4. Appeler `cancelAll()` quand reset/stop

**⚠️ À ce stade, le timer s'arrête encore en arrière-plan (OK, on teste juste les notifs)**

**Test :** Lancer timer, mettre app en background → notification visible avec temps restant

---

### **Étape 4 : AlarmService multi-plateforme**

**Objectif :** Timer continue même si app tuée/fermée (Android) ou notification programmée (iOS)

**Fichier à créer :** `packages/dotlyn_core/lib/services/alarm_service.dart`

**Structure multi-plateforme :**
```dart
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Callback top-level ANDROID (OBLIGATOIRE, hors classe)
@pragma('vm:entry-point')
void fireTimerAlarm() {
  // Android : ce code s'exécute au réveil
  AudioService.playTimerComplete(loop: true);
  NotificationService.showTimerComplete();
}

class AlarmService {
  static Future<void> scheduleTimer(Duration duration) async {
    if (Platform.isAndroid) {
      await AndroidAlarmManager.initialize();
      await AndroidAlarmManager.oneShotAt(
        DateTime.now().add(duration),
        0,
        fireTimerAlarm,
        exact: true,
        wakeup: true,
      );
    } else if (Platform.isIOS) {
      // iOS : notification programmée simple
      await NotificationService.scheduleTimerComplete(duration);
    }
  }
  
  static Future<void> cancelTimer() async {
    if (Platform.isAndroid) {
      await AndroidAlarmManager.cancel(0);
    } else if (Platform.isIOS) {
      await NotificationService.cancelAll();
    }
  }
}

// Dans TimerProvider :
void start() {
  AlarmService.scheduleTimer(_remainingDuration);
  // + timer local pour UI
}
```

**Test Android :** 
1. Lancer timer 2min
2. Fermer complètement l'app (swipe dans recents)
3. Attendre 2min
4. Android réveille l'app → son + notification !

**Test iOS (plus tard avec Mac) :**
1. Lancer timer 2min
2. Fermer app
3. Attendre 2min
4. Notification apparaît (son 1 fois)

---

### **Étape 5 : NotificationService.scheduleTimerComplete() pour iOS**

**Objectif :** Programmer notification iOS qui apparaît au bon moment

**Ajouter dans NotificationService :**
```dart
Future<void> scheduleTimerComplete(Duration duration) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    1,
    'Timer terminé !',
    'Votre timer est terminé',
    tz.TZDateTime.now(tz.local).add(duration),
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}
```

**Test :** Code compilable sur iOS (test fonctionnel nécessite Mac)

---

### **Étape 6 : Notifications cliquables**

**Objectif :** Cliquer sur notification → ouvre l'app

**Actions :**
1. Configurer `onDidReceiveNotificationResponse` dans `flutter_local_notifications`
2. Router vers `TimerScreen` au clic

**Test :** Cliquer sur notification "Timer terminé" → app s'ouvre

---

### **Étape 7 : Boutons dans notification (Android)**

**Objectif :** Pause/Stop depuis la notification

**Actions :**
1. Ajouter actions dans `AndroidNotificationDetails`
2. Gérer les callbacks dans `NotificationService`
3. Appeler `TimerProvider.pause()` / `reset()` depuis les actions

**Test :** Cliquer "Pause" dans notification → timer se met en pause

---

### **Étape 8 : Optimisation énergie**

**Actions :**
- Update notification toutes les 5s au lieu de 1s (économie CPU)
- Utiliser `setOngoing(true)` pour éviter dismiss accidentel
- Tester sur vraie session longue (30min+)

---

## 🧪 Tests à faire à chaque étape

| Étape | Test                                      | Résultat attendu                     |
| ----- | ----------------------------------------- | ------------------------------------ |
| 1     | Notification test au lancement            | Notification visible                 |
| 2     | Bouton "Test notif" → showTimerComplete() | Notification "Timer terminé" visible |
| 3     | Timer 10s, app en background              | Notification affiche temps restant   |
| 4     | Timer 30s, écran éteint                   | Timer termine, notification finale   |
| 6     | Clic notification terminée                | App s'ouvre                          |
| 7     | Clic "Pause" dans notification            | Timer se met en pause                |

---

## 📝 Notes importantes

### Permissions Android 13+ :
```dart
await notificationService.requestPermissions();
```
À appeler au premier lancement ou dans settings.

### Gestion du lifecycle :
- `WidgetsBindingObserver` pour détecter app en foreground/background
- Ajuster le comportement son/vibration selon l'état

### Settings :
- Ajouter toggle "Notifications" dans settings
- Respecter les préférences utilisateur

---

## 🚫 Ce qu'il NE FAUT PAS faire

❌ Utiliser WorkManager (pas adapté pour alarmes précises)
❌ Écrire du code natif Kotlin/Java/Swift (packages le font)
❌ Utiliser seulement Timer Dart (s'arrête en background)
❌ Utiliser flutter_background_service (service continu = batterie)
❌ Polling serveur ou base de données
❌ Sur-optimiser avant que ça marche
❌ Dupliquer code Android/iOS (utiliser Platform checks)

## ⚠️ Pièges connus

**Callback top-level obligatoire :**
- ❌ Callback dans une classe = ne marche pas avec AlarmManager
- ✅ Fonction top-level avec `@pragma('vm:entry-point')`

**Permissions Android 12+ :**
- `SCHEDULE_EXACT_ALARM` requise pour alarmes précises
- Demander explicitement dans les settings si refusée

**Timer continue en local :**
- L'alarme est pour le moment de fin, mais garder aussi le timer local pour l'UI
- Ne pas dépendre uniquement de l'alarme pour l'affichage

**iOS sans Mac :**
- Code iOS compilable mais non testé sans Mac
- Utiliser `if (Platform.isIOS)` pour éviter erreurs Android
- Test iOS possible via CI/CD macOS runner ou accès Mac futur

---

## 📚 Ressources utiles

- [flutter_local_notifications docs](https://pub.dev/packages/flutter_local_notifications)
- [Android Foreground Services](https://developer.android.com/develop/background-work/services/foreground-services)
- Exemple code : [timer notification pattern](https://github.com/MaikuB/flutter_local_notifications/blob/master/flutter_local_notifications/example/)

---

## ✅ Critères de succès v0.2

- [ ] Timer continue en arrière-plan (30min+)
- [ ] Notification affiche temps restant
- [ ] Notification "Timer terminé" fonctionne
- [ ] Son système joue à la fin (même app fermée)
- [ ] Notification cliquable ouvre l'app
- [ ] Testé sur Android 12+ (vraie device)
- [ ] Consommation batterie acceptable

---

**Approche recommandée :** Implémenter étape par étape, tester chaque étape avant de passer à la suivante. Ne pas hésiter à simplifier si une étape bloque.

**Priorité :** Étapes 1-4 (notifications basiques + background) = MVP fonctionnel. Étapes 5-7 = bonus UX 

