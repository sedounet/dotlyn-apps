import 'dart:async';
import 'package:flutter/material.dart';
import '../models/timer_state.dart';
import '../services/timer_service.dart';
import '../services/audio_service.dart';

class TimerProvider extends ChangeNotifier {
  TimerStatus _status = TimerStatus.idle;
  Duration _duration = Duration.zero; // 0 par défaut
  Duration _remaining = Duration.zero;
  Timer? _timer;
  String? _errorMessage;
  bool _showCompletionDialog = false;

  final TimerService _timerService = TimerService();
  final AudioService _audioService = AudioService();

  TimerStatus get status => _status;
  Duration get duration => _duration;
  Duration get remaining => _remaining;
  String? get errorMessage => _errorMessage;
  bool get showCompletionDialog => _showCompletionDialog;

  TimerProvider() {
    // Précharger le son au démarrage
    _audioService.preloadSound('dingding.mp3');
    // Charger les settings de vibration
    _audioService.loadVibrationSettings();
  }

  /// Démarre le timer avec la durée donnée
  void start(Duration duration) {
    _duration = duration;
    _remaining = duration;
    _status = TimerStatus.running;
    _errorMessage = null;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        _remaining = Duration(seconds: _remaining.inSeconds - 1);
        notifyListeners();
      } else {
        _timer?.cancel();
        _onTimerComplete();
      }
    });
    notifyListeners();
  }

  /// Met le timer en pause
  void pause() {
    if (_status == TimerStatus.running) {
      _timer?.cancel();
      _status = TimerStatus.paused;
      notifyListeners();
    }
  }

  /// Reprend le timer depuis la pause
  void resume() {
    if (_status == TimerStatus.paused) {
      start(_remaining);
    }
  }

  /// Réinitialise le timer
  void reset() {
    _timer?.cancel();
    _status = TimerStatus.idle;
    _remaining = _duration;
    _errorMessage = null;
    notifyListeners();
  }

  /// Valide et corrige l'input utilisateur
  String? validateAndCorrectInput(String input) {
    try {
      final duration = _timerService.parseDuration(input);

      // Vérifier la limite de 12h
      if (duration.inHours > 12) {
        _errorMessage = 'Durée maximale : 12h';
        notifyListeners();
        return null;
      }

      // Corriger les valeurs invalides (ex: 1:65:00 → 2:05:00)
      final corrected = _timerService.correctInvalidDuration(duration);
      _duration = corrected;
      _remaining = corrected;
      _errorMessage = null;
      notifyListeners();

      // Retourner la durée corrigée si différente de l'input
      final correctedString = _timerService.formatDuration(corrected);
      if (correctedString != input) {
        return correctedString;
      }
      return null;
    } catch (e) {
      _errorMessage = 'Format invalide. Utilisez hh:mm:ss';
      notifyListeners();
      return null;
    }
  }

  void _onTimerComplete() {
    _status = TimerStatus.idle;
    _showCompletionDialog = true;
    _audioService.playTimerComplete(); // Son + vibration
    notifyListeners();

    // Auto-stop after 30 seconds
    Future.delayed(Duration(seconds: 30), () {
      if (_showCompletionDialog) {
        dismissCompletionDialog();
      }
    });
  }

  void dismissCompletionDialog() {
    _showCompletionDialog = false;
    _audioService.stopSound();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioService.dispose();
    super.dispose();
  }
}
