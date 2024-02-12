import 'dart:developer';

import 'package:expatrio_challenge/models/user_data_model.dart';
import 'package:expatrio_challenge/providers/current_user_tax_data_provider.dart';
import 'package:expatrio_challenge/services/current_user_data_service.dart';
import 'package:expatrio_challenge/services/current_user_tax_data_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mixins/connectivity_snackbar_mixin.dart';
import '../models/user_tax_data_model.dart';
import '../providers/authentication_provider.dart';
import '../providers/conectivity_provider.dart';
import '../providers/current_user_data_provider.dart';
import '../services/authentication_service.dart';
import '../theme/expatrio_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/modals.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>
    with ConnectivitySnackBarMixin {
  bool loadingData = true;
  late ConnectivityProvider _connectivityProvider;
  late String? _userFullName;
  late CurrentUserTaxDataProvider _userTaxDataProvider;
  late CurrentUserDataProvider _userDataProvider;
  final CurrentUserTaxDataService _currentUserTaxDataService =
      CurrentUserTaxDataService();

  @override
  void initState() {
    super.initState();

    loadingData = true;

    _connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);

    _connectivityProvider.addListener(() {
      if (mounted) {
        showConnectivitySnackBar(context, _connectivityProvider.isConnected);
      }

      if (_connectivityProvider.isConnected) {
        _reloadData();
      }
    });
    _userDataProvider =
        Provider.of<CurrentUserDataProvider>(context, listen: false);

    _userTaxDataProvider =
        Provider.of<CurrentUserTaxDataProvider>(context, listen: false);

    loadingData = false;
  }

  @override
  void dispose() {
    _connectivityProvider.removeListener(() {});
    super.dispose();
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
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final AuthenticationService auth = AuthenticationService(
        authProvider: authProvider, userDataProvider: _userDataProvider);

    final bool userIsLoggedOut = await auth.logout(context: context);
    if (userIsLoggedOut) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User successfully logged out.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Failed to log out. Try again later or contact support is the problem persists.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _reloadData() async {
    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.isAuthenticated) {
        await _userDataProvider.loadUserData();
        await _userTaxDataProvider.loadUserTaxData();
      } else {
        goBack(context);
      }
    }
  }

  handleClickUpdateTaxData(
      {required String primaryTaxResidenceSelectedCountry,
      required String primaryTaxId,
      required Map<int, String?> secondaryTaxResidenceSelectedCountries,
      required List<TextEditingController> secondaryTaxIds}) async {
    UserTaxDataModel? userTaxData = _userTaxDataProvider.userTaxData;

    List<TaxResidenceModel> secondaryTaxResidences = [];
    secondaryTaxResidenceSelectedCountries.forEach((key, value) {
      if (value != null) {
        secondaryTaxResidences.add(TaxResidenceModel(
          country: value,
          id: secondaryTaxIds[key].text,
        ));
      }
    });

    if (userTaxData != null) {
      UserTaxDataModel updatedUserTaxData = UserTaxDataModel(
        usPerson: userTaxData.usPerson,
        usTaxId: userTaxData.usTaxId,
        primaryTaxResidence: TaxResidenceModel(
            country: primaryTaxResidenceSelectedCountry, id: primaryTaxId),
        secondaryTaxResidence: secondaryTaxResidences,
        w9FileId: userTaxData.w9FileId,
        w9File: userTaxData.w9File,
      );
      await _userTaxDataProvider.setUserTaxData(updatedUserTaxData);

      bool userTaxDataUpdated =
          await _currentUserTaxDataService.setUserTaxData(updatedUserTaxData);
      if (userTaxDataUpdated) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: ExpatrioTheme.successColor,
              content: Text('User data updated successfully.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: ExpatrioTheme.errorColor,
              content: Text(
                  'An error ocurred when trying to update user data. Please try again later or contact support.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        if (mounted) {
          AuthProvider authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          AuthenticationService authService = AuthenticationService(
              authProvider: authProvider, userDataProvider: _userDataProvider);
          CurrentUserDataService userDataService = CurrentUserDataService();

          UserDataModel? userData = await userDataService.fetchUserData();
          if (userData == null) {
            await authProvider.logout();
            bool userIsLoggedOut = await authService.logout();

            if (userIsLoggedOut) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Session timed out. Automatically loggin out.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
              _userDataProvider.clearError();
            }
          }
        }
      }
    } else {
      debugPrint(
          'Error: User tax data not found. When attempting to update user data, user tax data was not found when trying to fetch user data from the provider.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: ExpatrioTheme.errorColor,
          content: Text('Error updating user data.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await goBack(context);
          },
        ),
      ),
      body: Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, child) {
          if (!connectivityProvider.isConnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'You currently have no internet connection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Consumer<CurrentUserTaxDataProvider>(
            builder: (context, taxDataProvider, child) {
              if (taxDataProvider.userTaxData == null || loadingData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ExpatrioTheme.primaryColor,
                  ),
                );
              }

              return _buildBody(
                  context,
                  Provider.of<CurrentUserDataProvider>(context),
                  _userTaxDataProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      CurrentUserDataProvider userDataProvider,
      CurrentUserTaxDataProvider userTaxDataProvider) {
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
              style: TextStyle(fontSize: 18, color: ExpatrioTheme.errorColor),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                userDataProvider.loadUserData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      _userFullName = getUserName(userDataProvider);
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 55),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_userFullName != null)
              Column(
                children: [
                  Column(
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
                ],
              ),
            const SizedBox(
              height: 35,
            ),
            Image.asset(
              'assets/images/cliparts/data_missing_clipart.png',
              width: 300,
              height: 200,
            ),
            const SizedBox(height: 35),
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

                if (userTaxDataProvider.userTaxData != null) {
                  showModal.updateTaxData(
                    userDataProvider: userDataProvider,
                    userTaxDataProvider: userTaxDataProvider,
                    context: context,
                    onTapSaveTaxData: (primaryTaxResidenceSelectedCountry,
                        primaryTaxId,
                        secondaryTaxResidenceSelectedCountries,
                        secondaryTaxIds) {
                      handleClickUpdateTaxData(
                        primaryTaxResidenceSelectedCountry:
                            primaryTaxResidenceSelectedCountry,
                        primaryTaxId: primaryTaxId,
                        secondaryTaxResidenceSelectedCountries:
                            secondaryTaxResidenceSelectedCountries,
                        secondaryTaxIds: secondaryTaxIds,
                      );
                      Navigator.maybePop(context);
                    },
                  );
                } else {
                  debugPrint(
                      'Error: When attempting to open the modal to update user tax data, the user tax data was not found when trying to fetch user data from the provider.');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: ExpatrioTheme.errorColor,
                      content: Text(
                          'Unable to load user tax data from database. Please try again later or contact support.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
            // const SizedBox(height: 16),
            // ExpatrioButton(
            //   isPrimary: false,
            //   fullWidth: true,
            //   text: 'Log user data',
            //   onPressed: () async {
            //     // UserDataModel? userData = userDataProvider.userData;
            //     //
            //     // if (userData != null) {
            //     //   log('User Data: ${userData.toJson()}');
            //     // } else {
            //     //   debugPrint('User data not found.');
            //     // }
            //     UserTaxDataModel? userTaxData = userTaxDataProvider.userTaxData;
            //
            //     // UserTaxDataModel? userTaxData = _userTaxData;
            //
            //     if (userTaxData != null) {
            //       log('User Tax Data: ${userTaxData.toJson()}');
            //     } else {
            //       debugPrint('User tax data not found.');
            //     }
            //   },
            // ),
          ],
        ),
      );
    }
  }
}
