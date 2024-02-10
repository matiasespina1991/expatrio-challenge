import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../mixins/connectivity_snackbar_mixin.dart';
import '../providers/authentication_provider.dart';
import '../providers/conectivity_provider.dart';
import '../providers/current_user_auth_data_provider.dart';
import '../providers/current_user_data_provider.dart';
import '../services/authentication_service.dart';
import '../widgets/buttons.dart';
import '../widgets/modals.dart';

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
  late String? _userFullName;

  @override
  void initState() {
    super.initState();
    _connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<CurrentUserDataProvider>(context);

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
        body: _buildBody(context, userDataProvider),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, CurrentUserDataProvider userDataProvider) {
    if (userDataProvider.fetchingUserData) {
      return const Center(child: CircularProgressIndicator());
    } else if (userDataProvider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Error when trying to fetch user data.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                userDataProvider.loadUserData();
                // Trigger a reload of user data here if necessary
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      _userFullName = getUserName(userDataProvider);
      return Center(
        child: SizedBox(
          width: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (_userFullName != null)
                Column(
                  children: [
                    SizedBox(
                      height: 220,
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
                              '$_userFullName.',
                              style: const TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              const SizedBox(height: 25),
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

                  // UserTaxDataModel? userTaxData =
                  //     _userTaxDataProvider.userTaxData;
                  //
                  // if (userTaxData != null) {
                  //   log('User Tax Data: ${userTaxData.toJson()}');
                  // } else {
                  //   debugPrint('User tax data not found.');
                  // }
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  String? getUserName(userDataProvider) {
    String? userFullName;
    final userFirstName = userDataProvider.userData?.firstName;
    final userLastName = userDataProvider.userData?.lastName;
    if (userFirstName == null || userLastName == null) {
      return null;
    }
    userFullName = '$userFirstName $userLastName';
    return userFullName;
  }

  Future<void> goBack(BuildContext context) async {
    try {
      setState(() {
        _goBackPressed = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userAuthDataProvider =
          Provider.of<CurrentUserAuthDataProvider>(context, listen: false);
      final userDataProvider =
          Provider.of<CurrentUserDataProvider>(context, listen: false);
      final authenticationService = AuthenticationService(
          authProvider: authProvider, userDataProvider: userDataProvider);

      await authProvider.logout();
      await authenticationService.logout();

      await userAuthDataProvider.clearUserAuthData();
      await userDataProvider.clearUserData();
    } catch (e) {
      debugPrint('Error when attempting to logout: $e');
    }
  }
}
