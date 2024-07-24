import 'dart:convert'; // For Base64 encoding/decoding
import 'dart:typed_data';

class Book {
  int? id;
  String title;
  String author;
  Uint8List? bookImage;
  late bool isRead;
  String description;

  Book({
    this.id,
    required this.title,
    required this.author,
    this.bookImage,
    required this.isRead,
    required this.description,
  });

  // Convert a Book into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'bookImage': bookImage != null ? base64Encode(bookImage!) : null,
      'isRead': isRead ? 1 : 0,
      'description': description,
    };
  }

  // Extract a Book object from a Map.
  factory Book.fromMapObject(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      bookImage:
          map['bookImage'] != null ? base64Decode(map['bookImage']) : null,
      isRead: map['isRead'] == 1 ? true : false,
      description: map['description'],
    );
  }
}
