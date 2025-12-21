import '../models/profile.dart';
import '../models/session.dart';
import '../models/timestamp_entry.dart';
import 'database_service.dart';

class SessionService {
  final DatabaseService _db = DatabaseService();

  Profile? _activeProfile;
  List<TimestampEntry> _currentTimestamps = [];
  int _currentStep = 0;

  Profile? get activeProfile => _activeProfile;
  List<TimestampEntry> get currentTimestamps => _currentTimestamps;
  int get currentStep => _currentStep;

  void startSession(Profile profile) {
    _activeProfile = profile;
    _currentTimestamps = [];
    _currentStep = 0;
  }

  void recordStep() {
    if (_activeProfile == null) return;
    if (_currentStep >= _activeProfile!.steps.length) return;

    _currentTimestamps.add(TimestampEntry(
      step: _activeProfile!.steps[_currentStep],
      time: DateTime.now(),
    ));
    _currentStep++;
  }

  bool isSessionComplete() {
    if (_activeProfile == null) return false;
    return _currentStep >= _activeProfile!.steps.length;
  }

  Future<void> saveSession(int quantity, String comments) async {
    if (_activeProfile == null || _currentTimestamps.isEmpty) return;

    final startTime = _currentTimestamps.first.time;
    final endTime = _currentTimestamps.last.time;
    final totalDuration = endTime.difference(startTime).inMinutes.toDouble();

    final timestamps = _currentTimestamps
        .map((e) => {
              'step': e.step,
              'time': e.time.toIso8601String(),
            })
        .toList();

    final stepDurations = <Map<String, dynamic>>[];
    for (int i = 1; i < _currentTimestamps.length; i++) {
      final duration = _currentTimestamps[i]
          .time
          .difference(_currentTimestamps[i - 1].time)
          .inMinutes
          .toDouble();
      stepDurations.add({
        'step': _currentTimestamps[i].step,
        'duration_minutes': duration,
      });
    }

    final session = Session(
      id: 0,
      profileId: _activeProfile!.id,
      profileName: _activeProfile!.name,
      startTime: startTime,
      endTime: endTime,
      totalDuration: totalDuration,
      quantity: quantity,
      comments: comments,
      timestamps: timestamps,
      stepDurations: stepDurations,
    );

    await _db.insertSession(session);
    resetSession();
  }

  void resetSession() {
    _activeProfile = null;
    _currentTimestamps = [];
    _currentStep = 0;
  }
}
