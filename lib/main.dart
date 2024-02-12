import 'package:expatrio_challenge/providers/authentication_provider.dart';
import 'package:expatrio_challenge/providers/conectivity_provider.dart';
import 'package:expatrio_challenge/providers/current_user_data_provider.dart';
import 'package:expatrio_challenge/providers/current_user_tax_data_provider.dart';
import 'package:expatrio_challenge/screens/dashboard_screen.dart';
import 'package:expatrio_challenge/screens/login_screen.dart';
import 'package:expatrio_challenge/services/authentication_service.dart';
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

class PrimaryScreen extends StatefulWidget {
  const PrimaryScreen({super.key});

  @override
  PrimaryScreenState createState() => PrimaryScreenState();
}

class PrimaryScreenState extends State<PrimaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, CurrentUserDataProvider>(
      builder: (context, authProvider, currentUserDataProvider, _) {
        if (currentUserDataProvider.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            debugPrint(
                'Error found when trying to fetch user data. Logging out.');
            _handleLogout(context);
          });
        }

        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        } else {
          return const DashboardScreen();
        }
      },
    );
  }

  void _handleLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserDataProvider =
        Provider.of<CurrentUserDataProvider>(context, listen: false);
    final AuthenticationService authService = AuthenticationService(
        authProvider: authProvider, userDataProvider: currentUserDataProvider);

    await authProvider.logout();
    bool userIsLoggedOut = await authService.logout();

    if (userIsLoggedOut) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session timed out. Automatically loggin out.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
