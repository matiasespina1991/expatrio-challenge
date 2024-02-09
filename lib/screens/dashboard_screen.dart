import 'package:expatrio_challenge/providers/user_auth_data_provider.dart';
import 'package:expatrio_challenge/services/current_user_tax_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../mixins/connectivity_snackbar_mixin.dart';
import '../providers/authentication_provider.dart';
import '../providers/conectivity_provider.dart';
import '../services/current_user_data_service.dart';
import '../widgets/buttons.dart';
import '../widgets/modals.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>
    with ConnectivitySnackBarMixin {
  bool _goBackPressed = false;
  late ConnectivityProvider _connectivityProvider;
  final storage = const FlutterSecureStorage();

  final CurrentUserData _currentUserData = CurrentUserData();
  final CurrentUserTaxData _currentUserTaxData = CurrentUserTaxData();

  @override
  void initState() {
    super.initState();
    _connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);
    _connectivityProvider.addListener(() {
      showConnectivitySnackBar(context, _connectivityProvider.isConnected);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => LoginScreen(
                userTriedUnauthorizedAccess:
                    _goBackPressed ? null : 'dashboard',
              ),
            ));
          });

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) async {
            setState(() {
              _goBackPressed = didPop;
            });
            await goBack(context);
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  await goBack(context);
                },
              ),
            ),
            body: Center(
              child: SizedBox(
                width: 280,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Uh-Oh!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(
                      width: 220,
                      child: Text(
                        'We need your tax data in order for you to access your account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 35),
                    ExpatrioButton(
                      fullWidth: true,
                      text: 'Update your tax data',
                      onPressed: () {
                        final showModal = ShowModal();
                        showModal.updateTaxData(
                          context: context,
                          onTapConfirm: () {
                            Navigator.maybePop(context);
                          },
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    ExpatrioButton(
                      isPrimary: false,
                      fullWidth: true,
                      text: 'Fetch user data',
                      onPressed: () async {
                        final userId = await storage.read(key: 'user_id');
                        if (userId == null) {
                          debugPrint('User ID not found.');
                          return;
                        }
                        debugPrint('User ID found: $userId');
                        Map<String, dynamic>? data =
                            await _currentUserData.fetchUserProfile();
                        print('data found: $data');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> goBack(BuildContext context) async {
    try {
      setState(() {
        _goBackPressed = true;
      });
      await Provider.of<AuthProvider>(context, listen: false).logout();
      await Provider.of<UserAuthDataProvider>(context, listen: false)
          .clearUserAuthData();
    } catch (e) {
      debugPrint('Error when attempting to logout: $e');
    }
  }
}
