import 'package:expatrio_challenge/providers/user_auth_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../mixins/connectivity_snackbar_mixin.dart';
import '../models/user_data_model.dart';
import '../providers/authentication_provider.dart';
import '../providers/conectivity_provider.dart';
import '../providers/user_data_provider.dart';
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
  late UserDataProvider userDataProvider;

  @override
  void initState() {
    super.initState();
    userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
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
                    const SizedBox(height: 16),
                    ExpatrioButton(
                      isPrimary: false,
                      fullWidth: true,
                      text: 'Fetch user data',
                      onPressed: () async {
                        UserDataModel? userData = userDataProvider.userData;

                        if (userData != null) {
                          debugPrint(
                              'Nombre del usuario: ${userData.firstName} ${userData.lastName}');
                        } else {
                          debugPrint('No se encontraron datos del usuario.');
                        }
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userAuthDataProvider =
          Provider.of<UserAuthDataProvider>(context, listen: false);
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);

      await authProvider.logout();
      await userAuthDataProvider.clearUserAuthData();
      await userDataProvider.clearUserData();
    } catch (e) {
      debugPrint('Error when attempting to logout: $e');
    }
  }
}
