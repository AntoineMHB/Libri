import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:libri/pages/login_or_register_page.dart';
import 'package:libri/pages/main_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // user is logged in
        if (snapshot.hasData) {
          // return Calculator();
          return MainScreen();
        }

        // user is not logged in
        else {
          return LoginOrRegisterPage();
        }
      },
    ));
  }
}