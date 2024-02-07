import 'package:flutter/material.dart';

class ExpatrioTheme {
  static const Color primaryColor = Color(0xFF40AF9E);

  static ThemeData themeData = ThemeData(
    fontFamily: 'Acumin Pro',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        minimumSize: MaterialStateProperty.all(const Size(200, 50)),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontFamily: 'Acumin Pro',
            fontSize: 16,
            height: 1.7,
          ),
        ),
      ),
    ),
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
