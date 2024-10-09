import 'package:empoderaecommerce/helper/databaseHelper.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class UserController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  // Getter para acessar o banco de dados
  Future<Database> get _database async {
    return await DatabaseHelper.instance.database;
  }

  // Inserir um novo usuário no banco de dados
  Future<int> insertUser(String name, String email, String password) async {
    final db = await _database;
    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  // Atualizar um usuário existente
  Future<int> updateUser(User user) async {
    final db = await _database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Deletar um usuário pelo ID
  Future<int> deleteUser(int id) async {
    final db = await _database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  
}
