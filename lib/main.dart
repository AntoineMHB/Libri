import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:libri/pages/auth_page.dart';
import 'package:libri/providers/book_provider.dart';
import 'package:libri/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookClass()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()), // Add ThemeProvider here
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Libri',
      themeMode: themeProvider.themeMode,
      theme: themeProvider.currentTheme,
      home: AuthPage(),
    );
  }
}
