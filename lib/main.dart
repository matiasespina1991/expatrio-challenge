import 'package:expatrio_challenge/providers/authentication_provider.dart';
import 'package:expatrio_challenge/screens/dashboard_screen.dart';
import 'package:expatrio_challenge/screens/login_screen.dart';
import 'package:expatrio_challenge/theme/expatrio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Expatrio Challenge',
        theme: ExpatrioTheme.themeData,
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.isAuthenticated
                ? const DashboardScreen()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
