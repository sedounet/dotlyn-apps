import 'package:flutter/foundation.dart';
import '../models/resource.dart';
import '../services/database_service.dart';

class ResourceProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Resource> _resources = [];
  bool _isLoading = false;

  List<Resource> get resources => _resources;
  bool get isLoading => _isLoading;

  Future<void> loadResources() async {
    _isLoading = true;
    notifyListeners();
    _resources = await _db.getResources();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addResource(Resource resource) async {
    await _db.insertResource(resource);
    await loadResources();
  }

  Future<void> deleteResource(int id) async {
    await _db.deleteResource(id);
    await loadResources();
  }
}
