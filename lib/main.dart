import 'package:expatrio_challenge/providers/authentication_provider.dart';
import 'package:expatrio_challenge/providers/conectivity_provider.dart';
import 'package:expatrio_challenge/providers/current_user_auth_data_provider.dart';
import 'package:expatrio_challenge/providers/current_user_data_provider.dart';
import 'package:expatrio_challenge/providers/current_user_tax_data_provider.dart';
import 'package:expatrio_challenge/screens/dashboard_screen.dart';
import 'package:expatrio_challenge/screens/login_screen.dart';
import 'package:expatrio_challenge/theme/expatrio_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ExpatrioChallengeApp());
}

class ExpatrioChallengeApp extends StatelessWidget {
  const ExpatrioChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CurrentUserDataProvider()),
        ChangeNotifierProvider(create: (_) => CurrentUserTaxDataProvider()),
        ChangeNotifierProvider(create: (_) => CurrentUserAuthDataProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: MaterialApp(
        title: 'Expatrio Challenge App',
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
