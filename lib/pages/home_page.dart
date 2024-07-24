import 'package:flutter/material.dart';
import 'package:libri/providers/book_provider.dart';
import 'package:libri/providers/theme_provider.dart';
import 'package:libri/themes/color_schemes.dart';
import 'package:libri/utils/font_manager.dart';
import 'package:libri/utils/responsive_util.dart';
import 'package:provider/provider.dart';

import 'add_new_book_page.dart';
import 'book_details_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      _searchQuery = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil().init(context);
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;
    final themeProvider = Provider.of<ThemeProvider>(context);

    final primaryColor =
        isLightMode ? ColorSchemes.primaryLight : ColorSchemes.primaryDark;
    final secondaryColor =
        isLightMode ? ColorSchemes.secondaryLight : ColorSchemes.secondaryDark;
    final textColor =
        isLightMode ? ColorSchemes.textLight : ColorSchemes.textDark;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: textColor),
              title: Text('Home', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode', style: TextStyle(color: textColor)),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
              secondary: Icon(
                themeProvider.themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: textColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: textColor),
              title: Text('Settings', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings page
              },
            ),
            ListTile(
              leading: Icon(Icons.check, color: textColor),
              title:
                  Text('Mark All as Read', style: TextStyle(color: textColor)),
              onTap: () {
                // Implement functionality for marking all as read
              },
            ),
          ],
        ),
      ),
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: textColor),
                    onPressed: _clearSearchQuery,
                  ),
                ),
                style: TextStyle(color: textColor),
              )
            : Text(
                'Libri',
                style: FontManager.headlineStyle.copyWith(color: textColor),
              ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: _isSearching
            ? []
            : [
                IconButton(
                  icon: Icon(Icons.search, color: textColor),
                  onPressed: _startSearch,
                ),
              ],
      ),
      body: Consumer<BookClass>(
        builder: (context, bookClass, child) {
          final filteredBooks = bookClass.allBooks.where((book) {
            final query = _searchQuery;
            final title = book.title.toLowerCase();
            final author = book.author.toLowerCase();
            return title.contains(query) || author.contains(query);
          }).toList();

          return GridView.builder(
            padding: EdgeInsets.all(ResponsiveUtil.blockSizeHorizontal * 2),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: ResponsiveUtil.blockSizeHorizontal * 2,
              mainAxisSpacing: ResponsiveUtil.blockSizeVertical * 2,
            ),
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              final book = filteredBooks[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailsPage(book: book),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  color: secondaryColor.withOpacity(0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(4)),
                          child: Stack(
                            children: [
                              book.bookImage != null
                                  ? Image.memory(
                                      book.bookImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Container(
                                      color: secondaryColor.withOpacity(0.3),
                                      child: Icon(
                                        Icons.book,
                                        size:
                                            ResponsiveUtil.blockSizeHorizontal *
                                                15,
                                        color: secondaryColor,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            ResponsiveUtil.blockSizeHorizontal * 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: FontManager.bodyStyle.copyWith(
                                color: textColor,
                                fontSize:
                                    ResponsiveUtil.blockSizeHorizontal * 3.5,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                                height: ResponsiveUtil.blockSizeVertical * 0.5),
                            Text(
                              book.author,
                              style: FontManager.bodyStyle.copyWith(
                                color: textColor.withOpacity(0.7),
                                fontSize:
                                    ResponsiveUtil.blockSizeHorizontal * 3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewBookPage()),
          ).then((_) {
            // Refresh the book list when returning from AddNewBookPage
            Provider.of<BookClass>(context, listen: false).getBooks();
          });
        },
        child: Icon(Icons.add, color: primaryColor),
        backgroundColor: secondaryColor,
      ),
    );
  }
}
