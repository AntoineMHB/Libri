import 'package:flutter/material.dart';
import 'package:libri/models/book.dart';
import 'package:libri/providers/book_provider.dart';
import 'package:libri/themes/color_schemes.dart';
import 'package:libri/utils/font_manager.dart';
import 'package:libri/utils/responsive_util.dart';
import 'package:provider/provider.dart';

class EditBookPage extends StatefulWidget {
  final Book book;

  const EditBookPage({Key? key, required this.book}) : super(key: key);

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.book.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'Edit Book',
          style: FontManager.headlineStyle.copyWith(color: textColor),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveUtil.blockSizeHorizontal * 4),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: FontManager.bodyStyle.copyWith(
                  color: textColor,
                  fontSize: ResponsiveUtil.blockSizeHorizontal * 4,
                ),
              ),
              SizedBox(height: ResponsiveUtil.blockSizeVertical * 2),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter book description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: ResponsiveUtil.blockSizeVertical * 2),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<BookClass>(context, listen: false)
                        .updateBookDescription(
                            widget.book, _descriptionController.text);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                ),
                child: Text(
                  'Save',
                  style: FontManager.bodyStyle.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
