import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authentication_provider.dart';
import '../providers/conectivity_provider.dart';
import '../widgets/buttons.dart';
import '../widgets/modals.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showNoInternetSnackbar = false;
  bool _goBackPressed = false;
  late final ConnectivityProvider _connectivityProvider;

  @override
  void initState() {
    super.initState();
    _connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);
    _connectivityProvider.addListener(_handleConnectivityChange);
  }

  @override
  void dispose() {
    _connectivityProvider.removeListener(_handleConnectivityChange);
    super.dispose();
  }

  void _handleConnectivityChange() {
    final isConnected = _connectivityProvider.isConnected;
    setState(() {
      _showNoInternetSnackbar = !isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_showNoInternetSnackbar) {
    //   print('No internet connection');
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('No internet connection'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAuthenticated) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
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
                  ],
                ),
              ),
            ),
            floatingActionButton: _showNoInternetSnackbar
                ? FloatingActionButton.extended(
                    onPressed: () {},
                    label: const Text('No internet connection'),
                    icon: const Icon(Icons.warning),
                    backgroundColor: Colors.red,
                  )
                : null,
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
    } catch (e) {
      debugPrint('Error when attempting to logout: $e');
    }
  }
}
