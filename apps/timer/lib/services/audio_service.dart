import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotlyn_core/dotlyn_core.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final VibrationService _vibrationService = VibrationService();

  /// Charge les settings de vibration au démarrage
  Future<void> loadVibrationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    _vibrationService.setEnabled(vibrationEnabled);
  }

  /// Précharge le son pour éviter les lags
  Future<void> preloadSound(String soundName) async {
    // Use path relative to assets declared in pubspec (flutter will map assets/ prefix).
    // audioplayers expects the asset path without duplicating 'assets/' prefix.
    await _audioPlayer.setSource(AssetSource('sounds/$soundName'));
  }

  /// Joue un son depuis assets/sounds/
  Future<void> playSound(String soundName) async {
    await _audioPlayer.play(AssetSource('sounds/$soundName'));
  }

  /// Déclenche une vibration de fin de timer
  Future<void> vibrate() async {
    await _vibrationService.vibrateTimerComplete();
  }

  /// Joue le son + vibration de fin selon les settings
  Future<void> playTimerComplete() async {
    final prefs = await SharedPreferences.getInstance();
    final soundEnabled = prefs.getBool('sound_enabled') ?? true;
    final vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;

    // Mettre à jour l'état de la vibration selon les settings actuels
    _vibrationService.setEnabled(vibrationEnabled);

    if (soundEnabled) {
      await playSound('dingding.mp3');
    }
    if (vibrationEnabled) {
      await vibrate();
    }
  }

  /// Arrête la lecture du son
  void stopSound() {
    _audioPlayer.stop();
  }

  /// Nettoie les ressources
  void dispose() {
    _audioPlayer.dispose();
  }
}
