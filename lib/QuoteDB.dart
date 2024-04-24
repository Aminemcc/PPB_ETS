import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Quote {
  int id = 0;
  String text;
  String author;

  Quote({required this.id, required this.text, required this.author});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quote': text,
      'author': author,
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
    String path = join(await getDatabasesPath(), 'Quotes.db');

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
        "CREATE TABLE quotes(id INTEGER PRIMARY KEY, quote TEXT, author TEXT)");
    cur_id = 0;
  }

  Future<void> insertData(Map<String, dynamic> data) async {
    final db = await database;
    data['id'] = ++cur_id;
    await db?.insert('quotes', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Quote>> getData() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db!.query('quotes');
    return List.generate(maps.length, (i) {
      return Quote(
        id: maps[i]['id'],
        text: maps[i]['quote'],
        author: maps[i]['author'],
      );
    });
  }

  Future<void> updateData(Map<String, dynamic> data) async {
    final db = await database;
    await db?.update('quotes', data,
        where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<void> deleteData(int id) async {
    final db = await database;
    await db?.delete('quotes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db?.execute('DROP TABLE IF EXISTS quotes');
    await createDB(db!, 1);
  }
}
