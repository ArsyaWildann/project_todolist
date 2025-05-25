import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT UNIQUE,
          password TEXT
        )
      ''');
    });
  }

  Future<void> register(String email, String password,
      {required String name}) async {
    final db = await database;
    // cek email sudah ada?
    final existing =
        await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (existing.isNotEmpty) throw Exception('Email already used');

    await db
        .insert('users', {'name': name, 'email': email, 'password': password});
  }

  Future<bool> login(String email, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return res.isNotEmpty;
  }
}
