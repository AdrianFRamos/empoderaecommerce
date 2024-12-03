import 'package:empoderaecommerce/const/hashedPassword.dart';
import 'package:empoderaecommerce/controller/sessionController.dart';
import 'package:empoderaecommerce/middleware/google.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:empoderaecommerce/helper/databaseHelper.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<Database> get database async {
    return await DatabaseHelper.instance.database;
  }

  Future<bool> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final hashedPassword = hashPassword(password);

    final user = await getUserByEmailAndPassword(email, hashedPassword);
    if (user != null) {
      await saveUserSession(user); 
      return true;
    } else {
      return false;
    }
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;

    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    logout_Google();
    Get.offAllNamed('/login'); 
  }
}
