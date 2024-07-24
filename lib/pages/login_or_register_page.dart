import 'package:flutter/material.dart';
import 'package:libri/pages/loginPage.dart';
import 'package:libri/pages/register_page.dart';
import 'package:libri/themes/color_schemes.dart';
import 'package:libri/utils/responsive_util.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // initially show login page
  bool showLoginPage = true;

  // toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil().init(context);
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    final primaryColor =
        isLightMode ? ColorSchemes.primaryLight : ColorSchemes.primaryDark;

    return Scaffold(
      backgroundColor: primaryColor,
      body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: showLoginPage
              ? LoginPage(
                  key: ValueKey('login'),
                  onTap: togglePages,
                )
              : RegisterPage(
                  key: ValueKey('register'),
                  onTap: togglePages,
                )),
    );
  }
}
