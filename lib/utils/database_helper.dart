import 'dart:convert'; // For Base64 encoding/decoding
import 'dart:io';

import 'package:libri/models/book.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  static Database? _database;

  final String tableName = 'books';
  final String idColumn = 'id';
  final String titleColumn = 'title';
  final String authorColumn = 'author';
  final String bookImageColumn = 'bookImage';
  final String isReadColumn = 'isRead';
  final String descriptionColumn = 'description';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/books.db';
    print('Database location: $path');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE $tableName ('
          '$idColumn INTEGER PRIMARY KEY AUTOINCREMENT, '
          '$titleColumn TEXT, '
          '$authorColumn TEXT, '
          '$bookImageColumn TEXT, ' // Changed from BLOB to TEXT for Base64
          '$isReadColumn INTEGER, '
          '$descriptionColumn TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {
          // Handle schema upgrade if needed
        }
      },
      onDowngrade: (db, oldVersion, newVersion) {
        print('Database downgraded from $oldVersion to $newVersion');
      },
    );
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    List<Map<String, dynamic>> books = await db.query(tableName);
    return books.map((e) => Book.fromMapObject(e)).toList();
  }

  Future<int> insertNewBook(Book book) async {
    final db = await database;
    return await db.insert(tableName, book.toMap());
  }

  Future<int> deleteBook(Book book) async {
    final db = await database;
    return await db
        .delete(tableName, where: '$idColumn = ?', whereArgs: [book.id]);
  }

  Future<int> deleteBooks() async {
    final db = await database;
    return await db.delete(tableName);
  }

  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update(
      tableName,
      {
        isReadColumn: book.isRead ? 1 : 0,
        titleColumn: book.title,
        authorColumn: book.author,
        bookImageColumn:
            book.bookImage != null ? base64Encode(book.bookImage!) : null,
        descriptionColumn: book.description,
      },
      where: '$idColumn = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> updateBookDescription(int id, String newDescription) async {
    final db = await database;
    return await db.update(
      'books',
      {'description': newDescription},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // To mark as read
  Future<void> updateIsRead(Book book) async {
    final db = await database;
    await db.update(tableName, {isReadColumn: !book.isRead ? 1 : 0},
        where: '$idColumn=?', whereArgs: [book.id]);
  }
}
