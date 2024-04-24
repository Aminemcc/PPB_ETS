import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Book {
  int id = 0;
  String title;
  String description;
  String dateUpload;
  String imagePath;

  Quote({required this.id, required this.title, required this.description, required this.dateUpload});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateUpload': dateUpload
    };
  }
}

class DBHelper {
  static Database? _database;
  int cur_id = 0;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database?> initDB() async {
    String path = join(await getDatabasesPath(), 'Books.db');

    bool exists = await databaseExists(path);
    if (!exists) {
      _database = await openDatabase(path, version: 1, onCreate: createDB);
    } else {
      _database = await openDatabase(path, version: 1);
    }

    return _database;
  }

  Future<void> createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE books(id INTEGER PRIMARY KEY, title TEXT, description TEXT, imagePath TEXT, dateUpload TEXT)");
    cur_id = 0;
  }

  Future<void> insertData(Map<String, dynamic> data) async {
    final db = await database;
    data['id'] = ++cur_id;
    await db?.insert('books', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Book>> getData() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db!.query('books');
    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        title: maps[i]['quote'],
        description: maps[i]['author'],
        dateUpload: maps[i]['dateUpload'],
        imagePath; maps[i]['imagePath']
      );
    });
  }

  Future<void> updateData(Map<String, dynamic> data) async {
    final db = await database;
    await db?.update('books', data,
        where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<void> deleteData(int id) async {
    final db = await database;
    await db?.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db?.execute('DROP TABLE IF EXISTS books');
    await createDB(db!, 1);
  }
}
