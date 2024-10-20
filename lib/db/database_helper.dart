import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'habit_tracker.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        frequency TEXT,
        reminder_time TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habit_id INTEGER,
        date TEXT,
        is_completed INTEGER
      )
    ''');
  }

  Future<int> insertHabit(Map<String, dynamic> habit) async {
    var dbClient = await db;
    return await dbClient.insert('habits', habit);
  }

  Future<List<Map<String, dynamic>>> getHabits() async {
    var dbClient = await db;
    return await dbClient.query('habits');
  }

  Future<int> updateHabit(Map<String, dynamic> habit, int id) async {
    var dbClient = await db;
    return await dbClient.update('habits', habit, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteHabit(int id) async {
    var dbClient = await db;
    return await dbClient.delete('habits', where: 'id = ?', whereArgs: [id]);
  }
}
