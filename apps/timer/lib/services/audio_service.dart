import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Précharge le son pour éviter les lags
  Future<void> preloadSound(String soundName) async {
    await _audioPlayer.setSource(AssetSource('assets/sounds/$soundName'));
  }

  /// Joue un son depuis assets/sounds/
  Future<void> playSound(String soundName) async {
    await _audioPlayer.play(AssetSource('assets/sounds/$soundName'));
  }

  /// Déclenche une vibration
  Future<void> vibrate() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator) {
      Vibration.vibrate(duration: 500);
    }
  }

  /// Joue le son + vibration de fin selon les settings
  Future<void> playTimerComplete() async {
    final prefs = await SharedPreferences.getInstance();
    final soundEnabled = prefs.getBool('sound_enabled') ?? true;
    final vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;

    if (soundEnabled) {
      await playSound('dingding.mp3');
    }
    if (vibrationEnabled) {
      await vibrate();
    }
  }

  /// Nettoie les ressources
  void dispose() {
    _audioPlayer.dispose();
  }
}
