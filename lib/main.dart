import 'package:expatrio_challenge/screens/home.dart';
import 'package:expatrio_challenge/theme/expatrio_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expatrio Challenge',
      theme: ExpatrioTheme.themeData,
      home: const MyHomePage(title: 'Expatrio Callenge'),
    );
  }
}
