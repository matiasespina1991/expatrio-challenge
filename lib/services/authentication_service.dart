import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../screens/home.dart';

class AuthenticationService {
  final storage = const FlutterSecureStorage();

  void login({context, emailController, passwordController}) async {
    final response = await http.post(
      Uri.parse('https://dev-api.expatrio.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'auth_token', value: data['token']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage(title: 'Home')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error en el login'),
      ));
    }
  }
}
