import 'package:flutter/material.dart';

class ExpatrioTheme {
  static const Color primaryColor = Color(0xFF40AF9E);
  static const Color secondaryColor = Colors.white;

  static ThemeData themeData = ThemeData(
    fontFamily: 'Acumin Pro',
    textTheme: _textTheme,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    appBarTheme: const AppBarTheme(
      elevation: 4,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    useMaterial3: true,
  );
}

const _textTheme = TextTheme(
  displayLarge: TextStyle(height: 1.3, letterSpacing: -0.6),
  displayMedium: TextStyle(height: 1.3, letterSpacing: -0.6),
  displaySmall: TextStyle(height: 1.3, letterSpacing: -0.6),
  headlineLarge: TextStyle(height: 1.3, letterSpacing: -0.6),
  headlineMedium: TextStyle(height: 1.3, letterSpacing: -0.6),
  headlineSmall: TextStyle(height: 1.3, letterSpacing: -0.6),
  titleLarge: TextStyle(height: 1.3, letterSpacing: -0.6),
  titleMedium: TextStyle(height: 1.3, letterSpacing: -0.6),
  titleSmall: TextStyle(height: 1.3, letterSpacing: -0.6),
  bodyLarge: TextStyle(height: 1.3, letterSpacing: -0.6),
  bodyMedium: TextStyle(height: 1.2, letterSpacing: -0.6),
  bodySmall: TextStyle(height: 1.3, letterSpacing: -0.6),
  labelLarge: TextStyle(height: 1.3, letterSpacing: -0.6),
  labelMedium: TextStyle(height: 1.3, letterSpacing: -0.6),
  labelSmall: TextStyle(height: 1.3, letterSpacing: -0.6),
);

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
