import 'package:flutter/material.dart';
import 'package:libri/themes/color_schemes.dart';
import 'package:libri/utils/font_manager.dart';
import 'package:libri/utils/responsive_util.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil().init(context);
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    // Use the correct primary and secondary colors based on the theme mode
    final primaryColor =
        isLightMode ? ColorSchemes.primaryLight : ColorSchemes.primaryDark;
    final secondaryColor =
        isLightMode ? ColorSchemes.secondaryLight : ColorSchemes.secondaryDark;
    final textColor =
        isLightMode ? ColorSchemes.textLight : ColorSchemes.textDark;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtil.blockSizeHorizontal * 6),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: FontManager.bodyStyle.copyWith(
          color: textColor,
          fontSize: ResponsiveUtil.blockSizeHorizontal * 4,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: secondaryColor),
            borderRadius:
                BorderRadius.circular(ResponsiveUtil.blockSizeHorizontal * 2),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(
                  ResponsiveUtil.blockSizeHorizontal * 2)),
          fillColor: primaryColor,
          filled: true,
          hintText: hintText,
          hintStyle: FontManager.bodyStyle.copyWith(
            color: textColor.withOpacity(0.5),
            fontSize: ResponsiveUtil.blockSizeHorizontal * 4,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: ResponsiveUtil.blockSizeVertical * 2,
            horizontal: ResponsiveUtil.blockSizeVertical * 4,
          ),
        ),
      ),
    );
  }
}
