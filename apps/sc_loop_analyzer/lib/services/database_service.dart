import 'dart:convert';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/profile.dart';
import '../models/session.dart';
import '../models/gameplay_type.dart';
import '../models/ship.dart';
import '../models/resource.dart';
import '../models/profile_resource.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sc_loop_analyzer.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE gameplay_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE ships (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT,
        notes TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        steps TEXT NOT NULL,
        gameplay_type_id INTEGER,
        ship_id INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (gameplay_type_id) REFERENCES gameplay_types(id),
        FOREIGN KEY (ship_id) REFERENCES ships(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER,
        profile_name TEXT,
        start_time TIMESTAMP,
        end_time TIMESTAMP,
        total_duration_minutes REAL,
        quantity INTEGER,
        comments TEXT,
        timestamps TEXT NOT NULL,
        step_durations TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (profile_id) REFERENCES profiles(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE resources (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        unit TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE profile_resources (
        profile_id INTEGER NOT NULL,
        resource_id INTEGER NOT NULL,
        quantity REAL NOT NULL,
        PRIMARY KEY (profile_id, resource_id),
        FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
        FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE
      )
    ''');
  }

  // CRUD GameplayTypes
  Future<int> insertGameplayType(GameplayType type) async {
    final db = await database;
    return await db.insert('gameplay_types', {
      'name': type.name,
      'description': type.description,
    });
  }

  Future<List<GameplayType>> getGameplayTypes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('gameplay_types');
    return List.generate(maps.length, (i) {
      return GameplayType(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'] ?? '',
        loopIds: [],
      );
    });
  }

  Future<int> deleteGameplayType(int id) async {
    final db = await database;
    return await db.delete('gameplay_types', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateGameplayType(GameplayType type) async {
    final db = await database;
    return await db.update(
      'gameplay_types',
      {
        'name': type.name,
        'description': type.description,
      },
      where: 'id = ?',
      whereArgs: [type.id],
    );
  }

  // CRUD Ships
  Future<int> insertShip(Ship ship) async {
    final db = await database;
    return await db.insert('ships', {
      'name': ship.name,
      'type': ship.type,
      'notes': ship.notes,
    });
  }

  Future<List<Ship>> getShips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ships');
    return List.generate(maps.length, (i) {
      return Ship(
        id: maps[i]['id'],
        name: maps[i]['name'],
        type: maps[i]['type'] ?? '',
        notes: maps[i]['notes'] ?? '',
      );
    });
  }

  Future<int> deleteShip(int id) async {
    final db = await database;
    return await db.delete('ships', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateShip(Ship ship) async {
    final db = await database;
    return await db.update(
      'ships',
      {
        'name': ship.name,
        'type': ship.type,
        'notes': ship.notes,
      },
      where: 'id = ?',
      whereArgs: [ship.id],
    );
  }

  // CRUD Profiles
  Future<int> insertProfile(Profile profile) async {
    final db = await database;
    return await db.insert('profiles', {
      'name': profile.name,
      'description': profile.description,
      'steps': jsonEncode(profile.steps),
      'gameplay_type_id': profile.gameplayTypeId,
      'ship_id': profile.shipId,
    });
  }

  Future<List<Profile>> getProfiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profiles');
    return List.generate(maps.length, (i) {
      return Profile(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'] ?? '',
        steps: List<String>.from(jsonDecode(maps[i]['steps'])),
        gameplayTypeId: maps[i]['gameplay_type_id'],
        shipId: maps[i]['ship_id'],
      );
    });
  }

  Future<int> updateProfile(Profile profile) async {
    final db = await database;
    return await db.update(
      'profiles',
      {
        'name': profile.name,
        'description': profile.description,
        'steps': jsonEncode(profile.steps),
        'gameplay_type_id': profile.gameplayTypeId,
        'ship_id': profile.shipId,
      },
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<int> deleteProfile(int id) async {
    final db = await database;
    return await db.delete('profiles', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS profile_resources');
    await db.execute('DROP TABLE IF EXISTS sessions');
    await db.execute('DROP TABLE IF EXISTS profiles');
    await db.execute('DROP TABLE IF EXISTS ships');
    await db.execute('DROP TABLE IF EXISTS gameplay_types');
    await db.execute('DROP TABLE IF EXISTS resources');
    await _onCreate(db, 1);
  }

  // CRUD Sessions
  Future<int> insertSession(Session session) async {
    final db = await database;
    return await db.insert('sessions', {
      'profile_id': session.profileId,
      'profile_name': session.profileName,
      'start_time': session.startTime.toIso8601String(),
      'end_time': session.endTime.toIso8601String(),
      'total_duration_minutes': session.totalDuration,
      'quantity': session.quantity,
      'comments': session.comments,
      'timestamps': jsonEncode(session.timestamps),
      'step_durations': jsonEncode(session.stepDurations),
    });
  }

  Future<List<Session>> getSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sessions', orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) {
      return Session(
        id: maps[i]['id'],
        profileId: maps[i]['profile_id'],
        profileName: maps[i]['profile_name'],
        startTime: DateTime.parse(maps[i]['start_time']),
        endTime: DateTime.parse(maps[i]['end_time']),
        totalDuration: maps[i]['total_duration_minutes'],
        quantity: maps[i]['quantity'],
        comments: maps[i]['comments'] ?? '',
        timestamps: List<Map<String, dynamic>>.from(jsonDecode(maps[i]['timestamps'])),
        stepDurations: List<Map<String, dynamic>>.from(jsonDecode(maps[i]['step_durations'])),
      );
    });
  }

  Future<int> deleteSession(int id) async {
    final db = await database;
    return await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Resources
  Future<int> insertResource(Resource resource) async {
    final db = await database;
    return await db.insert('resources', resource.toMap());
  }

  Future<List<Resource>> getResources() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('resources', orderBy: 'name ASC');
    return List.generate(maps.length, (i) => Resource.fromMap(maps[i]));
  }

  Future<int> deleteResource(int id) async {
    final db = await database;
    return await db.delete('resources', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Profile Resources
  Future<void> setProfileResources(int profileId, List<Map<String, dynamic>> resources) async {
    final db = await database;
    // Delete existing
    await db.delete('profile_resources', where: 'profile_id = ?', whereArgs: [profileId]);
    // Insert new
    for (var res in resources) {
      await db.insert('profile_resources', {
        'profile_id': profileId,
        'resource_id': res['resourceId'],
        'quantity': 0, // Not used anymore, but required by the table schema
      });
    }
  }

  Future<List<ProfileResource>> getProfileResources(int profileId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT pr.profile_id, pr.resource_id, pr.quantity, r.name as resource_name, r.unit as resource_unit
      FROM profile_resources pr
      JOIN resources r ON pr.resource_id = r.id
      WHERE pr.profile_id = ?
    ''', [profileId]);
    return List.generate(maps.length, (i) => ProfileResource.fromMap(maps[i]));
  }
}
