import 'package:flutter/material.dart';

class ReadBooksProvider with ChangeNotifier {
  final List<Map<String, String>> _readBooks = [];

  List<Map<String, String>> get readBooks => _readBooks;

  void addBook(Map<String, String> book) {
    _readBooks.add(book);
    notifyListeners();
  }

  void removeBook(Map<String, String> book) {
    _readBooks.remove(book);
    notifyListeners();
  }
}
