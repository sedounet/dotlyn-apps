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

## 📦 Architecture proposée (simple)

```
1. Package flutter_local_notifications
   - Affichage notifications simples
   - Support Android/iOS out-of-the-box
   
2. Service NotificationService (dans dotlyn_core)
   - showTimerRunning(remaining)
   - showTimerComplete()
   - cancelAll()
   
3. Background Timer (dans timer_provider.dart)
   - Isolate ou WorkManager ? → **Isolate + Timer natif Dart** (plus simple)
   - Update notification chaque seconde (ou chaque 5s pour économie)
```

---

## 🔧 Plan d'implémentation par étapes

### **Étape 1 : Setup flutter_local_notifications**

**Fichiers à modifier :**
- `packages/dotlyn_core/pubspec.yaml` : ajouter `flutter_local_notifications: ^17.0.0`
- `apps/timer/android/app/src/main/AndroidManifest.xml` : ajouter permissions

**Actions :**
1. Ajouter la dépendance
2. Configurer les permissions Android :
   ```xml
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   <uses-permission android:name="android.permission.VIBRATE"/> (déjà fait)
   <uses-permission android:name="android.permission.WAKE_LOCK"/> (si besoin)
   ```
3. Initialiser le plugin dans `main.dart`

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

### **Étape 4 : Background execution (Android Foreground Service)**

**Objectif :** Timer continue en arrière-plan

**Solution simple :**
- Utiliser `flutter_local_notifications` avec `startForeground` (Android)
- Pas besoin de WorkManager pour un timer continu
- Le timer Dart continue de tourner si app en background grâce au Foreground Service

**Modifications :**
1. Configurer notification en mode "foreground" (priority high, ongoing=true)
2. Démarrer service au start du timer
3. Stopper service à la fin/reset

**Fichiers Android natifs (si nécessaire) :**
- `android/app/src/main/AndroidManifest.xml` : déclarer foreground service

**Test :** Lancer timer, éteindre écran → timer continue, notification mise à jour

---

### **Étape 5 : iOS Background Modes (optionnel, plus tard)**

**Pour v0.2 : focus Android uniquement**
iOS a des limitations strictes sur le background. On peut implémenter plus tard avec :
- Background Modes (audio, fetch)
- Local notifications uniquement

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

| Étape | Test                                      | Résultat attendu                          |
|-------|-------------------------------------------|-------------------------------------------|
| 1     | Notification test au lancement            | Notification visible                      |
| 2     | Bouton "Test notif" → showTimerComplete() | Notification "Timer terminé" visible      |
| 3     | Timer 10s, app en background              | Notification affiche temps restant        |
| 4     | Timer 30s, écran éteint                   | Timer termine, notification finale        |
| 6     | Clic notification terminée                | App s'ouvre                               |
| 7     | Clic "Pause" dans notification            | Timer se met en pause                     |

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

❌ Utiliser WorkManager pour un timer continu (overkill, énergie)
❌ Polling serveur ou base de données
❌ Implémenter un service natif Android complet (trop complexe)
❌ Sur-optimiser avant que ça marche
❌ Faire iOS en même temps qu'Android (séparé v0.2.1)

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

