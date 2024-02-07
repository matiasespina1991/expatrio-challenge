import 'package:expatrio_challenge/screens/home.dart';
import 'package:expatrio_challenge/screens/login_screen.dart';
import 'package:expatrio_challenge/theme/expatrio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = FlutterSecureStorage();
    return MaterialApp(
      title: 'Expatrio Challenge',
      theme: ExpatrioTheme.themeData,
      home: FutureBuilder(
        future: storage.read(key: 'auth_token'),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return LoginScreen();
          } else {
            // Si hay token, muestra la pantalla principal (dashboard)
            return HomePage(title: 'Home');
          }
        },
      ),
    );
  }
}
