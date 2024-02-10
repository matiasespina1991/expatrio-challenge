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
        home: const PrimaryScreen(),
      ),
    );
  }
}

class PrimaryScreen extends StatelessWidget {
  const PrimaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Consumer<CurrentUserDataProvider>(
      builder: (context, userDataProvider, child) {
        if (userDataProvider.fetchingUserData && authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Fetching user data...'),
                  duration: Duration(seconds: 30)),
            );
          });

          Future.delayed(const Duration(seconds: 31), () {
            if (userDataProvider.fetchingUserData &&
                authProvider.isAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: ExpatrioTheme.warningColor,
                  content: Text('Fetching user data is taking too long...'),
                  duration: Duration(seconds: 40),
                ),
              );
            }
          });
        }
        if (userDataProvider.hasError && authProvider.isAuthenticated) {
          debugPrint('Error when trying to fetch user data...');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: ExpatrioTheme.errorColor,
                  content: Text('Error when trying to fetch user data.'),
                  duration: Duration(seconds: 10)),
            );
          });
        }
        if (userDataProvider.userDataFetchedSuccessfully &&
            authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).clearSnackBars();
            const SnackBar(
                backgroundColor: ExpatrioTheme.errorColor,
                content: Text('Error when trying to fetch user data.'),
                duration: Duration(seconds: 10));
          });
        }

        return Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.isAuthenticated
                ? const DashboardScreen()
                : const LoginScreen();
          },
        );
      },
    );
  }
}
