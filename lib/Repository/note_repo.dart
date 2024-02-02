
import 'package:diary_note/Repository/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteRepository{
  static const dbName = "note_database.db";
  static const dbTable = "notes";

  static Future<Database> _database() async {
    final database = openDatabase(
      join(await getDatabasesPath(), dbName),

      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $dbTable(id INTEGER PRIMARY KEY, title TEXT, description TEXT, createdAt TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  static insert({required Note note}) async {
    final db = await _database();
    await db.insert(
        dbTable,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<List<Note>> getNotes() async {
    final db = await _database();

    final List<Map<String, dynamic>> maps = await db.query(dbTable);

    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        description: maps[i]['description'] as String,
        createdAt: DateTime.parse(maps[i]['createdAt']),
      );
    });
  }
  static update({required Note note}) async {
    final db = await _database();

    await db.update(
      dbTable,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
  static delete({required Note note}) async {
    final db = await _database();

    await db.delete(
      dbTable,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}