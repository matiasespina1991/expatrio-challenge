import 'package:flutter/material.dart';

import '../services/authentication_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthenticationService _authService = AuthenticationService();

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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Dashboard',
            ),
          ],
        ),
      ),
    );
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
