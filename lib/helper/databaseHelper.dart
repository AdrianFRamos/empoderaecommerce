import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'app_database.db';
  static const int _databaseVersion = 1;

  // Instância única da classe
  static final DatabaseHelper instance = DatabaseHelper._();

  // Database privado
  static Database? _database;

  // Construtor privado
  DatabaseHelper._();

  // Getter assíncrono para o banco de dados
  Future<Database> get database async {
    // Retorna o banco de dados existente ou o inicializa
    _database ??= await _initDatabase();
    return _database!;
  }

  // Inicializa e abre o banco de dados
  Future<Database> _initDatabase() async {
    // Obtém o caminho do banco de dados
    final dbPath = join(await getDatabasesPath(), _databaseName);

    // Abre o banco de dados
    return await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Método chamado na criação do banco de dados
  Future<void> _onCreate(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        avatarUrl TEXT
      )
    ''');

    // Tabela de produtos
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');

    // Tabela de carrinho
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        FOREIGN KEY (productId) REFERENCES products (id)
      )
    ''');
  }

  // Função para fechar o banco de dados
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
