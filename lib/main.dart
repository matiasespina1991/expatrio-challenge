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
        ChangeNotifierProvider(create: (_) => CurrentUserAuthDataProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => CurrentUserTaxDataProvider()),
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
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      return !auth.isAuthenticated
          ? const LoginScreen()
          : Consumer<CurrentUserDataProvider>(
              builder: (context, userDataProvider, child) {
                return Consumer<CurrentUserTaxDataProvider>(
                  builder: (context, taxDataProvider, child) {
                    // if (taxDataProvider.userTaxData == null) {
                    //   return const Scaffold(
                    //     body: Center(child: CircularProgressIndicator()),
                    //   );
                    // }

                    return const DashboardScreen();

                    // return Consumer<AuthProvider>(
                    //   builder: (context, auth, _) {
                    //
                    //   },
                    // );
                  },
                );
              },
            );
    });
  }
}
