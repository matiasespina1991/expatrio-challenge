import 'package:flutter/material.dart';

class ExpatrioTheme {
  static const Color primaryColor = Color(0xFF40AF9E);

  static ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    useMaterial3: true,
  );
}
