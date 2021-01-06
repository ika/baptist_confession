import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'bmModel.dart';

class BMProvider {
  String _dbName = "bMara.db"; // change db name to update
  String _dbTable =  'bkmarks';

  static BMProvider _dbProvider;
  static Database _database;

  BMProvider._createInstance();

  factory BMProvider() {
    if (_dbProvider == null) {
      _dbProvider = BMProvider._createInstance();
    }
    return _dbProvider;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDB();
    }
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    var path = join(documentsDir.path, _dbName);

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", _dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  Future close() async {
    return _database.close();
  }

  Future<void> saveBookMark(BMModel model) async {
    final db = await database;
    await db.insert(
      _dbTable,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBookMark(int id) async {
    final db = await database;
    await db.delete(_dbTable, where: "id = ?", whereArgs: [id]);
  }

  Future<List<BMModel>> getBookMarkList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT id, title, subtitle, detail, page FROM $_dbTable ORDER BY id DESC");

    return List.generate(maps.length, (i) {
      return BMModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        subtitle: maps[i]['subtitle'],
        detail: maps[i]['detail'],
        page: maps[i]['page'],
      );
    });
  }
}
