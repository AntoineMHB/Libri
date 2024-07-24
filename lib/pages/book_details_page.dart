import 'package:flutter/material.dart';
import 'package:libri/models/book.dart';
import 'package:libri/pages/edit_book_page.dart';
import 'package:libri/providers/book_provider.dart';
import 'package:libri/themes/color_schemes.dart';
import 'package:libri/utils/font_manager.dart';
import 'package:libri/utils/responsive_util.dart';
import 'package:provider/provider.dart';

class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil().init(context);
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    final primaryColor =
        isLightMode ? ColorSchemes.primaryLight : ColorSchemes.primaryDark;
    final secondaryColor =
        isLightMode ? ColorSchemes.secondaryLight : ColorSchemes.secondaryDark;
    final textColor =
        isLightMode ? ColorSchemes.textLight : ColorSchemes.textDark;

    return Consumer<BookClass>(
      builder: ((context, provider, child) => Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: Icon(Icons.edit, color: textColor),
                  onPressed: () {
                    provider.titleController.text = book.title;
                    provider.authorController.text = book.author;
                    provider.bookImage = book.bookImage;
                    provider.descriptionController.text =
                        book.description.toString();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBookPage(book: book),
                      ),
                    );
                  },
                ),
                SizedBox(width: ResponsiveUtil.blockSizeHorizontal * 2),
                IconButton(
                  icon: Icon(Icons.delete, color: textColor),
                  onPressed: () {
                    provider.deleteBook(book);
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: ResponsiveUtil.blockSizeHorizontal * 2),
              ],
              backgroundColor: primaryColor,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(ResponsiveUtil.blockSizeHorizontal * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    book.bookImage != null
                        ? Container(
                            constraints: BoxConstraints(
                              maxHeight: ResponsiveUtil.blockSizeVertical * 35,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image.memory(book.bookImage!),
                              ),
                            ),
                          )
                        : Container(
                            height: ResponsiveUtil.blockSizeVertical * 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey,
                            ),
                          ),
                    SizedBox(height: ResponsiveUtil.blockSizeVertical * 2),
                    Text(
                      book.title,
                      style: FontManager.headlineStyle.copyWith(
                        fontSize: ResponsiveUtil.blockSizeHorizontal * 5,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtil.blockSizeVertical * 1),
                    Text(
                      book.author,
                      style: FontManager.bodyStyle.copyWith(
                        fontSize: ResponsiveUtil.blockSizeHorizontal * 4,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtil.blockSizeVertical * 2),
                    Container(
                      padding: EdgeInsets.all(
                          ResponsiveUtil.blockSizeHorizontal * 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: secondaryColor.withOpacity(0.1),
                      ),
                      child: Text(
                        book.description,
                        style: FontManager.bodyStyle.copyWith(
                          fontSize: ResponsiveUtil.blockSizeHorizontal * 3.5,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
