import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLite {
  static final SQLite instance = SQLite._init();
  static Database? _database;
  SQLite._init();
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('my_sql');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _updateDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE User
  (UserID INTEGER PRIMARY KEY , Email TEXT, Password TEXT)
''');

    await db.execute('''
CREATE TABLE Settings
(SettingID INTEGER PRIMARY KEY, Name TEXT, Value TEXT)
''');
    await db.execute('''
CREATE TABLE XYZ
(UserID INTEGER PRIMARY KEY, Email TEXT, Password TEXT)
''');

    await db.rawInsert('''
 INSERT INTO User
 (UserID, Email, Password)
 VALUES(1,'','')
''');
    await db.rawInsert('''
    INSERT INTO Settings
    (SettingID, Name, Value)
    VALUES(1, 'Already Signed In', '0')
    ''');
    await db.rawInsert('''
 INSERT INTO XYZ
 (UserID, Email, Password)
 VALUES(1,'','')
''');
  }

  Future<void> _updateDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2 && newVersion >= 2) {
      await db.execute('''
   CREATE TABLE XYZ
   (UserID INTEGER PRIMARY KEY, Email TEXt, Password TEXT)
   ''');

      await db.rawInsert('''
INSERT INTO XYZ
(UserID, Email, Password)
VALUES(1, '', '')
''');
    }
  }

  static Future<String> getValue(
    String field,
    String table,
    String where,
  ) async {
    String value = '';
    try {
      final db = await instance.database;
      var queryData = await db.rawQuery(
        "SELECT $field FROM $table WHERE $where",
      );
      value = (queryData.first[field]).toString();
    } catch (e) {
      if (kDebugMode) {
        print('GetValue EXP : $e');
      }
    }
    return value;
  }

  static updateValue(
    String field,
    String table,
    String where,
    String value,
  ) async {
    try {
      final db = await instance.database;
      await db.rawQuery("""
  UPDATE $table SET $field = '$value' WHERE $where
""");
    } catch (e) {
      if (kDebugMode) {
        print('UpdateValue EXP : $e');
      }
    }
  }
}
