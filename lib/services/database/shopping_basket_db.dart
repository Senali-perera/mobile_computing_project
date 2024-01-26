import 'dart:convert';

import 'package:mobile_computing_project/shopping/shopping_basket.dart';
import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class ShoppingBasketDB {
  final tableName = 'shopping_basket';

  Future<void> createTable(Database database) async {
    await database.execute(""" CREATE TABLE IF NOT EXISTS $tableName (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "isDone" INTEGER NOT NULL,
    "items" TEXT NOT NULL,
    "dateTime" TEXT,
    "imagePath" TEXT,
    "voiceRecordPath" TEXT,
    "lng" TEXT,
    "lat" TEXT,
    "locationDescription" TEXT
    )""");
  }

  Future<void> insertShoppingBasket(ShoppingBasket shoppingBasket) async {
    final database = await DatabaseService().database;
    await database.insert(
      tableName,
      shoppingBasket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ShoppingBasket>> loadAllShoppingBaskets() async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await database.query(tableName);
    return List.generate(maps.length, (i) {
      return ShoppingBasket(
        maps[i]['id'] as String,
        maps[i]['title'] as String,
        maps[i]['isDone'] == 0 ? false : true,
        jsonDecode(maps[i]['items']).cast<String>(),
        dateTime: DateTime.parse(maps[i]['dateTime']),
        imagePath: maps[i]['imagePath'] as String,
        voiceRecordPath: maps[i]['voiceRecordPath'] as String,
        lng: maps[i]['lng'] as String,
        lat: maps[i]['lat'] as String,
        locationDescription: maps[i]['locationDescription'] as String,
      );
    });
  }

  Future<void> deleteShoppingBasket(String id) async {
    final database = await DatabaseService().database;
    await database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateShoppingBasket(String id, ShoppingBasket shoppingBasket) async {
    final database = await DatabaseService().database;
    await database.update(
      tableName,
      shoppingBasket.toMap(),
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
