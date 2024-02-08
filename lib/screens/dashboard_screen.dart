import 'package:expatrio_challenge/widgets/buttons.dart';
import 'package:expatrio_challenge/widgets/modals.dart';
import 'package:flutter/material.dart';

import '../services/authentication_service.dart';
import '../theme/expatrio_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthenticationService _authService = AuthenticationService();
  final ShowModal _showModal = ShowModal();

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 220,
                child: Text(
                  'We need your tax data in order for you to access your account.',
                  textAlign: TextAlign.center,
                  style: ExpatrioTheme.themeData.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 35),
              ExpatrioButton(
                  fullWidth: true,
                  text: 'Update your tax data',
                  onPressed: () => _showModal.updateTaxData(
                      context: context, onTapConfirm: confirmUpdateTaxData))
            ],
          ),
        ),
      ),
    );
  }

  void confirmUpdateTaxData() {
    Navigator.maybePop(context);
  }

  Future<void> goBack(context) async {
    try {
      await _authService.logout(context: context);
      Navigator.maybePop(context);
    } catch (e) {
      debugPrint('Error when attempting to logout: $e');
    }
  }
}
