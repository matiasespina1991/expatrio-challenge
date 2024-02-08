import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authentication_provider.dart';
import '../widgets/buttons.dart';
import '../widgets/modals.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          });
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                goBack(context);
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> goBack(BuildContext context) async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).logout();
    } catch (e) {
      debugPrint('Error when attempting to logout: $e');
    }
  }
}
