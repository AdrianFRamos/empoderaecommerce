import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'your_app_database.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, _databaseName);
    return await openDatabase(dbPath, version: _databaseVersion, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        avatarUrl TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY,
        productId INTEGER NOT NULL,
        FOREIGN KEY (productId) REFERENCES products (id)
      )
    ''');
  }

  

  



  

}




