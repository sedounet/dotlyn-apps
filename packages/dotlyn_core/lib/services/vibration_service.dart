import 'package:vibration/vibration.dart';

/// Service gérant les vibrations pour les apps Dotlyn
/// Wrapper autour du package `vibration` pour centraliser la logique
class VibrationService {
  bool _isEnabled = true;
  bool? _hasVibrator;
  bool? _hasAmplitudeControl;

  /// Active/désactive la vibration
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Vérifie si l'appareil supporte la vibration
  Future<bool> hasVibrator() async {
    _hasVibrator ??= await Vibration.hasVibrator();
    return _hasVibrator ?? false;
  }

  /// Vérifie si l'appareil supporte le contrôle d'amplitude (Android 8+)
  Future<bool> hasAmplitudeControl() async {
    _hasAmplitudeControl ??= await Vibration.hasAmplitudeControl();
    return _hasAmplitudeControl ?? false;
  }

  /// Vibration simple (durée par défaut: 500ms)
  Future<void> vibrate({int duration = 500}) async {
    if (!_isEnabled) return;
    if (!await hasVibrator()) return;
    
    await Vibration.vibrate(duration: duration);
  }

  /// Vibration avec pattern personnalisé
  /// Exemple: [0, 500, 200, 500] = pause 0ms, vibrate 500ms, pause 200ms, vibrate 500ms
  Future<void> vibratePattern(List<int> pattern) async {
    if (!_isEnabled) return;
    if (!await hasVibrator()) return;
    
    await Vibration.vibrate(pattern: pattern);
  }

  /// Vibration avec preset prédéfini
  /// Presets disponibles: alarm, notification, heartbeat, etc.
  Future<void> vibratePreset(VibrationPreset preset) async {
    if (!_isEnabled) return;
    if (!await hasVibrator()) return;
    
    await Vibration.vibrate(preset: preset);
  }

  /// Vibration personnalisée avec amplitude (Android 8+ uniquement)
  Future<void> vibrateWithAmplitude({
    int duration = 500,
    int amplitude = 128, // 1-255, défaut = moyen
  }) async {
    if (!_isEnabled) return;
    if (!await hasVibrator()) return;
    
    if (await hasAmplitudeControl()) {
      await Vibration.vibrate(duration: duration, amplitude: amplitude);
    } else {
      // Fallback: vibration simple si pas de contrôle amplitude
      await Vibration.vibrate(duration: duration);
    }
  }

  /// Annule la vibration en cours
  Future<void> cancel() async {
    await Vibration.cancel();
  }

  /// Vibration spécifique pour fin de timer (pattern "alarm")
  Future<void> vibrateTimerComplete() async {
    if (!_isEnabled) return;
    if (!await hasVibrator()) return;
    
    // Pattern: 3 vibrations courtes puis 1 longue
    await Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 200, 200, 800]);
  }

  /// Vibration légère pour feedback utilisateur (tap, bouton)
  Future<void> vibrateLight() async {
    if (!_isEnabled) return;
    if (!await hasVibrator()) return;
    
    await Vibration.vibrate(duration: 50);
  }

  /// Vibration moyenne pour notifications
  Future<void> vibrateMedium() async {
    if (!_isEnabled) return;
    if (!await hasVibrator()) return;
    
    await Vibration.vibrate(duration: 200);
  }

  /// Vibration forte pour alertes importantes
  Future<void> vibrateStrong() async {
    if (!_isEnabled) return;
    if (!await hasVibrator()) return;
    
    await Vibration.vibrate(duration: 500);
  }
}
