import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libri/models/book.dart';
import 'package:libri/providers/book_provider.dart';
import 'package:libri/themes/color_schemes.dart';
import 'package:libri/utils/font_manager.dart';
import 'package:libri/utils/responsive_util.dart';
import 'package:provider/provider.dart';

class AddNewBookPage extends StatefulWidget {
  const AddNewBookPage({super.key});

  @override
  State<AddNewBookPage> createState() => _AddNewBookPageState();
}

class _AddNewBookPageState extends State<AddNewBookPage> {
  Uint8List? _image;
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookClass = Provider.of<BookClass>(context, listen: false);
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    final primaryColor =
        isLightMode ? ColorSchemes.primaryLight : ColorSchemes.primaryDark;
    final secondaryColor =
        isLightMode ? ColorSchemes.secondaryLight : ColorSchemes.secondaryDark;
    final textColor =
        isLightMode ? ColorSchemes.textLight : ColorSchemes.textDark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Book',
            style: FontManager.headlineStyle.copyWith(color: textColor)),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtil.blockSizeHorizontal * 4),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: bookClass.titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: ResponsiveUtil.blockSizeVertical * 2),
              TextFormField(
                controller: bookClass.authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
              ),
              SizedBox(height: ResponsiveUtil.blockSizeVertical * 2),
              TextFormField(
                controller: bookClass.descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: ResponsiveUtil.blockSizeVertical * 2),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Add a Book image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: primaryColor,
                ),
              ),
              if (_image != null) ...[
                SizedBox(height: ResponsiveUtil.blockSizeVertical * 2),
                Image.memory(_image!, height: 200, fit: BoxFit.cover),
              ],
              SizedBox(height: ResponsiveUtil.blockSizeVertical * 4),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newBook = Book(
                      title: bookClass.titleController.text,
                      author: bookClass.authorController.text,
                      description: bookClass.descriptionController.text,
                      bookImage: _image,
                      isRead: false,
                    );

                    try {
                      await bookClass.insertNewBook(newBook);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Book added successfully')),
                      );

                      Navigator.of(context).pop();
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add book: $error')),
                      );
                    }
                  }
                },
                child: Text('Add Book'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
