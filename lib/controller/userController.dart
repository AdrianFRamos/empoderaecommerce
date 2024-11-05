import 'dart:ffi';

import 'package:empoderaecommerce/const/hashedPassword.dart';
import 'package:empoderaecommerce/helper/databaseHelper.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class UserController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  // Getter para acessar o banco de dados
  Future<Database> get _database async {
    return await DatabaseHelper.instance.database;
  }

  // Inserir um novo usuário no banco de dados
  Future<int> insertUser(String name, String email, String lastname, String password, String number) async {
    final db = await DatabaseHelper.instance.database;
    final hashedPassword = hashPassword(password);

    try {
      return await db.insert('users', {
        'name': name,
        'lastname': lastname,
        'email': email,
        'password': hashedPassword,
        'number': number,
      });
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError('users.email')) {
        throw Exception('Email already registered');
      } else {
        rethrow; // Lança outras exceções
      }
    }
  }


  // Atualizar um usuário existente
  static Future<bool> updateUser(User user) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final rowsUpdated = await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
      return rowsUpdated > 0;
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      return false;
    }
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
