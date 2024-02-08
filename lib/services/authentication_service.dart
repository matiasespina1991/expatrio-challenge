import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../providers/authentication_provider.dart';

import '../widgets/modals.dart';

class AuthenticationService {
  final storage = const FlutterSecureStorage();
  final showModal = ShowModal();
  final AuthProvider authProvider;

  AuthenticationService({required this.authProvider});

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
      final accessToken = data['accessToken'];

      if (accessToken == null) {
        showModal.failedLogin(
          context: context,
          onTapConfirm: () {
            Navigator.of(context).pop();
          },
        );
        debugPrint('Login failed.');
        debugPrint(
            'Reason of failed login: The login request seemed to be successful but accessToken inside the response returned null.');
        return false;
      }

      await storage.write(key: 'auth_token', value: accessToken);

      await authProvider.setAuthToken(accessToken);

      debugPrint('Login successful.');

      return true;
    } else {
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
