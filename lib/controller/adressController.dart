import 'package:empoderaecommerce/helper/databaseHelper.dart';
import 'package:empoderaecommerce/models/adressModel.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sqflite/sqflite.dart';

class Adresscontroller extends GetxController {
  Future<Database> get database async {
    return await DatabaseHelper.instance.database;
  }
  
  Future<List<Address>> getAddressesByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      'addresses',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return maps.map((map) => Address.fromMap(map)).toList();
  }

  Future<Address?> getAddressById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'addresses',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Address.fromMap(result.first);
    }
    return null;
  }

  Future<void> insertAddress(Address address) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'addresses',
      address.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Endereço inserido com sucesso no banco!');
  }

  Future<int> updateAddress(Address address) async {
    final db = await database;
    return await db.update(
      'addresses',
      address.toMap(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  Future<int> deleteAddress(int id) async {
    final db = await database;
    return await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }
}


