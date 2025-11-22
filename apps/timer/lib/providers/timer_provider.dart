import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dotlyn_core/services/alarm_service.dart';
import 'package:dotlyn_core/services/notification_service.dart';
import '../models/timer_state.dart';
import '../services/timer_service.dart';
import '../services/audio_service.dart';

class TimerProvider extends ChangeNotifier {
  TimerStatus _status = TimerStatus.idle;
  Duration _duration = Duration.zero;
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
    _audioService.preloadSound('dingding.mp3');
    _audioService.loadVibrationSettings();
  }

  void start(Duration duration) {
    _duration = duration;
    _remaining = duration;
    _status = TimerStatus.running;
    _errorMessage = null;

    // Affiche la notification timer en cours dès le démarrage
    NotificationService.showTimerRunning(_remaining);
    AlarmService.scheduleTimer(_remaining);

    int tickCount = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        _remaining = Duration(seconds: _remaining.inSeconds - 1);
        tickCount++;
        if (tickCount % 5 == 0) {
          NotificationService.showTimerRunning(_remaining);
        }
        notifyListeners();
      } else {
        _timer?.cancel();
        _onTimerComplete();
      }
    });
    notifyListeners();
  }

  void pause() {
    if (_status == TimerStatus.running) {
      _timer?.cancel();
      AlarmService.cancelTimer();
      _status = TimerStatus.paused;
      notifyListeners();
    }
  }

  void resume() {
    if (_status == TimerStatus.paused) start(_remaining);
  }

  void reset() {
    _timer?.cancel();
    AlarmService.cancelTimer();
    _status = TimerStatus.idle;
    _remaining = _duration;
    _errorMessage = null;
    notifyListeners();
  }

  String? validateAndCorrectInput(String input) {
    try {
      final duration = _timerService.parseDuration(input);
      if (duration.inHours > 12) {
        _errorMessage = 'Durée maximale : 12h';
        notifyListeners();
        return null;
      }
      final corrected = _timerService.correctInvalidDuration(duration);
      _duration = corrected;
      _remaining = corrected;
      _errorMessage = null;
      notifyListeners();
      final correctedString = _timerService.formatDuration(corrected);
      if (correctedString != input) return correctedString;
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
    _audioService.playTimerComplete();
    AlarmService.cancelTimer();
    // Affiche la notification timer terminé
    NotificationService.showTimerComplete();
    notifyListeners();
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
