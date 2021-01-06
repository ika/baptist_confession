import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'dbModel.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// atexts confession
// btexts Ecumenical creeds
// ctexts Kategismus
// dtexts Dort

class DBProvider {
  String _dbName = "bCona.db"; // change db name to update

  static DBProvider _dbProvider;
  static Database _database;

  DBProvider._createInstance();

  factory DBProvider() {
    if (_dbProvider == null) {
      _dbProvider = DBProvider._createInstance();
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

  Future<List<Chapter>> getTitleList(String table) async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT id, chap, title FROM $table");

    return List.generate(maps.length, (i) {
      return Chapter(
        id: maps[i]['id'],
        chap: maps[i]['chap'],
        title: maps[i]['title'],
        //text: maps[i]['text'],
      );
    });
  }

  Future<List<Chapter>> getChapters(String table) async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT id, title, text FROM $table");

    return List.generate(maps.length, (i) {
      return Chapter(
        id: maps[i]['id'],
        //chap: maps[i]['chap'],
        title: maps[i]['title'],
        text: maps[i]['text'],
      );
    });
  }
}
