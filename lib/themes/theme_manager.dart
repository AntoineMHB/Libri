import 'package:flutter/material.dart';
import 'package:libri/themes/color_schemes.dart';
import 'package:libri/utils/font_manager.dart';

class ThemeManager {
  static ThemeData getLightTheme() {
    return ThemeData(
      colorScheme: ColorSchemes.lightScheme,
      fontFamily: FontManager.primaryFont,
      textTheme: TextTheme(
        displayLarge:
            FontManager.headlineStyle.copyWith(color: ColorSchemes.textLight),
        bodyLarge:
            FontManager.bodyStyle.copyWith(color: ColorSchemes.textLight),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      colorScheme: ColorSchemes.darkScheme,
      fontFamily: FontManager.primaryFont,
      textTheme: TextTheme(
        displayLarge:
            FontManager.headlineStyle.copyWith(color: ColorSchemes.textDark),
        bodyLarge: FontManager.bodyStyle.copyWith(color: ColorSchemes.textDark),
      ),
    );
  }
}
