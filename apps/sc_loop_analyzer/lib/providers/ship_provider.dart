import 'package:flutter/material.dart';
import '../models/ship.dart';
import '../services/database_service.dart';

class ShipProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Ship> _ships = [];
  bool _isLoading = false;

  List<Ship> get ships => _ships;
  bool get isLoading => _isLoading;

  Future<void> loadShips() async {
    _isLoading = true;
    notifyListeners();
    _ships = await _db.getShips();
    _isLoading = false;
    notifyListeners();
  }

  Future<int> addShip(Ship ship) async {
    final id = await _db.insertShip(ship);
    await loadShips();
    return id;
  }

  Future<void> deleteShip(int id) async {
    await _db.deleteShip(id);
    await loadShips();
  }
}
