import 'package:flutter/material.dart';
import 'package:noted/models/database_model.dart';
import 'package:noted/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase extends ChangeNotifier {
  MyDatabase._();
  static Future<Database> _notesDatabase() async {
// Method for version 1 of the database
    void createTablesV1(Batch batch) {
      // Deleting the table, and any data associated with it, from the database if it exists.
      batch.execute('DROP TABLE IF EXISTS notes');
      batch.execute('''CREATE TABLE notes (
    id TEXT PRIMARY KEY, title TEXT, body TEXT, createddate INTEGER, updateddate INTEGER, isfavorite INTEGER, color INTEGER
)''');
    }

    // First version of the database
    return openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      version: 1,
      onCreate: (db, version) async {
        var batch = db.batch();
        createTablesV1(batch);
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  static Future<Database> getNotesDatabase() async {
    return _notesDatabase();
  }

  // Future<Database> getDatabase(DatabaseModel model) async {
  //   return await getDatabaseByName('${model.database()}');
  // }

  // Future<Database> getDatabaseByName(String dbName) {
  //   switch (dbName) {
  //     case 'notes_database':
  //       return _notesDatabase();
  //     default:
  //       return _notesDatabase();
  //   }
  // }

  // Insert in DB method using table name & the data itself
  static Future<void> insert(DatabaseModel model) async {
    final db = await _notesDatabase();
    db.insert(
      model.table()!,
      model.toMap()!,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update data in DB method using table name, the new data & id
  static Future<void> update(DatabaseModel model) async {
    final db = await _notesDatabase();
    db.update(
      model.table()!,
      model.toMap()!,
      where: 'id = ?',
      whereArgs: [model.getId()],
    );
    // notifyListeners();
  }

  // Delete data from DB method using table name & id
  static Future<void> delete(DatabaseModel model) async {
    final db = await _notesDatabase();
    db.delete(
      model.table()!,
      where: 'id = ?',
      whereArgs: [model.getId()],
    );
    // TODO : try adding notifyListeners();
  }

  // Method to get the data stored in database
  static Future<List<DatabaseModel>> getAll(String table) async {
    final db = await _notesDatabase();
    final List<Map<String, dynamic>> maps = await db.query(table);
    List<Note> notesData = [];
    for (var item in maps) {
      switch (table) {
        case 'notes':
          notesData.add(Note.fromMap(item));
          break;
      }
    }
    return notesData;
  }
}
