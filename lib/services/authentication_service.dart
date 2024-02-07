import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../widgets/modals.dart';

class AuthenticationService {
  final storage = const FlutterSecureStorage();
  final showModal = ShowModal();

  Future<bool> login({context, emailController, passwordController}) async {
    const authEndpoint = 'https://dev-api.expatrio.com/auth/login';

    final response = await http.post(
      Uri.parse(authEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'auth_token', value: data['token']);

      showModal.successfulLogin(
        context: context,
        onTapConfirm: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        },
      );
      debugPrint('Login successful.');
      return true;
    } else {
      showModal.failedLogin(
        context: context,
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
      );
      debugPrint('Login failed.');
      debugPrint('Login error status: ${response.statusCode}');
      debugPrint('Reason of failed login: ${response.body}');
      return false;
    }
  }

  Future<bool> logout({context}) async {
    try {
      await storage.delete(key: 'auth_token');
      return true;
    } catch (e) {
      debugPrint('Logout error: $e');
      showModal.failedLogout(
        context: context,
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
      );
      return false;
    }
  }
}
