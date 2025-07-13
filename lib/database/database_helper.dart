import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/checkin.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'checkin_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE checkins (
        id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        device_id TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create index for faster queries
    await db.execute('''
      CREATE INDEX idx_checkins_timestamp ON checkins(timestamp)
    ''');
  }

  Future<int> insertCheckIn(CheckIn checkIn) async {
    final db = await database;
    return await db.insert('checkins', checkIn.toMap());
  }

  Future<List<CheckIn>> getAllCheckIns() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'checkins',
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return CheckIn.fromMap(maps[i]);
    });
  }

  Future<List<CheckIn>> getRecentCheckIns(int limit) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'checkins',
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) {
      return CheckIn.fromMap(maps[i]);
    });
  }

  Future<int> getCheckInCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM checkins');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<CheckIn?> getLastCheckIn() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'checkins',
      orderBy: 'timestamp DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return CheckIn.fromMap(maps.first);
    }
    return null;
  }

  Future<void> deleteCheckIn(String id) async {
    final db = await database;
    await db.delete('checkins', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllCheckIns() async {
    final db = await database;
    await db.delete('checkins');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> _debugDatabasePath() async {
    String path = join(await getDatabasesPath(), 'checkin_database.db');
    print('Database stored at: $path');
  }
}
