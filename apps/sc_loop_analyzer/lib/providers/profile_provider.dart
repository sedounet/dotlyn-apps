import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/database_service.dart';

class ProfileProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Profile> _profiles = [];
  bool _isLoading = false;

  List<Profile> get profiles => _profiles;
  bool get isLoading => _isLoading;

  Future<void> loadProfiles() async {
    _isLoading = true;
    notifyListeners();
    _profiles = await _db.getProfiles();
    _isLoading = false;
    notifyListeners();
  }

  Future<int?> addProfile(Profile profile) async {
    final id = await _db.insertProfile(profile);
    await loadProfiles();
    return id;
  }

  Future<void> updateProfile(Profile profile) async {
    await _db.updateProfile(profile);
    await loadProfiles();
  }

  Future<void> deleteProfile(int id) async {
    await _db.deleteProfile(id);
    await loadProfiles();
  }
}
