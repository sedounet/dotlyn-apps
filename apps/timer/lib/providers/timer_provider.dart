import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:dotlyn_core/services/notification_service.dart';
import '../models/timer_state.dart';
import '../services/timer_service.dart';
import '../services/alarm_service.dart';
// import '../services/audio_service.dart';

class TimerProvider extends ChangeNotifier {
  TimerStatus _status = TimerStatus.idle;
  Duration _duration = Duration.zero;
  Duration _remaining = Duration.zero;
  Timer? _timer;
  String? _errorMessage;
  bool _showCompletionDialog = false;
  DateTime _startTime = DateTime.now(); // Nouvelle variable d'instance

  final TimerService _timerService = TimerService();
  // final AudioService _audioService = AudioService(); // Non utilisé - son géré par notifications système

  TimerStatus get status => _status;
  Duration get duration => _duration;
  Duration get remaining => _remaining;
  String? get errorMessage => _errorMessage;
  bool get showCompletionDialog => _showCompletionDialog;

  TimerProvider() {
    // Son géré par le système via notifications
  }

  void start(Duration duration) {
    _duration = duration;
    _remaining = duration;
    _status = TimerStatus.running;
    _errorMessage = null;
    _startTime = DateTime.now(); // Stocker l'heure de départ

    // Programmer l'alarme système
    AlarmService.scheduleTimer(_remaining);

    // Supprimer Timer.periodic, utiliser un timer pour l'UI
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final elapsed = DateTime.now().difference(_startTime);
      final newRemaining = _duration - elapsed;

      if (newRemaining.inSeconds >= 0) {
        _remaining = newRemaining;
        notifyListeners();
      } else {
        _timer?.cancel();
        _status = TimerStatus.idle;
        notifyListeners();
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

  // void _onTimerComplete() {
  //   _status = TimerStatus.idle;
  //   _showCompletionDialog = true;
  //   // Son géré par la notification système uniquement
  //   AlarmService.cancelTimer();
  //   // Affiche la notification timer terminé
  //   NotificationService.showTimerComplete();
  //   notifyListeners();
  // }

  void dismissCompletionDialog() {
    _showCompletionDialog = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
