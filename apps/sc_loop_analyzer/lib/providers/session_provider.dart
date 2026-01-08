import 'package:flutter/material.dart';
import '../models/session.dart';
import '../models/profile.dart';
import '../models/timestamp_entry.dart';
import '../services/session_service.dart';
import '../services/database_service.dart';

class SessionProvider extends ChangeNotifier {
  final SessionService _sessionService = SessionService();
  final DatabaseService _db = DatabaseService();
  List<Session> _sessions = [];
  bool _isLoading = false;

  Profile? get activeProfile => _sessionService.activeProfile;
  List<TimestampEntry> get currentTimestamps =>
      _sessionService.currentTimestamps;
  int get currentStep => _sessionService.currentStep;
  List<Session> get sessions => _sessions;
  bool get isLoading => _isLoading;
  bool get isSessionComplete => _sessionService.isSessionComplete();

  String get currentStepName {
    if (activeProfile == null) return '';
    if (currentStep >= activeProfile!.steps.length) return 'Session terminée';
    return activeProfile!.steps[currentStep];
  }

  void startSession(Profile profile) {
    _sessionService.startSession(profile);
    notifyListeners();
  }

  void recordStep() {
    _sessionService.recordStep();
    notifyListeners();
  }

  Future<void> saveSession(int quantity, String comments) async {
    await _sessionService.saveSession(quantity, comments);
    await loadSessions();
    notifyListeners();
  }

  void resetSession() {
    _sessionService.resetSession();
    notifyListeners();
  }

  Future<void> loadSessions() async {
    _isLoading = true;
    notifyListeners();
    _sessions = await _db.getSessions();
    _isLoading = false;
    notifyListeners();
  }
}
