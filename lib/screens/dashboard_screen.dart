import 'dart:developer';

import 'package:expatrio_challenge/models/user_tax_data_model.dart';
import 'package:expatrio_challenge/providers/user_auth_data_provider.dart';
import 'package:expatrio_challenge/providers/user_tax_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../mixins/connectivity_snackbar_mixin.dart';
import '../models/user_data_model.dart';
import '../providers/authentication_provider.dart';
import '../providers/conectivity_provider.dart';
import '../providers/user_data_provider.dart';
import '../services/current_user_tax_data_service.dart';
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
  final _storage = const FlutterSecureStorage();
  late UserDataProvider _userDataProvider;
  late UserTaxDataProvider _userTaxDataProvider;
  late String? _userName;

  @override
  void initState() {
    super.initState();
    _userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    _userTaxDataProvider =
        Provider.of<UserTaxDataProvider>(context, listen: false);
    _userName = getUserName();
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (_userName != null)
                      Column(
                        children: [
                          Container(
                            height: 200,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Welcome back,',
                                    style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '$_userName.',
                                    style: const TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    const SizedBox(height: 40),
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
                        // UserDataModel? userData = userDataProvider.userData;
                        //
                        // if (userData != null) {
                        //   log('User Data: ${userData.toJson()}');
                        // } else {
                        //   debugPrint('User data not found.');
                        // }

                        UserTaxDataModel? userTaxData =
                            _userTaxDataProvider.userTaxData;

                        if (userTaxData != null) {
                          log('User Tax Data: ${userTaxData.toJson()}');
                        } else {
                          debugPrint('User tax data not found.');
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

  String? getUserName() {
    final userFirstName = _userDataProvider.userData?.firstName;
    final userLastName = _userDataProvider.userData?.lastName;
    if (userFirstName == null || userLastName == null) {
      return null;
    }
    return '$userFirstName $userLastName';
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
