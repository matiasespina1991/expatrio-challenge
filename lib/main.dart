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

final AuthProvider globalAuthProvider = AuthProvider();
final CurrentUserDataProvider globalUserDataProvider =
    CurrentUserDataProvider(authProvider: globalAuthProvider);

final CurrentUserTaxDataProvider globalUserTaxDataProvider =
    CurrentUserTaxDataProvider();

final ConnectivityProvider globalConnectivityProvider = ConnectivityProvider();

void main() {
  runApp(const ExpatrioChallengeApp());
}

class ExpatrioChallengeApp extends StatelessWidget {
  const ExpatrioChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => globalAuthProvider),
        ChangeNotifierProvider(
            create: (_) =>
                CurrentUserDataProvider(authProvider: globalAuthProvider)),
        ChangeNotifierProvider(create: (_) => globalUserDataProvider),
        ChangeNotifierProvider(create: (_) => globalConnectivityProvider),
        ChangeNotifierProvider(create: (_) => globalUserTaxDataProvider),
      ],
      child: MaterialApp(
        title: 'Expatrio Challenge App',
        theme: ExpatrioTheme.themeData,
        home: const PrimaryScreen(),
      ),
    );
  }
}

class PrimaryScreen extends StatelessWidget {
  const PrimaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isAuthenticated) {
          return const LoginScreen();
        } else {
          return const DashboardScreen();
        }
      },
    );
  }
}
