import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import '../model/Pojam.dart';

class AsocijacijeDatabase {
  static final AsocijacijeDatabase instance = AsocijacijeDatabase._init();

  static Database? _database;

  AsocijacijeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "pojmovi.db");

// Provjera da li baza vec postoji
    var exists = await databaseExists(path);

    if (!exists) {
      // Izvrsava se samo kad se prvi put pokrene aplikacija
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Kopiranje iz asseta
      ByteData data = await rootBundle.load(join("assets", "Pojmovi.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);

    } else {
      print("Opening existing database");
    }

// Otvaranje baze
    return await openDatabase(path, readOnly: true);
  }

  Future _createDB(Database db, int version) async {
    final idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    final pojamType = "TEXT NOT NULL";

    await db.execute(
        '''CREATE TABLE $tablePojam (${PojamFields.Id} $idType, ${PojamFields.Naziv} $pojamType)''');
  }

  Future<Pojam> create(Pojam pojam) async {
    final db = await instance.database;

    final id = await db.insert(tablePojam, pojam.toJson());
    return pojam.copy(id: id);
  }

  Future<Pojam> readPojam(int id) async {
    final db = await instance.database;

    final maps = await db.query(tablePojam,
        columns: PojamFields.values,
        where: "${PojamFields.Id} = ?",
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Pojam.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  Future<List<Pojam>> readAll() async {
    final db = await instance.database;

    final result = await db.query(tablePojam);

    return result.map((e) => Pojam.fromJson(e)).toList();
  }

  Future<void> deleteDatabase() =>
      databaseFactory.deleteDatabase(_database!.path);
}
