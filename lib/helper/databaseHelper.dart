import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'db1.db';
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
    try {
      // Caminho correto para o banco de dados no dispositivo
      final databasePath = await getDatabasesPath();
      final dbPath = join(databasePath, _databaseName);

      if (!await Directory(databasePath).exists()) {
        await Directory(databasePath).create(recursive: true);
      }

      print('Database path: $dbPath');

      return await openDatabase(
        dbPath,
        version: _databaseVersion,
        onCreate: _onCreate,
        onConfigure: (db) async {
          // Ativar chaves estrangeiras
          await db.execute('PRAGMA foreign_keys = ON;');
        },
      );
    } catch (e) {
      print('Erro ao abrir o banco de dados: $e');
      rethrow;
    }
  }


  // Método chamado na criação do banco de dados
  Future<void> _onCreate(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        lastname TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        number INTEGER NOT NULL ,
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
    // Tabela de eventos
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        userId INTEGER NOT NULL
      )
    ''');
  }

  // Função para fechar o banco de dados
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
