import 'package:empoderaecommerce/helper/databaseHelper.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; 

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<Database> get database async {
    return await DatabaseHelper.instance.database;
  }

  Future<bool> loginUser() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Erro',
        'Preencha todos os campos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    final user = await getUserByEmailAndPassword(email, password);

    if (user != null) {
      _clearFields();
      return true; 
    } else {
      return false; 
    }
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);

    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  void _clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
