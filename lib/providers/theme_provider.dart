import 'package:flutter/material.dart';
import 'package:libri/themes/theme_manager.dart'; // Import ThemeManager

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeData get currentTheme {
    return _themeMode == ThemeMode.dark
        ? ThemeManager.getDarkTheme()
        : ThemeManager.getLightTheme();
  }
}
