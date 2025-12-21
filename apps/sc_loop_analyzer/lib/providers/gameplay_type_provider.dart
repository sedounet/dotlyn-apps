import 'package:flutter/material.dart';
import '../models/gameplay_type.dart';
import '../services/database_service.dart';

class GameplayTypeProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<GameplayType> _types = [];
  bool _isLoading = false;

  List<GameplayType> get types => _types;
  bool get isLoading => _isLoading;

  Future<void> loadTypes() async {
    _isLoading = true;
    notifyListeners();
    _types = await _db.getGameplayTypes();
    _isLoading = false;
    notifyListeners();
  }

  Future<int> addType(GameplayType type) async {
    final id = await _db.insertGameplayType(type);
    await loadTypes();
    return id;
  }

  Future<void> deleteType(int id) async {
    await _db.deleteGameplayType(id);
    await loadTypes();
  }
}
