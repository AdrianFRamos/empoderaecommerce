import 'package:empoderaecommerce/helper/databaseHelper.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<Database> get database async {
    return await DatabaseHelper.instance.database;
  }

  Future<void> loginUser(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;
    final user = await getUserByEmailAndPassword(email, password);

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
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
}
