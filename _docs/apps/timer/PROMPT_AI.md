# PROMPT AI — Implémentation Foreground Service pour Timer Dotlyn

## 🎯 Objectif
Implémenter un système de notification/alarme **100% fiable** pour le timer Dotlyn, garantissant que la sonnerie et la vibration fonctionnent **dans tous les cas** (app en arrière-plan, écran éteint, app tuée, mode silence).

---

## 📋 Contexte Technique

### Architecture actuelle
- **App** : `apps/timer/` (Flutter)
- **Services partagés** : `packages/dotlyn_core/lib/services/`
  - `alarm_service.dart` : AlarmManager Android (callback top-level)
  - `notification_service.dart` : Notifications locales Flutter
- **Provider** : `apps/timer/lib/providers/timer_provider.dart`

### Problème identifié
- Les notifications locales ne garantissent pas la sonnerie/vibration si l'app est tuée ou le téléphone en mode économie d'énergie.
- Sur iOS, pas de solution native pour garantir la sonnerie (limitation Apple).
- Besoin d'une solution **fiable à 100%** pour Android, et **maximale** pour iOS.

---

## 🚀 Solution à Implémenter

### Android : Foreground Service Natif (Kotlin)

#### Étape 1 : Créer le Foreground Service
**Fichier** : `apps/timer/android/app/src/main/kotlin/com/dotlyn/timer/TimerForegroundService.kt`

**Fonctionnalités** :
- Démarre au lancement du timer (depuis Flutter via MethodChannel).
- Affiche une notification persistante : "Timer en cours : 05:00" (mise à jour chaque seconde).
- À la fin du timer, joue la sonnerie embarquée (`assets/sounds/dingding.mp3`) en boucle.
- Active la vibration (pattern personnalisé) en boucle.
- L'utilisateur arrête le service via notification action ("Arrêter") ou en ouvrant l'app.
- Le service s'arrête automatiquement après arrêt manuel.

**Permissions nécessaires** (déjà présentes) :
- `FOREGROUND_SERVICE`
- `FOREGROUND_SERVICE_MEDIA_PLAYBACK`
- `POST_NOTIFICATIONS`
- `VIBRATE`
- `WAKE_LOCK`

**Code à inclure** :
```kotlin
class TimerForegroundService : Service() {
    private var mediaPlayer: MediaPlayer? = null
    private var vibrator: Vibrator? = null
    private var isRunning = false
    private var remainingSeconds = 0
    private val handler = Handler(Looper.getMainLooper())

    companion object {
        const val ACTION_START = "com.dotlyn.timer.START"
        const val ACTION_STOP = "com.dotlyn.timer.STOP"
        const val ACTION_COMPLETE = "com.dotlyn.timer.COMPLETE"
        const val EXTRA_DURATION = "duration"
        const val CHANNEL_ID = "timer_foreground_channel"
        const val NOTIFICATION_ID = 1
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> startTimer(intent.getIntExtra(EXTRA_DURATION, 0))
            ACTION_COMPLETE -> completeTimer()
            ACTION_STOP -> stopSelf()
        }
        return START_STICKY
    }

    private fun startTimer(durationSeconds: Int) {
        remainingSeconds = durationSeconds
        isRunning = true
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, buildNotification("Timer en cours : ${formatTime(remainingSeconds)}"))
        updateTimerNotification()
    }

    private fun updateTimerNotification() {
        if (!isRunning) return
        
        if (remainingSeconds > 0) {
            val notification = buildNotification("Timer en cours : ${formatTime(remainingSeconds)}")
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.notify(NOTIFICATION_ID, notification)
            remainingSeconds--
            handler.postDelayed({ updateTimerNotification() }, 1000)
        } else {
            completeTimer()
        }
    }

    private fun completeTimer() {
        isRunning = false
        playAlarmSound()
        startVibration()
        val notification = buildNotification("Timer terminé !", true)
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(NOTIFICATION_ID, notification)
    }

    private fun playAlarmSound() {
        try {
            mediaPlayer = MediaPlayer.create(this, R.raw.dingding)
            mediaPlayer?.isLooping = true
            mediaPlayer?.start()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun startVibration() {
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            vibratorManager.defaultVibrator
        } else {
            getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }

        val pattern = longArrayOf(0, 500, 200, 500, 200)
        vibrator?.vibrate(VibrationEffect.createWaveform(pattern, 0))
    }

    private fun buildNotification(text: String, withStopAction: Boolean = false): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_IMMUTABLE)

        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Dotlyn Timer")
            .setContentText(text)
            .setSmallIcon(R.drawable.ic_timer)
            .setContentIntent(pendingIntent)
            .setOngoing(!withStopAction)
            .setPriority(NotificationCompat.PRIORITY_HIGH)

        if (withStopAction) {
            val stopIntent = Intent(this, TimerForegroundService::class.java).apply {
                action = ACTION_STOP
            }
            val stopPendingIntent = PendingIntent.getService(this, 0, stopIntent, PendingIntent.FLAG_IMMUTABLE)
            builder.addAction(R.drawable.ic_stop, "Arrêter", stopPendingIntent)
        }

        return builder.build()
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Timer Foreground Service",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Affiche le timer en cours et l'alarme de fin"
            setSound(null, null)
        }
        val notificationManager = getSystemService(NotificationManager::class.java)
        notificationManager.createNotificationChannel(channel)
    }

    private fun formatTime(seconds: Int): String {
        val hours = seconds / 3600
        val minutes = (seconds % 3600) / 60
        val secs = seconds % 60
        return String.format("%02d:%02d:%02d", hours, minutes, secs)
    }

    override fun onDestroy() {
        super.onDestroy()
        isRunning = false
        mediaPlayer?.stop()
        mediaPlayer?.release()
        vibrator?.cancel()
        handler.removeCallbacksAndMessages(null)
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
```

**AndroidManifest.xml** (ajout) :
```xml
<service
    android:name=".TimerForegroundService"
    android:enabled="true"
    android:exported="false"
    android:foregroundServiceType="mediaPlayback" />
```

---

#### Étape 2 : MethodChannel Flutter -> Kotlin
**Fichier** : `apps/timer/android/app/src/main/kotlin/com/dotlyn/timer/MainActivity.kt`

**Ajouter** :
```kotlin
class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.dotlyn.timer/foreground"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startForegroundService" -> {
                    val duration = call.argument<Int>("duration") ?: 0
                    startTimerService(duration)
                    result.success(null)
                }
                "stopForegroundService" -> {
                    stopTimerService()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startTimerService(durationSeconds: Int) {
        val intent = Intent(this, TimerForegroundService::class.java).apply {
            action = TimerForegroundService.ACTION_START
            putExtra(TimerForegroundService.EXTRA_DURATION, durationSeconds)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    private fun stopTimerService() {
        val intent = Intent(this, TimerForegroundService::class.java)
        stopService(intent)
    }
}
```

---

#### Étape 3 : Service Flutter (Dart)
**Fichier** : `packages/dotlyn_core/lib/services/foreground_service.dart`

```dart
import 'package:flutter/services.dart';

class ForegroundService {
  static const platform = MethodChannel('com.dotlyn.timer/foreground');

  static Future<void> startTimer(int durationSeconds) async {
    try {
      await platform.invokeMethod('startForegroundService', {
        'duration': durationSeconds,
      });
    } on PlatformException catch (e) {
      print("Erreur foreground service: ${e.message}");
    }
  }

  static Future<void> stopTimer() async {
    try {
      await platform.invokeMethod('stopForegroundService');
    } on PlatformException catch (e) {
      print("Erreur arrêt foreground service: ${e.message}");
    }
  }
}
```

**Export** dans `packages/dotlyn_core/lib/dotlyn_core.dart` :
```dart
export 'services/foreground_service.dart';
```

---

#### Étape 4 : Intégration dans TimerProvider
**Fichier** : `apps/timer/lib/providers/timer_provider.dart`

**Modifier la méthode `start()`** :
```dart
void start() async {
  if (_duration.inSeconds == 0) return;

  _remaining = _duration;
  _isRunning = true;
  notifyListeners();

  // Démarrer le foreground service (Android uniquement)
  if (Platform.isAndroid) {
    await ForegroundService.startTimer(_duration.inSeconds);
  } else {
    // iOS : notification locale programmée
    await NotificationService.scheduleTimerNotification(_duration);
  }

  // Démarrer le ticker UI
  _ticker?.cancel();
  _ticker = Ticker((elapsed) {
    _remaining = _duration - elapsed;
    if (_remaining.isNegative) {
      _remaining = Duration.zero;
      stop();
    }
    notifyListeners();
  });
  _ticker!.start();
}
```

**Modifier la méthode `stop()`** :
```dart
void stop() async {
  _isRunning = false;
  _ticker?.stop();
  notifyListeners();

  // Arrêter le foreground service
  if (Platform.isAndroid) {
    await ForegroundService.stopTimer();
  }

  // Afficher le dialog de fin si timer terminé
  if (_remaining.inSeconds == 0) {
    _showCompletionDialog = true;
    notifyListeners();
  }
}
```

---

### iOS : Notification Locale (Fallback)

**Fichier** : `packages/dotlyn_core/lib/services/notification_service.dart`

**Ajouter une méthode pour iOS** :
```dart
static Future<void> scheduleTimerNotification(Duration duration) async {
  if (!Platform.isIOS) return;

  const iOSDetails = DarwinNotificationDetails(
    sound: 'dingding.aiff', // Son embarqué dans le bundle iOS
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const details = NotificationDetails(iOS: iOSDetails);

  await _notifications.zonedSchedule(
    1,
    'Timer terminé !',
    'Votre timer Dotlyn est terminé.',
    tz.TZDateTime.now(tz.local).add(duration),
    details,
    androidScheduleMode: AndroidScheduleMode.exact,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}
```

**Ajouter le son dans iOS** :
- Placer `dingding.aiff` dans `apps/timer/ios/Runner/Resources/`.
- Ajouter dans `Info.plist` (si nécessaire).

---

## ✅ Critères de Validation

### Tests Android
- [ ] Timer démarre → notification persistante visible
- [ ] Écran éteint → notification persistante reste active
- [ ] App tuée (swipe) → service reste actif, notification persistante
- [ ] Timer terminé → sonnerie + vibration jouées en boucle
- [ ] Bouton "Arrêter" → service s'arrête, sonnerie/vibration stoppées
- [ ] Mode silence → sonnerie et vibration jouées quand même
- [ ] Mode économie d'énergie → service reste actif

### Tests iOS
- [ ] Timer démarre → notification programmée
- [ ] App tuée → notification apparaît à la fin du timer
- [ ] Mode silence → notification visible, son peut ne pas être joué (limité par Apple)
- [ ] Informer l'utilisateur des limites iOS dans l'app

---

## 📝 Documentation Utilisateur

Ajouter dans l'app (écran Settings ou première utilisation) :

**Android** :
> "Pour garantir la fiabilité du timer, une notification persistante sera affichée pendant l'exécution. Vous pouvez l'arrêter à tout moment."

**iOS** :
> "En raison des restrictions Apple, la sonnerie peut ne pas être jouée si l'app est fermée ou le mode silence activé. Pour une fiabilité maximale, gardez l'app ouverte."

---

## 🎯 Prochaines Étapes

1. Implémenter le foreground service Android (Kotlin).
2. Ajouter le MethodChannel et intégrer dans `TimerProvider`.
3. Tester sur plusieurs modèles Android (Samsung, Pixel, Xiaomi, etc.).
4. Implémenter la notification locale iOS avec son embarqué.
5. Tester sur iOS (iPhone 12+, iOS 15+).
6. Documenter les limites dans l'app et la doc technique.
7. Commit et push : `[timer] feat: add foreground service for reliable alarm (Android) + local notification (iOS)`.

---

**Note** : Cette solution garantit la **fiabilité maximale** sur Android (foreground service) et la **meilleure expérience possible** sur iOS (notification locale avec son embarqué), tout en respectant les contraintes des OS.
