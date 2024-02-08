import 'package:flutter/material.dart';

class ExpatrioTheme {
  static const Color primaryColor = Color(0xFF40AF9E);
  static const Color secondaryColor = Colors.white;

  static ThemeData themeData = ThemeData(
    fontFamily: 'Acumin Pro',
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    ),
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
      elevation: 4,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    useMaterial3: true,
  );
}

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
