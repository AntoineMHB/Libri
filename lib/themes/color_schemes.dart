import 'package:flutter/material.dart';

class ColorSchemes {
  static const Color primaryLight = Colors.white;
  static const Color secondaryLight = Color(0xFF8B4513);

  static const Color primaryDark = Color(0XFF121212);
  static const Color secondaryDark = Color(0xFFD2691E);

  static const Color textLight = Colors.black;
  static const Color textDark = Colors.white;

  static ColorScheme get lightScheme => const ColorScheme.light(
        primary: primaryLight,
        secondary: secondaryLight,
        onPrimary: textLight,
        onSecondary: primaryLight,
      );

  static ColorScheme get darkScheme => const ColorScheme.dark(
        primary: primaryDark,
        secondary: secondaryDark,
        onPrimary: textDark,
        onSecondary: primaryDark,
      );
}
