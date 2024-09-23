import 'package:empoderaecommerce/helper/databaseHelper.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Usercontroller extends GetxController {
  Future<Database> get database async {
    return await DatabaseHelper.instance.database;
  }
  
  Future<int> insertUser(String name, String email, String password) async {
    final db = await database;
    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}