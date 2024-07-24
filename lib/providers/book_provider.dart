import 'dart:typed_data' show Uint8List;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:libri/models/book.dart';
import 'package:libri/utils/database_helper.dart';

class BookClass extends ChangeNotifier {
  BookClass() {
    getBooks();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Uint8List? bookImage;
  Uint8List? mybook;

  List<Book> allBooks = [];
  List<Book> readBooks = [];

  Future<void> getBooks() async {
    allBooks = await DatabaseHelper.instance.getAllBooks();
    readBooks = allBooks.where((e) => e.isRead).toList();
    notifyListeners();
  }

  Future<void> insertNewBook(Book book) async {
    final db = await DatabaseHelper.instance.insertNewBook(book);
    getBooks();
  }

  Future<void> updateBook(Book book) async {
    await DatabaseHelper.instance.updateBook(book);
    print('Retrieved ${allBooks.length} books from database');
    notifyListeners();
  }
  
    Future<void> updateBookDescription(Book book, String newDescription) async {
    await DatabaseHelper.instance
        .updateBookDescription(book.id!, newDescription);
    await getBooks();
  }


  Future<void> updateIsRead(Book book) async {
    DatabaseHelper.instance.updateIsRead(book);
    getBooks();
  }

  Future<void> deleteBook(Book book) async {
    await DatabaseHelper.instance.deleteBook(book);
    getBooks();
  }
}
