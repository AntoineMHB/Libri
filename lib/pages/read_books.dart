import 'package:flutter/material.dart';
import 'package:libri/services/read_books_provider.dart';
import 'package:provider/provider.dart';

class ReadBooks extends StatelessWidget {
  const ReadBooks({super.key});

  @override
  Widget build(BuildContext context) {
    final readBooks = context.watch<ReadBooksProvider>().readBooks;

    return Scaffold(
      appBar: AppBar(
        title: Text('All Read Books'),
      ),
      body: ListView.builder(
        itemCount: readBooks.length,
        itemBuilder: (context, index) {
          final book = readBooks[index];
          return ListTile(
            leading: Image.asset(book['imageUtl']!),
            title: Text(book['title']!),
            subtitle: Text(book['author']!),
          );
        },
      ),
    );
  }
}
